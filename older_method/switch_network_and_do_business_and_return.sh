#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "No arguments received"
    echo "Use command line arguments to specify desired instructions to run over internet"+
    exit 1;
fi

timeout_time=90

while getopts 'sml:' OPTION; do
  case "$OPTION" in
    s)
      echo "short timeout (1 minute) selected"
      timeout_time=60
      ;;
    m)
      echo "medium timeout (4 minutes) selected"
      timeout_time=240
      ;;
    l)
      echo "long timeout (10 minutes) selected"
      timeout_time=600
      ;;
    ?)
      echo "script usage: $(basename \$0) [-s] [-m] [-l]" >&2
      exit 1
      ;;
  esac
done


timeout $timeout_time ./basic_switch_network_script_without_timeout.sh "$@"

status=$?
if [ $status -eq 124 ] #timed out
then
    echo " "
    echo "Exiting due to timeout"
    echo "This may occur because an install command is waiting for Y/n input"
    echo "This can be prevented by using the -y argument with apt install or apt-get install"
    echo "If timeout is occurring too soon, you can increase the timeout_time variable in this script"
    sudo rm /etc/netplan/50-cloud-init.yaml
echo "removed current yaml file"
    sudo mv ./50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
echo "moved back original yaml file"
    sudo netplan apply
echo "netplan applied"
    echo -en "\007"
    exit 0
fi
exit $status

