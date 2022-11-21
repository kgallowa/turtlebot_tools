#!/bin/bash

echo "Switching networks"
sudo rm /etc/netplan/50-cloud-init.yaml
sudo cp ./netplan_internet/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
sudo netplan apply
echo "Changed network and waiting"
sleep 20
######################################
####PUT DESIRED COMMMANDS TO RUN WHILE ON INTERNET ACCESS HERE
## for apt or apt-get, use apt -y install to automatically answer Yes to install question
#wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS2/latest/opencr_update.tar.bz2
#sudo apt-get -y install libc6:armhf
sudo apt-get update
#######################################
sudo rm /etc/netplan/50-cloud-init.yaml
sudo cp ./netplan_local/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
sudo netplan apply
echo -en "\007"
