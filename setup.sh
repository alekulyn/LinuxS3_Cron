#!/bin/bash

# Introduction
echo "Welcome.  Please fill out the following information to setup your LinuxS3_Cron."

# Give the user a choice between monthly or daily backups or both
echo -en "\nDo you want (m)onthly or (d)aily backups, or (b)oth?  "
read CHOICE

while [ !(("$CHOICE" == "m") || ("$CHOICE" == "d") || ("$CHOICE" == "b")) ]; do
	echo "I'm sorry, but that is not a valid answer.  Try again:  "
	read CHOICE
done

# Configure location of backup scripts
MONTHLY="$(pwd)/monthlybackup.sh"
DAILY="$(pwd)/dailymirror.sh"

# Make cron
echo "@monthly root $MONTLY" >> /etc/cron.d/s3_cron
echo "@daily root $MONTHLY" >> /etc/cron.d/s3_cron

# Configure location of backup directory
echo -e "\nDirectory that you want to backup:  "
read FILES_DIR
sed -i "s|FILES_DIR=\"\"|FILES_DIR=\"$FILES_DIR\"|" $DAILY
sed -i "s|FILES_DIR=\"\"|FILES_DIR=\"$FILES_DIR\"|" $MONTHLY

# Configure location of bucket
echo -e "\nLocation of the bucket (FORMAT: s3://bucket-name):  "
read BUCKET
sed -i "s|BUCKET=\"\"|BUCKET=\"$BUCKET\"|" $DAILY
sed -i "s|BUCKET=\"\"|BUCKET=\"$BUCKET\"|" $MONTHLY

echo -e "\nConfiguring done."