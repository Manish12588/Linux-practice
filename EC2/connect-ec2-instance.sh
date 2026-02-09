#!/bin/bash
<<DISCLAIMER
1. In step 2 we are connecting the EC2 instance so please provide the correct path to run.
DISCLAIMER

source Utilities/utils.sh

print_header "1. GET ALL THE AVAILABLE EC2 INSTANCE"
get_all_available_ec2_instances

read -p "Which Instance you wanted to run, Please provide: " instance_name
read -p "Provide the key file of respective instance: " key_file

#Note: Keep the key file in same directory from where you are running 
print_header "2. CONNECT EC2 INSTANCE VIA SSH"
print_purpose "Connect ec2 instance via SSH. Provide <Instance Name> and <Keyfile>"
connect_ec2_via_ssh "$instance_name" "$key_file"