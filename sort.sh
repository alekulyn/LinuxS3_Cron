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
if [[ $(grep "daily" $LS_DB) ]]; do
	dlnstart=$(($(grep -n -m1 "daily" $LS_DB | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2))
	dlnend=$(($(grep -n "daily" $LS_DB | tac | grep -m1 "daily" | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2));
else
	dlnstart="nod"
	dlnend="nod"
fi
if [[ $(grep "monthly" $LS_DB) ]]; do
	mlnstart=$(($(grep -n -m1 "monthly" $LS_DB | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2))
	mlnend=$(($(grep -n "monthly" $LS_DB | tac | grep -m1 "monthly" | sed -n 's/^\([0-9]*\)[:].*/\1/p') + 2));
else
	mlnstart="nom"
	mlnend="nom"
fi

# Store line numbers in format "ds $dlnstart de $dlnend ms $mlnstart me $mlnend"
# Concatenate sorted sched.list file to line number format and overwrite sched.list
LNFORMAT="ds $dlnstart de $dlnend\nms $mlnstart me $mlnend\n"
cat $LNFORMAT $LS_DB > $LS_DB
sed -i '/^$/d' $LS_DB