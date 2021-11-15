#!/bin/bash

# stop execution on error
set -o errexit

# read the input arguments
path_name=$1

# check if with / or not
if [[ "${path_name: -1}" == "/" ]]; then
	path_name="${path_name:0:-1}"
fi

# echo $path_name

for file in "$path_name"/*
do
	if [[ $file =~ .*[/]WP_.*[[:space:]]\([0-9]\).*\.* ]]; then
		new_name=`echo $file | grep -oP '.*[/]WP_[0-9]*_[0-9]*'``echo $file | grep -oP '\..*$'`
		mv "$file" "$new_name"	
	fi
done
exit 0
