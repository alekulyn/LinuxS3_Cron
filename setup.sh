#!/bin/bash
# setup.sh

shopt -s expand_aliases

# Introduction
echo "Welcome.  Please fill out the following information to setup your LinuxS3_Cron."

# Configure location of backup scripts
DAILY="$(pwd)/dailymirror.sh"
MONTHLY="$(pwd)/monthlybackup.sh"

# Configure location of backup directory
echo -e "\nWhere is the directory that you wish to backup?"
read FILES_DIR

# Configure location of bucket
echo -e "\nLocation of the bucket (FORMAT: s3://bucket-name):  "
read BUCKET

# Configure aliases
alias SED_FILESDIR_DAILY="sed -i 's|FILES_DIR=\"\"|FILES_DIR=\"$FILES_DIR\"|' $DAILY"
alias SED_FILESDIR_MONTHLY="sed -i 's|FILES_DIR=\"\"|FILES_DIR=\"$FILES_DIR\"|' $MONTHLY"
alias SED_BUCKET_DAILY="sed -i 's|BUCKET=\"\"|BUCKET=\"$BUCKET\"|' $DAILY"
alias SED_BUCKET_MONTHLY="sed -i 's|BUCKET=\"\"|BUCKET=\"$BUCKET\"|' $MONTHLY"
alias CRON_DAILY="echo \"@daily root $DAILY\" >> /etc/cron.d/s3_cron"
alias CRON_MONTHLY="echo \"@monthly root $MONTHLY\" >> /etc/cron.d/s3_cron"

# Give the user a choice between monthly or daily backups or both DONE
echo -en "\nDo you want (d)aily or (m)onthly backups, or (b)oth?  "
read CHOICE

while [[ ! (( "$CHOICE" == "d" || "$CHOICE" == "m" ) || "$CHOICE" == "b") ]]; do
	echo -n "I'm sorry, but that is not a valid answer.  Try again:  "
	read CHOICE
done

# Configure for daily, monthly, both
if [ "$CHOICE" == "d" ]; then
	SED_FILESDIR_DAILY
	SED_BUCKET_DAILY
	CRON_DAILY
elif [ "$CHOICE" == "m" ]; then
	SED_FILESDIR_MONTHLY
	SED_BUCKET_MONTHLY
	CRON_MONTHLY
else
	SED_FILESDIR_DAILY
	SED_FILESDIR_MONTHLY
	SED_BUCKET_DAILY
	SED_BUCKET_MONTHLY
	CRON_DAILY
	CRON_MONTHLY
fi

# Remove duplicates
sort -u -o /etc/cron.d/s3_cron /etc/cron.d/s3_cron

echo -e "\nConfiguring done."