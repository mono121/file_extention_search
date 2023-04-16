#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 directory"
    exit 1
fi

dir="$1"

# Find all directories in $dir and process each one
find "$dir" -type d | while read -r subdir; do
    if [ "$(ls -A "$subdir")" ]; then  # Check if directory has files
        printf "Directory: %s\n" "$subdir"
        # Count the number of files, total file size, and number of files for each extension
        find "$subdir" -type f | awk -F . '{if (NF>1) {print $NF} else {print "NoExtension"}}' | sort | uniq -c | awk '{printf "%s\t%s\t%s\n", $2, $1, $1/total*100}' total=$(find "$subdir" -type f | wc -l) | while read -r extension count percent; do
            size=$(find "$subdir" -type f -name "*.$extension" -printf "%s\n" | awk '{sum += $1} END {print sum}')
            printf "%-10s %5d %10d KB %5.2f%%\n" "$extension" "$count" "$((size/1024))" "$percent"
        done
        printf "\n"
    fi
done
