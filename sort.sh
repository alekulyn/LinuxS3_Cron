#!/bin/bash

LS_DB="$(pwd)/sched.list"

# Sort cron and remove duplicates
sort -u -o /etc/cron.d/s3_cron /etc/cron.d/s3_cron

# If sched.list has TOC at the beginning
# Delete the first two lines
# Sort
if [[ ( $(sed -n '1p' $LS_DB | grep "ds" $LS_DB) && $(sed -n '2p' $LS_DB | grep "ms" $LS_DB) ) ]]; do
	sed '1,2d' $LS_DB
fi
sort -u -o $LS_DB $LS_DB

# Find first and last line of daily and monthly listings
# Store line numbers (+2) in vars
# http://www.unix.com/shell-programming-and-scripting/17667-using-grep-extract-line-number.html
dlnstart=$(($(grep -n -m1 "daily" $LS_DB | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2))
dlnend=$(tac $LS_DB | grep -m1 "daily"); dlnend=$(($(grep -n "$dlnend" $LS_DB | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2))
mlnstart=$(($(grep -n -m1 "monthly" $LS_DB | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2))
mlnend=$(tac $LS_DB | grep -m1 "monthly"); mlnend=$(($(grep -n "$mlnend" $LS_DB | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2))

# Store line numbers in format "ds $dlnstart de $dlnend ms $mlnstart me $mlnend"
# Concatenate sorted sched.list file to line number format and overwrite sched.list
LNFORMAT="ds $dlnstart de $dlnend\nms $mlnstart me $mlnend\n"
cat $LNFORMAT $LS_DB > $LS_DB
sed -i '/^$/d' $LS_DB