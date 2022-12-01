# turtlebot_tools
Tools to help interface with Turtlebots

TOOL TO SWITCH NETWORK, RUN COMMANDS, AND RETURN
- First, edit the file in the netplan_internet direcotry with the appropriate SSID and password for internet-connected WIFI
- Run ./switch_network_and_do_business_and_return.sh with command line arguments (each one enclosed in quotes and separated by space) to specify what commands should be executed while on the internet-connected network. This has a safety timeout (default is set to 2 minutes) which can be adjusted in the script.
- Note that ./basic_switch_network_script_without_timeout.sh is called by ./switch_network_and_do_business_and_return.sh and should only be run directly if you're having trouble with command line arugments not working right. In this case, you can run it directly and hardcode your desired commands inside the script.
- Make sure to use the -y argument with any "apt install" or "apt-get install" commands, as this will automatically select the Y option from the (Y/n) prompt.
