#!/bin/bash

# Usage:
# ./backup.sh source destination
# This will replicate everything in the source and place it in
# "destination/source". If anything is deleted in the source, it will
# be deleted in the destination.
# 
# This is based off of the script on the Arch Linux wiki at:
# https://wiki.archlinux.org/index.php/Full_system_backup_with_rsync

if [ $# -lt 1 ]; then
  echo "No source or destination defined. Usage: $0 src destination" >&2
  exit 1
elif [ $# -lt 2 ]; then
  echo "No destination defined. Usage: $0 src destination" >&2
  exit 1
fi

# Check to make sure the source exists
if [ ! -d "$1" ]; then
  echo "Invalid path: $1" >&2
  exit 1
fi

# Check to make sure the destination exists
if [ ! -d "$2" ]; then
  echo "Invalid path: $2" >&2
  exit 1
elif [ ! -w "$2" ]; then
  echo "Directory not writable: $2" >&2
  exit 1
fi

# Log file for the backup
LOG=./"${1}_Backup_from_$(date '+%Y-%m-%d_%T_%A')"

# Give the real path of the backup dir and store in log file
echo "Backup of: " `readlink --canonicalize $1` >> $LOG

#EXCLUDE={
#"",
#"/proc/*"
#}
# Can be used with the following
# rsync -aAXv --exclude=$EXCLUDE $1 $2 


# Run in archive mode, be verbose, perserve extended attributes & access 
# control lists, and delete files in the destination that are not in the
# source.
# $0 - the name of this script
# $1 the source path
# $2 the destination path
# tee is used to write output to log file and stdout


START=$(date +%s)
rsync --archive --verbose --acls --xattrs --delete $1 $2 | tee --append $LOG
FINISH=$(date +%s)

# Write time it took to the log file & stdout
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds" | tee --append $LOG
