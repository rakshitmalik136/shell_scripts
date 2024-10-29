#This script helps users to manage: create, delete, reset, list, help all users.

#!/bin/bash

#create options

function display_usage {
	echo "Usage: $0 [OPTIONS]"
	echo "OPTIONS:"
	echo "-c && -create: creates a new user account"
	echo "-d && -delete: deletes an existing user account"
	echo "-r && -reset: resets password for existing user account"
	echo "-l && -list: lists all users accounts"
	echo "-h && -help: to check the help section"
}

#create a new user
function create_user {
	read -p "Enter the new username: " username

	#check for existing user
	if id "$username" &>/dev/null;
	then
		echo "Error: The user already exists choose different username to create nw user."
	else 
		read -p "Enter password for $username: " password
		useradd -m -p "$password" "$username"
		echo "user account '$username' created succesfully"
	fi
}

#delete a user
function delete_user {
	read -p "Enter username to delete:" username
	
	#checks if the user already exists
	if id "$username" &>/dev/null;
	then
		userdel -r "$username"
		echo "user account '$username' deleted succesfully"
	else
		echo "Error: No user exists of this '$username', please create one."
	fi
}

#reset a user
function reset_password {
	read -p "Enter username to reset password" username

	#check for existing users
	if id "$username" &>/dev/null;
	then
		read -s "Enter new password for '$username': " password
		echo "$username, $password" || chpasswd 
		echo "password for user '$username' reset succesfully"
	else
		echo "Error: User does not exist of which you are trying to change password"
	fi
}

#list all users
function list_users {
	echo "User accounts on the system:"
       	cat /etc/passwd | awk -F: '{ print "- " $1 " (UID: " $3 ")" }'
}

#help section
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

# Command-line argument parsing
while [ $# -gt 0 ];
do
    case "$1" in
        -c|--create)
            create_user
            ;;
        -d|--delete)
            delete_user
            ;;
        -r|--reset)
            reset_password
            ;;
        -l|--list)
            list_users
            ;;
        *)
            echo "Error: Invalid option '$1'. Use '--help' to see available options."
            exit 1
            ;;
    esac
    shift
done


