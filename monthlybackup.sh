#!/bin/bash

LS_DB="$(pwd)/sched.list"													# location of backup instructions database

if [[ "$1" == "setup" && -n "$2" && -n "$3" ]]; then
	FILES_DIR="$2"																		# location of files
	BUCKET="$3"																			# location of the bucket, FORMAT: s3://bucket-name
	echo -en "How do you wish your tar archive to be compressed?\nOptions: .xz .bz2 .gz (or just hit the 'enter' key for none)\n>> "
	read TAR_EXT
	
	# Check if TAR_EXT is valid
	while [[ ! ((( "$TAR_EXT" == ".xz" || "$TAR_EXT" == ".bz2" ) || "$TAR_EXT" == "gz") || -z "$TAR_EXT" ) ]]; do
		echo -n "I'm sorry, but that is not a valid answer.  Try again:  "
		read TAR_EXT
	done
	
	ARCHIVE_DATE="$(basename $FILES_DIR)_monthlyBackup_$(date +"%m-%Y").tar$TAR_EXT"	# name of the tar archive with the date stamp
	
	## tar compression options
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
elif [[ "$1" == "update" ]]; then
	## Read each line in sched.list
	## If line starts with "monthly", read following four variables
	
	tar $TAR_EXT $ARCHIVE_DATE $FILES_DIR
	s3cmd put $ARCHIVE_DATE $BUCKET/$ARCHIVE_DATE
fi