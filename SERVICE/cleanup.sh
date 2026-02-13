#!/bin/bash


cleanup_service() {

    local SERVICE_NAME=$1

    echo -e "\nStopping $SERVICE_NAME"
    sudo systemctl stop $SERVICE_NAME

    echo -e "\nDisable $SERVICE_NAME"
    sudo systemctl disable $SERVICE_NAME
    
    echo -e "\nRemoving $SERVICE_NAME service from systemd"
    sudo rm -f /etc/systemd/system/$SERVICE_NAME.service

    echo -e "\nReloading daemon"
    sudo systemctl daemon-reload

    echo -e "\nSystemctl reset"
    sudo systemctl reset-failed
    
    echo -e "\nRemoving $SERVICE_NAME.sh file from /usr/local/bin"
    sudo rm -f /usr/local/bin/$SERVICE_NAME.sh

    echo -e "\nRemoving log file from /var/log"
    sudo rm -rf /var/log/$SERVICE_NAME

    echo -e "\nCleanup complete!"

}


main() {

  read -p "Service Name: " service_name

    if [[ -z "$service_name" ]]; then
    echo "Error: service name cannot be empty"
    exit 1
    fi

    echo -e "\nStarting cleaning process for $service_name service.."
    cleanup_service $service_name
}
main