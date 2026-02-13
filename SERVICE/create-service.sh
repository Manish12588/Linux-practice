#!/bin/bash

<<USAGE
1. Create a directory
2. Create a log file
2. Create a app using shell file

USAGE

create_directory_for_service() {

    local SERVICE_DIR_NAME=$1

    # Create log directory
    sudo mkdir -p /var/log/$SERVICE_DIR_NAME
    sudo chmod 755 /var/log/$SERVICE_DIR_NAME

    if [ -d "/var/log/$SERVICE_DIR_NAME" ]; then
        echo -e "Directory $SERVICE_DIR_NAME created at: "
        ls -ld /var/log/$SERVICE_DIR_NAME
    else
        echo "Directory $SERVICE_DIR_NAME does not exist."
    fi
}

create_log_file_for_service() {

    local SERVICE_LOG_FILE_NAME=$1

    # Create log file
    sudo touch /var/log/$SERVICE_LOG_FILE_NAME/$SERVICE_LOG_FILE_NAME.log
    sudo chmod 666 /var/log/$SERVICE_LOG_FILE_NAME/$SERVICE_LOG_FILE_NAME.log

    if [ -f "/var/log/$SERVICE_LOG_FILE_NAME/$SERVICE_LOG_FILE_NAME.log" ]; then
        echo -e "Log file $SERVICE_LOG_FILE_NAME.log created at: "
        tree /var/log/$SERVICE_LOG_FILE_NAME
    else
        echo -e "\nLog file $SERVICE_LOG_FILE_NAME.log does not exist."
        exit 1
    fi

}

create_shell_file_for_service() {

    local APP_NAME=$1

    sudo tee /usr/local/bin/$APP_NAME.sh > /dev/null << EOF
#!/bin/bash
LOG_FILE="/var/log/$APP_NAME/$APP_NAME.log"

while true; do
    MESSAGE="Hello from \$(hostname) — \$(date)"
    echo "\$MESSAGE"
    echo "\$MESSAGE" >> "\$LOG_FILE"
    sleep 10
done
EOF

echo -e "Poviding the execute permission to $APP_NAME.sh file."
sudo chmod +x /usr/local/bin/$APP_NAME.sh

    if [ -f "/usr/local/bin/$APP_NAME.sh" ]; then
        echo -e "App file $APP_NAME.sh created at: "
        tree /usr/local/bin
    else
        echo -e "\nApp file $APP_NAME.sh does not exist."
        exit 1
    fi
}

main() {

    read -p "Please provide the service name: " service_name

    if [[ -z "$service_name" ]]; then
    echo "Error: service name cannot be empty"
    exit 1
    fi

    create_directory_for_service $service_name
    create_log_file_for_service $service_name
    create_shell_file_for_service $service_name
    
}
main