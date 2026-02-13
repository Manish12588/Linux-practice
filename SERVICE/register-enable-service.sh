#!/bin/bash

<<USAGE
Register a service as systemd service
USAGE


create_and_enable_service() {
    local SERVICE_NAME=$1

    sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null << EOF
    [Unit]
    Description=$SERVICE_NAME Service
    After=network.target
    Wants=network-online.target

    [Service]
    ExecStart=/usr/local/bin/$SERVICE_NAME.sh
    Restart=always
    StandardOutput=append:/var/log/$SERVICE_NAME/$SERVICE_NAME.log
    StandardError=append:/var/log/$SERVICE_NAME/$SERVICE_NAME.log

    [Install]
    WantedBy=multi-user.target
EOF

    if [ -f "/etc/systemd/system/$SERVICE_NAME.service" ]; then
        echo -e "Service $SERVICE_NAME.service created at: "
        tree /etc/systemd/system | grep "$SERVICE_NAME.service"
    else
        echo -e "\nService $SERVICE_NAME.service does not exist."
        exit 1
    fi

    echo -e "\nReloading daemon..."
    sudo systemctl daemon-reload

    echo -e "\nEnable service.."
    sudo systemctl enable $SERVICE_NAME

    echo -e "\nVerify if service enable."
    systemctl status $SERVICE_NAME.service
} 

main() {

    read -p "Please provide the service name, Which you want to register: " service_name

    if [[ -z "$service_name" ]]; then
    echo "Error: service name cannot be empty"
    exit 1
    fi

    echo -e "\nService registration start for $service_name service.."
    create_and_enable_service $service_name
}
main