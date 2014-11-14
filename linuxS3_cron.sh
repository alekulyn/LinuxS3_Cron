#!/bin/bash
# linuxS3_cron.sh

# Process argument
if [[ "$1" == "setup" ]]; then
	/bin/bash $(pwd)/setup.sh
#elif [[ "$1" == "ls" || "$1" == "list" ]]; then
	# Feature not available yet
	#/bin/bash $(pwd)/list.sh
elif [[ -z "$1" || ( "$1" == "help" || "$1" == "-h" ) ]]; then
	echo "Usage: linuxS3_cron.sh [OPTION]"
	echo -e "\nOptions:"
	echo -e "  setup\t\t\tStart the setup/configuration process."
	echo -e "  help, -h\t\tPrint this help message and exit."
	echo -e "\nHomepage: https://github.com/alekulyn/LinuxS3_Cron"
else
	echo "Argument not recognized.  Please try again."
fi