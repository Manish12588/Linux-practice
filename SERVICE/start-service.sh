#!/bin/bash

<<USAGE
Verification of service start.
USAGE


start_and_verify_service() {

    local SERVICE_NAME=$1
    echo -e "Starting Service using: 'sudo systemctl start $SERVICE_NAME.service' command."
    sudo systemctl start $SERVICE_NAME.service

    sudo -e "\nChecking the status of $SERVICE_NAME"
    sudo systemctl status $SERVICE_NAME
}


main() {

  read -p "Please provide the service name to start: " service_name

    if [[ -z "$service_name" ]]; then
    echo "Error: service name cannot be empty"
    exit 1
    fi

    echo -e "\nStarting $service_name service.."
    start_and_verify_service $service_name
}
main