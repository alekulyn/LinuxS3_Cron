#!/bin/bash
# setup.sh

shopt -s expand_aliases

# Introduction
echo "Welcome.  Please fill out the following information to setup your LinuxS3_Cron."

# Configure location of backup scripts and files
DAILY="$(pwd)/dailymirror.sh"
MONTHLY="$(pwd)/monthlybackup.sh"
LS_DB="$(pwd)/sched.list"

# Configure location of backup directory
echo -e "\nWhere is the directory that you wish to backup?"
read FILES_DIR

# Configure location of bucket
echo -e "\nLocation of the bucket (FORMAT: s3://bucket-name):  "
read BUCKET

# Give the user a choice between monthly or daily backups or both DONE
echo -en "\nDo you want (d)aily or (m)onthly backups, or (b)oth?  "
read CHOICE

while [[ ! (( "$CHOICE" == "d" || "$CHOICE" == "m" ) || "$CHOICE" == "b") ]]; do
	echo -n "I'm sorry, but that is not a valid answer.  Try again:  "
	read CHOICE
done

# Configure for daily, monthly, both
if [ "$CHOICE" == "d" ]; then
	/bin/bash $DAILY setup $FILES_DIR $BUCKET
elif [ "$CHOICE" == "m" ]; then
	/bin/bash $MONTHLY setup $FILES_DIR $BUCKET
else
	/bin/bash $DAILY setup $FILES_DIR $BUCKET
	/bin/bash $MONTHLY setup $FILES_DIR $BUCKET
fi

# Remove duplicates
sort -u -o /etc/cron.d/s3_cron /etc/cron.d/s3_cron
sort -u -o $LS_DB $LS_DB

echo -e "\nConfiguring done."