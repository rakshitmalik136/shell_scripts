#This script efficiently monitors a specific process on a Linux system

#!/bin/bash

#check if the function is running or not
is_process_running(){
	if pgrep -x "$1" >/dev/null;
	then
		return 0
	else
		return 1
	fi
}

#restart process usig systemctl
restart_process(){
	local process_name="$1"
	echo "Process '$process_name' is not running. Kindly wait!"

	if sudo systemctl restart "$process_name";
	then
		echo "Process '$process_name' is restarting!"
	else
		echo "Process '$process_name' don't want to run"
	fi
}

# Check if a process name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

process_name="$1"
max_attempts=3
attempt=1

# Loop to check and restart the process
while [ $attempt -le $max_attempts ];
do
    if is_process_running "$process_name";
    then
        echo "Process $process_name is running."
    else
        restart_process "$process_name"
    fi

    attempt=$((attempt + 1))
    sleep 5  # Wait for 5 seconds before the next check
done

echo "Maximum restart attempts reached. Please check the process manually."
