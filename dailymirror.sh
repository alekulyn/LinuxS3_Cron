#!/bin/bash

LS_DB="$(pwd)/sched.list"

if [[ (( "$1" == "setup" && -n "$2" ) && -n "$3" ) ]]; then
	FILES_DIR="$2"																		# location of files
	BUCKET="$3"																			# location of the bucket, FORMAT: s3://bucket-name
	
	echo "daily $FILES_DIR $BUCKET" >> $LS_DB
	echo "@daily root $(pwd)/$(basename $0) update" >> /etc/cron.d/s3_cron
elif [[ "$1" == "update" ]]; then
	# Read Table of Contents
	# Fetch each line between the first daily and last daily, and run s3cmd sync
	grep "ds*de" $LS_DB | read MARKER DS MARKER DE
	while [[ "$DS" -le "$DE" ]]; do
		sed '"$DS"!d' $LS_DB | read -a FORMAT
		if [[ ${FORMAT[0]} == "daily" ]]; do
			s3cmd sync -r ${FORMAT[1]}/ ${FORMAT[2]}/$(basename ${FORMAT[1]})/
		fi
		((DS++))
	done
fi