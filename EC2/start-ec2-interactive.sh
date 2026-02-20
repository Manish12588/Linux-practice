#!/bin/bash

source Utilities/utils.sh

print_header "1. GET ALL THE AVAILABLE EC2 INSTANCE"
get_all_available_ec2_instances
select_ec2_instance

print_header "2. GET THE STATE AND INSTANCE ID OF GIVEN INSTANCE "
print_purpose "Get the state of $instance_name instance"
get_instance_id_and_state "$instance_name"

print_header "3. RUNNING EC2 INSTANCE"
print_purpose "Running '$instance_name' ec2 instance"
run_ec2_instance $instance_name

#Note: Keep the key file in same directory from where you are running 
#print_header "4. CONNECT EC2 INSTANCE VIA SSH"
#print_purpose "Connect ec2 instance via SSH"
#connect_ec2_via_ssh $instance_name "devops-practice-ec2-manish-key.pem"