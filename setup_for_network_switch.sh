#!/bin/bash

#Create /home/USER/bin directory to hold script
echo "Creating HOME/bin directory and copying executable there"
mkdir ${HOME}/bin
cp switch_network_and_run_commands_and_return.sh ${HOME}/bin

#Add the HOME/bin directory to the path
echo "Adding HOME/bin to path"
  echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

#Set up the TB_TOOLS_HOME variable
if [[ -z "${TB_TOOLS_HOME}" ]]; then
  echo "Creating TB_TOOLS_HOME variable to point to this directory"
  echo 'export TB_TOOLS_HOME='"$PWD"'' >> ~/.bashrc
fi

#Prompt the user to source bashrc
echo "There are two last steps you need to do to complete the setup:"
echo "1) Fill out the file in the netplan_internet directory with the SSID"
echo " and password for your internet-connected network"
echo "2) Either open a new terminal or type source ~/.bashrc"

