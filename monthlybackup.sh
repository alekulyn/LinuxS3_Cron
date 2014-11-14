#!/bin/bash

BUCKET=""																	# location of the bucket, FORMAT: s3://bucket-name
FILES_DIR=""																# location of files
FILES_DATE="$(basename $FILES_DIR)_monthlyBackup_$(date +"%m-%Y").tar"		# name of the TAR archive with the date stamp
tar -cf $FILES_DATE $FILES_DIR
s3cmd put $FILES_DATE $BUCKET/$FILES_DATE