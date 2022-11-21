# turtlebot_tools
Tools to help interface with Turtlebots

TOOL TO SWITCH NETWORK, RUN COMMANDS, AND RETURN
- First, edit the files in the netplan_internet and netplan_local directories with the appropriate SSID and password for internet-connected WIFI and local WIFI.
- Run ./switch_network_and_do_business.sh with command line arguments (each one enclosed in quotes and separated by space) to specify what commands should be executed while on the internet-connected network
- The version ./switch_network_and_do_business_with_timeout.sh includes a safety timeout that will automatically return to the local network if a timeout period expires (default is set to 2 minutes).
- Make sure to use the -y argument with any "apt install" or "apt-get install" commands, as this will automatically select the Y option from the (Y/n) prompt.
