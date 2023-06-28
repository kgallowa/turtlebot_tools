#!/bin/bash

if [[ -z "${TB_TOOLS_HOME}" ]]; then
  echo "TB_TOOLS_HOME variable is undefined"
  echo "Please run setup_for_network_switch.sh to set up"
  echo "the environment, and then come back to run this script again"
  exit 1
fi

tb_dir=$TB_TOOLS_HOME

diff ${HOME}/bin/switch_network_and_run_commands_and_return.sh  ${tb_dir}/switch_network_and_run_commands_and_return.sh > diff.txt
if [ -s diff.txt ]; then
  echo "The version of switch_network_and_run_commands_and_return.sh in your HOME/bin directory"
  echo " is different than the original version in the TB_TOOLS_HOME directory. Please make sure"
  echo " the version in the HOME/bin directory incorporates any desired edits, since this is"
  echo " the version that will be run"
  rm diff.txt
  exit 1
fi
rm diff.txt

#Process timeout flag
timeout_time=120
while getopts "t:" opt; do
  case ${opt} in
    t)
      timeout_time=${OPTARG}
      ;;
    :)
      echo "$0: Must supply an argument to -$OPTARG." >&2
      exit 1
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 2
      ;;
  esac
done
shift $(($OPTIND - 1));

#echo $# arguments
if [ "$#" -lt 1 ]; then
    echo "No arguments received"
    echo "Use command line arguments to specify desired instructions to run over internet"
    exit 1;
fi

##Create a log file and make the date the first line
date > ${tb_dir}/logfile.txt

######################################
#####SWITCH OUT NETPLAN CONFIG FILES TO CONNECT TO INTERNET
echo "SWITCHING TO INTERNET-CONNECTED NETWORK"
echo "See you in $timeout_time seconds or when the commands are finished, whichever comes first!"

####Move the original netplan config file to our current directory for temporary storage
###sudo mv /etc/netplan/50-cloud-init.yaml ${tb_dir}/50-cloud-init.yaml
###echo "Moved the current netplan config file to this directory for safekeeping" >> ${tb_dir}/logfile.txt
####Copy our internet-configured netplan config file to the appropriate place in /etc/netplan
###sudo cp ${tb_dir}/netplan_internet/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
###echo "Copied the internet-configured netplan file to /etc/netplan" >> ${tb_dir}/logfile.txt
###sudo netplan apply
nmcli device wifi connect "Kevin iPhone" password "test1234"

echo "Changed network; delaying a short time to make sure network change complete" 
#Need to wait because in some cases it takes a little while to switch over networks
#This could be a parameter
delay_time=10
sleep $delay_time

ifconfig >> ${tb_dir}/logfile.txt
######################################
#####SET OUR FAILSAFE TIMER
{
    sleep $timeout_time
    echo "Switching back to local network"
    echo "Don't ctrl-C until after you see the We're back message"
 
    ###sudo rm /etc/netplan/50-cloud-init.yaml
    ###echo "Removed current netplan file" >> ${tb_dir}/logfile.txt
    ####Move the original netplan config file back to the correct place
    ###sudo mv ${tb_dir}/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    ###echo "copied back the original netplan file" >> ${tb_dir}/logfile.txt
    ###sudo netplan apply
    nmcli device wifi connect ROS_Network password "turtlebot"
    echo -en "\007"
    echo "We're back! You can check logfile.txt to see what happened while we were gone"
} &
TIMEOUT_PID=$!

######################################
####RUN DESIRED COMMMANDS TO RUN WHILE ON INTERNET ACCESS HERE
# This will automatically run any commands included as command line arguments
# for this script, but you can also hardcode commands at this location

i=1
for command in "$@"
do
    echo "Running command $i: $command" >> ${tb_dir}/logfile.txt
    $command >> ${tb_dir}/logfile.txt
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
    echo "Don't ctrl-C until after you see the We're back message"

    ###sudo rm /etc/netplan/50-cloud-init.yaml
    ####Move the original netplan config file back to the correct place
    ###sudo mv ${tb_dir}/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    ###sudo netplan apply
    nmcli device wifi connect ROS_Network password "turtlebot"
    echo -en "\007"
    echo "We're back! You can check logfile.txt to see what happened while we were gone"
fi
}
trap finish EXIT
