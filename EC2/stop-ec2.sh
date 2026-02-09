#!/bin/bash

source Utilities/utils.sh

print_header "1. GET ALL THE AVAILABLE EC2 INSTANCE"
get_all_available_ec2_instances

read -p "Which Instance you wanted to stop, Please provide: " instance_name

print_header "2. GET THE STATE AND INSTANCE ID OF GIVEN INSTANCE "
print_purpose "Get the state of $instance_name instance"
get_instance_id_and_state "$instance_name"

print_header "3. STOPPING EC2 INSTANCE"
print_purpose "Stop '$instance_name' ec2 instance"
stop_ec2_instance $instance_name