#!/bin/bash

<<USAGE
Stop the service
USAGE


stop_and_verify_service() {

    local SERVICE_NAME=$1
    echo -e "Stopping Service using: 'sudo systemctl stop $SERVICE_NAME.service' command."
    sudo systemctl stop $SERVICE_NAME.service

    sudo -e "\nChecking the status of $SERVICE_NAME"
    sudo systemctl status $SERVICE_NAME
}


main() {

  read -p "Please provide the service name to stop: " service_name

    if [[ -z "$service_name" ]]; then
    echo "Error: service name cannot be empty"
    exit 1
    fi

    echo -e "\nStopping $service_name service.."
    stop_and_verify_service $service_name
}
main