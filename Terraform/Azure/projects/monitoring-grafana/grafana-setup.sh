#!/bin/bash
# This script sets up Grafana on a Linux system.
echo "Setting up Grafana"
echo "===================="
echo "Installing dependencies and updating the system"ls
sudo apt update
sudo apt install wget -y
echo "===================="
echo "Importing the GPG key for the Grafana repository"
sudo mkdir -p /etc/apt/keyrings/
echo "===================="
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "===================="
echo "Adding the Grafana repository for stable releases"
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
echo "===================="
echo "Updating package lists"
sudo apt update
echo "===================="
echo "Installing Grafana"
sudo apt install grafana -y
echo "===================="
echo "Enabling and starting the Grafana service"
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
echo "===================="

