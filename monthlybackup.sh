#!/bin/bash

LS_DB="$(pwd)/sched.list"													# location of backup instructions database

# Check for argument "setup" (with additional two arguments) or "update"
if [[ (( "$1" == "setup" && -n "$2" ) && -n "$3" ) ]]; then
	FILES_DIR="$2"																		# location of files
	BUCKET="$3"																			# location of the bucket, FORMAT: s3://bucket-name
	echo -en "How do you wish your tar archive to be compressed?\nOptions (choose one): .xz .bz2 .gz (or just hit the 'enter' key for none)\n>> "
	read TAR_EXT
	
	# Check if TAR_EXT is valid
	while [[ ! ((( "$TAR_EXT" == ".xz" || "$TAR_EXT" == ".bz2" ) || "$TAR_EXT" == "gz") || -z "$TAR_EXT" ) ]]; do
		echo -n "I'm sorry, but that is not a valid answer.  Try again:  "
		read TAR_EXT
	done
	
	ARCHIVE_DATE="$(basename $FILES_DIR)_monthlyBackup_$(date +"%m-%Y").tar$TAR_EXT"	# name of the tar archive with the date stamp
	
	# tar compression options
	if [[ "$TAR_EXT" == ".gz" ]]; then
		TAR_EXT == -zcf
	elif [[ "$TAR_EXT" == ".bz2" ]]; then
		TAR_EXT == -jcf
	elif [[ "$TAR_EXT" == ".xz" ]]; then
		TAR_EXT == -Jcf
	else
		TAR_EXT == -cf
	fi
	
	echo "monthly $ARCHIVE_DATE $TAR_EXT $FILES_DIR $BUCKET" >> $LS_DB
	echo "@monthly root $(pwd)/$(basename $0) update" >> /etc/cron.d/s3_cron
elif [[ "$1" == "update" ]]; then
	# Read Table of Contents
	# Fetch each line between the first monthly and last monthly, and run tar and s3cmd put
	grep "ms*me" $LS_DB | read MARKER MS MARKER ME
	while [[ "$MS" -le "$ME" ]]; do
		sed '"$MS"!d' $LS_DB | read -a FORMAT
		if [[ ${FORMAT[0]} == "monthly" ]]; do
			tar ${FORMAT[2]} ${FORMAT[1]} ${FORMAT[3]}
			s3cmd put ${FORMAT[1]} ${FORMAT[4]}/${FORMAT[1]}
		fi
		((MS++))
	done
fi