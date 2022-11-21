#!/bin/bash

#echo $# arguments
if [ "$#" -lt 1 ]; then
    echo "No arguments received"
    echo "Use command line arguments to specify desired instructions to run over internet"+
    exit 1;
fi

echo "Switching networks"
sudo rm /etc/netplan/50-cloud-init.yaml
sudo cp ./netplan_internet/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
sudo netplan apply
echo "Changed network; delaying a short time to make sure network change complete"
#Need to wait because in some cases it takes a little while to switch over networks
#This could be a parameter
delay_time=20
sleep $delay_time
######################################
####RUN DESIRED COMMMANDS TO RUN WHILE ON INTERNET ACCESS HERE
i=1
for command in "$@"
do
    echo "Running command $i: $command";
    $command
    i=$((i+1));
done
#######################################
function finish {
    sudo rm /etc/netplan/50-cloud-init.yaml
    sudo cp ./netplan_local/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    sudo netplan apply
    echo -en "\007"
}
trap finish EXIT
