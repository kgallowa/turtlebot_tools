#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "No arguments received"
    echo "Use command line arguments to specify desired instructions to run over internet"+
    exit 1;
fi

timeout_time=120

timeout $timeout_time ./switch_network_and_do_business.sh "$@"

status=$?
if [ $status -eq 124 ] #timed out
then
    echo " "
    echo "Exiting due to timeout"
    echo "This may occur because an install command is waiting for Y/n input"
    echo "This can be prevented by using the -y argument with apt install or apt-get install"
    echo "If timeout is occurring too soon, you can increase the timeout_time variable in this script"
    sudo rm /etc/netplan/50-cloud-init.yaml
    sudo cp ./netplan_local/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    sudo netplan apply
    echo -en "\007"
    exit 0
fi
exit $status

