#!/bin/bash

# Introduction
echo "Welcome.  Please fill out the following information to setup your LinuxS3_Cron."

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