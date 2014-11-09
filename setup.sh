#!/bin/bash

# Configure location of backup scripts
S3_CRON="$(pwd)/s3_cron"
sed "s|monthlybackup.sh|$(pwd)/&|" <$S3_CRON >$S3_CRON
sed "s|dailymirror.sh|$(pwd)/&|" <$S3_CRON >$S3_CRON
cp $S3_CRON /etc/cron.d

DAILY="$(pwd)/dailymirror.sh"
MONTHLY="$(pwd)/monthlybackup.sh"
printf "Welcome.  Please fill out the following information to setup your LinuxS3_Cron.\n"

# Configure location of backup directory
printf "Directory that you want to backup:  "
read FILES_DIR
sed "s|FILES_DIR=\"\"|FILES_DIR='$FILES_DIR'|" <$DAILY >$DAILY
sed "s|FILES_DIR=\"\"|FILES_DIR='$FILES_DIR'|" <$MONTHLY >$MONTHLY

# Configure location of bucket
printf "\nLocation of the bucket (FORMAT: s3://bucket-name):  "
read BUCKET
sed "s|BUCKET=\"\"|BUCKET='$BUCKET'|" <$DAILY >$DAILY
sed "s|BUCKET=\"\"|BUCKET='$BUCKET'|" <$MONTHLY >$MONTHLY

echo "Configuring done."