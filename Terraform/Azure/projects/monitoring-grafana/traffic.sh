#!/bin/bash
#This script generates traffic on the webapp to test monitoring setup..

echo "Generating traffic on the web application"
echo "======================================="
WEBAPP_URL="WEBURL"  # Change this to your web application's URL

while true; do
  echo "High traffic for 1 minute..."
  high_duration=$((RANDOM % 46 + 45)) # 45-90 seconds
  end=$((SECONDS+high_duration))
  while [ $SECONDS -lt $end ]; do
    curl -s "$WEBAPP_URL" > /dev/null &
    sleep $((RANDOM % 3 + 1))   # sleep for a random duration between 1 to 3 seconds
  done

  echo "Low traffic for 1 minute..."
  low_duration=$((RANDOM % 46 + 30)) # 30-75 seconds
  end=$((SECONDS+low_duration))                                                                                                                                                                                                                                                                                               
  while [ $SECONDS -lt $end ]; do                                                                                                                                                                                                                                                                                             
    curl -s "$WEBAPP_URL" > /dev/null &                                                                                                                                                                                                                                                                                       
    sleep $((RANDOM % 3 + 1))     # sleep for a random duration between 1 to 3 seconds                                                                                                                                                                                                                                        
  done                                                                                                                                                                                                                                                                                                                        
done