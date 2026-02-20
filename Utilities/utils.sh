#!/bin/bash

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Function to print command being executed
print_command() {
    echo -e "${GREEN}Command:${NC} $1"
    echo -e "${GREEN}Purpose:${NC} $2"
    echo "---"
}

print_purpose() {
    echo -e "${GREEN}Purpose:${NC} $1"
    echo "---"
}

get_current_user(){
    user=$(whoami)
    echo $user
}

<<USAGE
Using get_all_available_ec2_instances function we get all the available EC2 Instances
USAGE
get_all_available_ec2_instances() {
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,IP:PublicIpAddress,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table
}

<<USAGE
Using get_instance_id_and_state function will get the ID and State of given instance
USAGE
get_instance_id_and_state() {

    INSTANCE_NAME=$1
    
    instance_state=$(aws ec2 describe-instances \
                        --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                        --query 'Reservations[*].Instances[*].State.Name' \
                        --output text
                    )
    instance_id=$(aws ec2 describe-instances \
                        --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                        --query 'Reservations[*].Instances[*].InstanceId' \
                        --output text
                    )
    echo -e "State: $instance_state \nInstance_id: $instance_id"
}

<<USAGE
Running given EC2 Instance
USAGE
run_ec2_instance() {
    local INSTANCE_NAME=$1
if [ "$instance_state" = "stopped" ]; then
        echo -e "Starting Instance $instance_id...\n"
        aws ec2 start-instances --instance-ids $instance_id >/dev/null              #Starting the instance and storing the output to null
        echo "Waiting for running state..."
        while true;do
            running_state=$(aws ec2 describe-instances \
                                    --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                                    --query 'Reservations[*].Instances[*].State.Name' \
                                    --output text
                            )
            echo "Current status: $running_state"
            if [ "$running_state" == "running" ];then
                echo "✓ Instance is now $running_state!"
                break
            fi
            sleep 2
        done
else
        echo "Instance $INSTANCE_NAME is already in running or stopping state, Please check."
fi
}

<<USAGE
Stop given EC2 Instance
USAGE
stop_ec2_instance() {
    local INSTANCE_NAME=$1
if [ "$instance_state" = "running" ]; then
        echo -e "Stopping Instance $instance_id...\n"
        aws ec2 stop-instances --instance-ids $instance_id >/dev/null              #Starting the instance and storing the output to null
        echo "Waiting for stopping state..."
        while true;do
            running_state=$(aws ec2 describe-instances \
                                    --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                                    --query 'Reservations[*].Instances[*].State.Name' \
                                    --output text
                            )
            echo "Current status: $running_state"
            if [ "$running_state" = "stopped" ];then
                echo "✓ Instance is now $running_state!"
                break
            fi
            sleep 2
        done
else
        echo "Instance $INSTANCE_NAME is already in stopping or stopped state, Please check."
fi
}

connect_ec2_via_ssh(){

    local INSTANCE_NAME=$1
    local KEY_FILE=$2
    variable=$(find $HOME -type f -name "$KEY_FILE" 2>/dev/null | head -n 1)
    PUBLIC_DNS=$(aws ec2 describe-instances \
                        --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                        --query 'Reservations[*].Instances[*].PublicDnsName' \
                        --output text
                )
    echo -e ssh -i ""$KEY_FILE"" ubuntu@$PUBLIC_DNS "\n"
    ssh -i ""$KEY_FILE"" ubuntu@$PUBLIC_DNS
    
}

copy_files_from_ec2_to_local(){

    local INSTANCE_NAME=$1
    local KEY_FILE=$2
    local FILE_NAME_WITH_PATH=$3
    local LOCAL_DIRECTORY_PATH=$4
    
    variable=$(find $HOME -type f -name "$KEY_FILE" 2>/dev/null | head -n 1)
    PUBLIC_DNS=$(aws ec2 describe-instances \
                        --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                        --query 'Reservations[*].Instances[*].PublicDnsName' \
                        --output text
                )
    echo -e scp -i ""$KEY_FILE"" ubuntu@$PUBLIC_DNS:$FILE_NAME_WITH_PATH $LOCAL_DIRECTORY_PATH
    scp -i ""$KEY_FILE"" ubuntu@$PUBLIC_DNS:$FILE_NAME_WITH_PATH $LOCAL_DIRECTORY_PATH
    
}

copy_dir_from_ec2_to_local(){

    local INSTANCE_NAME=$1
    local KEY_FILE=$2
    local FILE_NAME=$3
    local LOCAL_DIRECTORY_PATH=$4
    
    variable=$(find $HOME -type f -name "$KEY_FILE" 2>/dev/null | head -n 1)
    PUBLIC_DNS=$(aws ec2 describe-instances \
                        --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                        --query 'Reservations[*].Instances[*].PublicDnsName' \
                        --output text
                )
    echo -e scp -r -i ""$KEY_FILE"" ubuntu@$PUBLIC_DNS:$FILE_NAME $LOCAL_DIRECTORY_PATH
    scp -r -i ""$KEY_FILE"" ubuntu@$PUBLIC_DNS:$FILE_NAME $LOCAL_DIRECTORY_PATH
    
}

# ── Arrow key selector ────────────────────────
select_ec2_instance() {
    
    #Fetch All the EC2 Instance and create an INTANCES array 
    mapfile -t INSTANCES < <(
        aws ec2 describe-instances \
            --query 'Reservations[*].Instances[*].Tags[?Key==`Name`]|[][][].Value' \
            --output text | tr '\t' '\n' | sort -u | grep -v '^$'
    )

    #Checking if Instance count is zero, If yes then exiting the code
    if [[ ${#INSTANCES[@]} -eq 0 ]]; then
        echo "No EC2 instances found."
        exit 1
    fi

    local selected=0
    local total=${#INSTANCES[@]}
    local first_draw=true

    while true; do
        if [[ $first_draw == true ]]; then
            echo "Select EC2 Instance  (↑↓ Navigate, Enter Select, q Quit)"
            echo ""
            for i in "${!INSTANCES[@]}"; do
                if [[ $i -eq $selected ]]; then
                    echo "  ▶  ${INSTANCES[$i]}"
                else
                    echo "     ${INSTANCES[$i]}"
                fi
            done
            first_draw=false
        else
            echo -ne "\033[${total}A"
            for i in "${!INSTANCES[@]}"; do
                if [[ $i -eq $selected ]]; then
                    echo "  ▶  ${INSTANCES[$i]}$(printf '\033[K')"
                else
                    echo "     ${INSTANCES[$i]}$(printf '\033[K')"
                fi
            done
        fi

        read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 -t 0.1 seq
            case "$seq" in
                '[A') ((selected--)); [[ $selected -lt 0 ]] && selected=$((total-1)) ;; #Up Arrow
                '[B') ((selected++)); [[ $selected -ge $total ]] && selected=0 ;;       #Down Arrow
            esac
        elif [[ $key == "" ]]; then
            instance_name="${INSTANCES[$selected]}"
            break
        elif [[ $key == "q" ]]; then
            exit 0
        fi
    done
}