#!/bin/bash

#echo $# arguments
if [ "$#" -lt 1 ]; then
    echo "No arguments received"
    echo "Use command line arguments to specify desired instructions to run over internet"+
    exit 1;
fi

timeout_time=120

######################################
#####SWITCH OUT NETPLAN CONFIG FILES TO CONNECT TO INTERNET
echo "SWITCHING TO INTERNET-CONNECTED NETWORK"
echo "See you in $timeout_time seconds or when the commands are finished, whichever comes first!"
#Move the original netplan config file to our current directory for temporary storage
sudo mv /etc/netplan/50-cloud-init.yaml ./50-cloud-init.yaml
#echo "Moved the current netplan config file to this directory for safekeeping"
#Copy our internet-configured netplan config file to the appropriate place in /etc/netplan
sudo cp ./netplan_internet/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
#echo "Copied the internet-configured netplan file to /etc /netplan"
sudo netplan apply
echo "Changed network; delaying a short time to make sure network change complete"
#Need to wait because in some cases it takes a little while to switch over networks
#This could be a parameter
delay_time=20
sleep $delay_time

######################################
#####SET OUR FAILSAFE TIMER
{
    sleep $timeout_time
    echo "Switching back to local network"
    sudo rm /etc/netplan/50-cloud-init.yaml
#    echo "Removed current netplan file"
    #Move the original netplan config file back to the correct place
    sudo mv ./50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
#    echo "copied back the original netplan file"
    sudo netplan apply
    echo -en "\007"
    echo "We're back!"
} &
TIMEOUT_PID=$!

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

######################################
#####FINISH FUNCTION
# This function runs when the process is killed or commands are done
# It first checks if the failsafe timer is still going. If so, then
# we need to kill the failsafe timer and switch back to local network.
# If failsafe timer has already gone off, that means that the switch
# to local network has already occurred and we don't need to do anything.
function finish {
if ps -p $TIMEOUT_PID > /dev/null
then
    echo "Finished commands; terminating sleep timer"
    kill  $TIMEOUT_PID
    echo "Switching back to local network"
    sudo rm /etc/netplan/50-cloud-init.yaml
    #Move the original netplan config file back to the correct place
    sudo mv ./50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    sudo netplan apply
    echo -en "\007"
    echo "We're back!"
fi
}
trap finish EXIT
