#!/bin/bash

#echo $# arguments
if [ "$#" -lt 1 ]; then
    echo "No arguments received"
    echo "Use command line arguments to specify desired instructions to run over internet"+
    exit 1;
fi

echo "Switching to internet-connected network"
#Move the original netplan config file to our current directory for temporary storage
sudo mv /etc/netplan/50-cloud-init.yaml ./50-cloud-init.yaml
#Copy our internet-configured netplan config file to the appropriate place in /etc/netplan
sudo cp ./netplan_internet/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
sudo netplan apply
echo "Changed network; delaying a short time to make sure network change complete"
#Need to wait because in some cases it takes a little while to switch over networks
#This could be a parameter
delay_time=20
sleep $delay_time
######################################
####RUN DESIRED COMMMANDS TO RUN WHILE ON INTERNET ACCESS HERE
# This will automatically run any commands included as command line arguments
# for this script, but you can also hardcode commands at this location

i=1
for command in "$@"
do
    echo "Running command $i: $command";
    $command
    i=$((i+1));
done
#######################################
function finish {
    echo "Switching back to local network"
    sudo rm /etc/netplan/50-cloud-init.yaml
    #Move the original netplan config file back to the correct place
    sudo mv ./50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    sudo netplan apply
    echo -en "\007"
}
trap finish EXIT
