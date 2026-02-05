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

get_current_user(){
    user=$(whoami)
    echo "$user"
}