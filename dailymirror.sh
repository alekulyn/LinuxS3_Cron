#!/bin/bash

LS_DB="$(pwd)/sched.list"

if [[ (( "$1" == "setup" && -n "$2" ) && -n "$3" ) ]]; then
	FILES_DIR="$2"																		# location of files
	BUCKET="$3"																			# location of the bucket, FORMAT: s3://bucket-name
	
	echo "daily $FILES_DIR $BUCKET" >> $LS_DB
	echo "@daily root $(pwd)/$(basename $0) update" >> /etc/cron.d/s3_cron
elif [[ "$1" == "update" ]]; then
	## Read each line of sched.list into an array
	## If line starts with "daily", run s3cmd sync
	while read -a FORMAT; do
		if [[ ${FORMAT[0]} == "daily" ]]; do
			s3cmd sync -r ${FORMAT[1]}/ ${FORMAT[2]}/$(basename ${FORMAT[1]})/
		fi
	done < $LS_DB
fi