terraform {
  backend "azurerm" {
    key = "monitoring.terraform.tfstate"
  }

required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}

provider "azuread" {}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}



provider "grafana" {
  url  = "http://${module.vm.public_ip_address}:3000"
  auth = "admin:admin"
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "webapp" {
  source               = "../../modules/webapp"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  prefix               = var.prefix
  tags                 = var.tags
  app_service_plan_sku = var.app_service_plan_sku
  docker_image_name    = var.docker_image_name
  docker_registry_url  = var.docker_registry_url
  webapp_subnet_id     = azurerm_subnet.webapp_subnet.id
}

module "vnet" {
  source               = "../../modules/vnet"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  prefix               = var.prefix
  tags                 = var.tags
  vnet_address_space   = var.vnet_address_space
  subnet_address_space = var.subnet_address_space
}

module "vm" {
  source              = "../../modules/vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  prefix              = var.prefix
  tags                = var.tags
  admin_username      = var.admin_username
  ssh_key             = var.ssh_key
  my_ip_address       = var.my_ip_address
  subnet_id           = module.vnet.subnet_id
}

resource "null_resource" "null_vm" {
  depends_on = [module.vm, module.webapp]
  triggers = {
    webapp_hostname = module.webapp.default_hostname
  }
  connection {
    type        = "ssh"
    user        = var.admin_username
    private_key = file(var.private_ssh_key)
    host        = module.vm.public_ip_address
  }
  provisioner "file" {
    source      = "grafana-setup.sh"
    destination = "/tmp/grafana-setup.sh"
  }
  provisioner "file" {
    source      = "traffic.sh"
    destination = "/tmp/traffic.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/grafana-setup.sh", "sudo /tmp/grafana-setup.sh ", "chmod +x /tmp/traffic.sh", "sed -i 's|WEBURL|https://${module.webapp.default_hostname}|g' /tmp/traffic.sh", "sudo bash -c 'nohup /tmp/traffic.sh > /tmp/traffic.log 2>&1 &'"
    ]
  }

}

# This resource creates a local file named "inventory.yaml" with the content below which is used as an Ansible inventory file to manage the Grafana VM. It includes the necessary variables for SSH access and the public IP for the Grafana VM.
resource "local_file" "ansible_inventory" {
  content  = <<-EOT
  webserver:
    vars:
      ansible_ssh_private_key_file: ${var.private_ssh_key}
      ansible_user: ${var.admin_username}
    hosts:
      grafana-vm:
        ansible_host: ${module.vm.public_ip_address}
  EOT
  filename = "inventory.yaml"
  
}

resource "azuread_application" "grafana_app" {
  display_name = "Grafana-AD-App"
  depends_on   = [null_resource.null_vm]
}

resource "azuread_service_principal" "grafana_sp" {
  client_id = azuread_application.grafana_app.client_id
}

# resource "time_rotating" "month" {
#   rotation_days = 30
# }

resource "azuread_service_principal_password" "grafana_sp_password" {
  service_principal_id = azuread_service_principal.grafana_sp.id
  # rotate_when_changed = { rotation = time_rotating.month.id }
}

resource "azurerm_role_assignment" "grafana_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.grafana_sp.object_id
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = "webapp-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = var.webapp_subnet_address_prefix
  depends_on           = [module.vnet]
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_network_security_rule" "grafana_rule" {
  name                        = "Allow-Grafana-Access"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3000"
  source_address_prefix       = var.my_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = module.vm.nsg_name
}

resource "grafana_data_source" "azure_monitor" {
  type = "grafana-azure-monitor-datasource"
  name = "Azure Monitor"

  json_data_encoded = jsonencode({
    azureAuthType  = "clientsecret"
    cloudName      = "azuremonitor"
    tenantId       = data.azurerm_client_config.current.tenant_id
    clientId       = azuread_application.grafana_app.client_id
    subscriptionId = var.sub_id
  })

  secure_json_data_encoded = jsonencode({
    clientSecret = azuread_service_principal_password.grafana_sp_password.value
  })
  depends_on = [azuread_application.grafana_app, azuread_service_principal.grafana_sp, azuread_service_principal_password.grafana_sp_password, null_resource.null_vm]
}

output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = module.vm.public_ip_address
}


output "default_hostname" {
  description = "The default domain/url of the webapp"
  value       = module.webapp.default_hostname
}


output "grafana_client_id" {
  description = "The client ID of the Grafana Azure AD application"
  value       = azuread_application.grafana_app.client_id
}

output "grafana_client_secret" {
  description = "The client secret of the Grafana Azure AD application"
  value       = azuread_service_principal_password.grafana_sp_password.value
  sensitive   = true
}
