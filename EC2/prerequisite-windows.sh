#!/bin/bash

source Utilities/utils.sh

read -p "Do you want to configure aws cli on windows machine (e.g. yes or no): " user_confirmation
echo $user_confirmation

if [[ "$user_confirmation" == "Yes" || "$user_confirmation" == "yes" ]]; then

    echo -e "Please complete the below mentioned steps: \n"

    echo "Step 1: curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip""
    print_purpose "INSTALL AWS CLI ZIP"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    echo "Step 2: unzip awscliv2.zip"
    print_purpose "UNZIP AWS CLI ZIP"
    unzip awscliv2.zip

    echo "Step 3: sudo ./aws/install"
    print_purpose "INSTALL AWS"
    sudo ./aws/install

    echo "Step 4: aws --version"
    print_purpose "CHECK AWS VERSION"
    aws --version

    echo "Step 5: aws configure. (Needs to complete this step manually.) 
            1. YOUR_ACCESS_KEY_ID
            2. YOUR_SECRET_ACCESS_KEY
            3. YOUR_PREFERRED_REGION
            4. OUTPUT_FORMAT (Optional)
            
            Note: You can get your access key and secret key from AWS."
else
    echo "As you choose no, means you have already configured your aws cli."
fi