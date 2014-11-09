#!/bin/bash

BUCKET=""														# location of the bucket, FORMAT: s3://bucket-name
FILES_DIR=""													# location of files
s3cmd sync -r $FILES_DIR $BUCKET/files