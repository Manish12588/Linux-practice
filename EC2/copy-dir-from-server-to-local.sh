#!/bin/bash

<<Usage
We will copy the file from EC2 server to local machine
Usage

source Utilities/utils.sh

print_header "1. GET ALL THE AVAILABLE EC2 INSTANCE."
get_all_available_ec2_instances

read -p "From Which Instance You Want to Copy Files, Please provide: " instance_name
read -p "Provide the key file of respective instance:                " key_file
read -p "Source Directory Path:                                      " source_dir_path
read -p "Destination Directory Path:                                 " destination_dir_path

print_header "3. COPY DIRECTORY FROM EC2 SERVER TO YOUR LOCAL MACHINE. "
print_purpose "Copy files from $instance_name ec2 instance to your local machine."
copy_dir_from_ec2_to_local "$instance_name" "$key_file" "$source_dir_path" "$destination_dir_path"