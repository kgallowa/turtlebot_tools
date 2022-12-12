#!/bin/bash
if [ -z "$(ls -A /etc/netplan/)" ]; then
    echo "/etc/netplan is empty"
else
    echo "removing current /etc/netplan file"
fi
sudo cp /home/ubuntu/turtlebot_tools/safe_netplan_config/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
