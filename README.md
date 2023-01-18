# turtlebot_tools
Tools to help execute tasks that require internet access on a headless computer.

TOOL TO SWITCH NETWORK, RUN COMMANDS, AND RETURN
- First, run the script setup_for_network_switch.sh, which will configure your environment. It will also prompt you to 
edit the file in the netplan_internet directory with the appropriate SSID and password for internet-connected WIFI.
- The setup file will create a /bin directory under your home workspace to store a copy of the switch_network_and_do_business_and_return.sh script, and it will add the script to your path so you can run it from anywhere.
- Run switch_network_and_do_business_and_return.sh with command line arguments (each one enclosed in quotes and separated by space) to specify what commands should be executed while on the internet-connected network. This has a safety timeout (default is set to 2 minutes) which can be specified with a -t flag and number of seconds (e.g. -t 240 will set the safety timeout to 4 minutes.)
- Make sure to use the -y argument with any "apt install" or "apt-get install" commands, as this will automatically select the Y option from the (Y/n) prompt.
