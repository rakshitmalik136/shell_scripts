#!/bin/bash

# This script creates a timestamped backup of a directory and keeps only the last 3 backups

# Function to display usage instructions
function display_usage() {
	echo "Usage: $0 /path/to/source_directory"
}

# Check if a directory path is provided as an argument
if [ $# -eq 0 ] || [ ! -d "$1" ];
then
	echo "Error: Please provide a valid directory path as an argument."
	display_usage
	exit 1
fi

# Get the source directory from the command-line argument
source_dir="$1"

# Function to create a timestamped backup
function create_backup() {
	# Get the current timestamp
  	timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

  	# Create the backup directory name
  	backup_dir="${source_dir}/backup_${timestamp}"

  	# Create the backup by zipping the source directory
  	zip -r "${backup_dir}.zip" "$source_dir" >/dev/null

  	if [ $? -eq 0 ];
	then
		echo "Backup created successfully: ${backup_dir}.zip"
	else
    		echo "Error: Failed to create backup."
  	fi
}

# Function to keep only the last 3 backups
function perform_rotation() {
  	# List all backup files, sorted by modification time (newest first)
 	 backups=($(ls -t "${source_dir}/backup_"*.zip 2>/dev/null))

 	 # If there are more than 3 backups, remove the oldest ones
	 if [ "${#backups[@]}" -gt 3 ];
	 then
   		 backups_to_remove=("${backups[@]:3}")
		 for backup in "${backups_to_remove[@]}";
		 do
			 rm -f "$backup"
			 echo "Removed old backup: $backup"
		 done
	 fi
}

# Create the backup
create_backup

# Perform backup rotation
perform_rotation
