#!/bin/bash

source utils.sh

{
# ============
# ADDING USER
# ============

print_header "1. ADDING USER - TOKYO"
print_command "sudo useradd -m tokyo -s /usr/bin/bash" "Creating a user 'tokyo'."
sudo useradd -m tokyo -s /usr/bin/bash
echo "User 'tokyo' created successfully."
print_command "cat /etc/passwd | grep -e 'tokyo' " "Validating the user."
cat /etc/passwd | grep -e "tokyo" 

print_header "2. ADDING USER - PROFESSOR"
print_command "sudo useradd -m professor -s /usr/bin/bash" "Creating a user 'professor'."
sudo useradd -m professor -s /usr/bin/bash
echo "User 'professor' created successfully."
print_command "cat /etc/passwd | grep -e 'professor' " "Validating the user."
cat /etc/passwd | grep -e "professor" 

print_header "3. ADDING USER - BERLIN"
print_command "sudo useradd -m berlin -s /usr/bin/bash" "Creating a user 'berlin'."
sudo useradd -m berlin -s /usr/bin/bash
echo "User 'berlin' created successfully."
print_command "cat /etc/passwd | grep -e 'berlin' " "Validating the user."
cat /etc/passwd | grep -e "berlin" 

# ================================
# BASIC CHOWN OPERATIONS FOR FILE
# ================================

print_header "4. CREATING TEXT FILE"
print_command "touch devops-file.txt" "Creating a text file devops-file.txt"
touch devops-file.txt
echo "Text file devops-file.txt has been created successfully."
print_command "ls -l devops-file.txt" "Validating the file"
ls -l devops-file.txt

print_header "5. CHANGING OWNER OF FILE"
print_command "sudo chown tokyo devops-file.txt" "Changing owner of file devops-file.txt"
sudo chown tokyo devops-file.txt
echo "Ower has been changed successfully."
print_command "ls -l devops-file.txt" "Validating new owner"
ls -l devops-file.txt

# ==============
# ADDING GROUPS
# ==============

print_header "6. ADDING GROUP - HEIST-TEAM"
print_command "sudo groupadd heist-team" "Creating a group 'heist-team'."
sudo groupadd heist-team
echo "Group 'heist-team' created successfully."
print_command "cat /etc/group | grep -e 'heist' " "Validating the group."
cat /etc/group | grep -e "heist"

print_header "7. ADDING GROUP -  PLANNERS"
print_command "sudo groupadd planners" "Creating a group 'planners'."
sudo groupadd planners
echo "Group 'planners' created successfully."
print_command "cat /etc/group | grep -e 'planners' " "Validating the group."
cat /etc/group | grep -e "planners"

# ==================================
# BASIC CHOWN OPERATIONS FOR GROUPS
# ==================================

print_header "8. CREATING TEXT FILE"
print_command "touch team-notes.txt" "Creating a text file team-notes.txt"
touch team-notes.txt
echo "Text file team-notes.txt has been created successfully."
print_command "ls -l team-notes.txt" "Validating the file"
ls -l team-notes.txt

print_header "9. CHANGING GROUP OWNER OF FILE"
print_command "sudo chgrp -v heist-team team-notes.txt" "Changing group owner of file team-notes.txt"
sudo chgrp -v heist-team team-notes.txt
echo "Group owner has been changed successfully."
print_command "ls -l team-notes.txt" "Validating new group owner"
ls -l team-notes.txt


# ==========================================
# COMBINED - CHANGE GROUP AND OWNER FOR FILE
# ==========================================

print_header "10. CREATING YAML FILE"
print_command "touch project-config.yaml" "Creating a text file project-config.yaml"
touch project-config.yaml
echo "YAML file project-config.yaml has been created successfully."
print_command "ls -l project-config.yaml" "Validating the file"
ls -l project-config.yaml

print_header "11. CHANGING OWNER & GROUP OWNER OF FILE"
print_command "sudo chown professor:heist-team project-config.yaml" "Changing owner and group owner of file."
sudo chown professor:heist-team project-config.yaml
echo "Owner and Group owner has been changed successfully."
print_command "ls -l project-config.yaml" "Validating change"
ls -l project-config.yaml

# ===============================================
# COMBINED - CHANGE GROUP AND OWNER FOR DIRECTORY
# ===============================================

print_header "12. CREATING DIRECTORY"
print_command "mkdir app-logs" "Creating directory app-logs"
mkdir app-logs
echo "Directory app-logs been created successfully."
print_command "ls -ld app-logs" "Validating the created directory."
ls -ld app-logs

print_header "13. CHANGING OWNER & GROUP OWNER OF DIRECTORY"
print_command "sudo chown berlin:heist-team app-logs" "Changing owner and group owner of directory."
sudo chown berlin:heist-team app-logs
echo "Owner and Group owner has been changed successfully."
print_command "ls -ld app-logs" "Validating change"
ls -ld app-logs


# ====================
# RECURSIVE OWNERSHIP
# ====================

print_header "14. CREATING DIRECTORIES"
print_command "mkdir -p heist-project/vault" "Creating directories"
mkdir -p heist-project/vault
echo "Directories has been created successfully."
print_command "tree -pug heist-project" "Validating the created directories."
tree -pug heist-project
print_command "mkdir -p heist-project/plans" "Creating directories"
mkdir -p heist-project/plans
echo "Directories has been created successfully."
print_command "tree -pug heist-project" "Validating the created directories."
tree -pug heist-project


print_header "15. CREATING FILES"
print_command "touch heist-project/vault/gold.txt" "Creating files."
touch heist-project/vault/gold.txt
echo "Files has been created successfully."
print_command "tree -pug heist-project" "Validating the created files."
tree -pug heist-project
print_command "touch heist-project/plans/strategy.conf" "Creating files"
touch heist-project/plans/strategy.conf
echo "Files has been created successfully."
print_command "tree -pug heist-project" "Validating the created files."
tree -pug heist-project

print_header "16. CHANGING OWNERSHIP OF ENTIRE DIRECTORY HEIST-PROJECT"
print_command "sudo chown -R professor:planners heist-project/" "Changing ownership."
sudo chown -R professor:planners heist-project/
echo "Ownership has been changed successfully."
print_command "tree -pug heist-project" "Validating change"
tree -pug heist-project

# =========================================================
# CLEAN UP PROCESS - DELETING USER, GROUP, FILES, DIRECTORY
# =========================================================

print_header "17. REMOVE FILE - team-notes.txt"
print_command "rm team-notes.txt" "Removing team-notes.txt file."
rm team-notes.txt
echo "Sucessfully removed team-notes.txt file."
print_command "ls -l team-notes.txt" "Validating the removed file"
ls -l team-notes.txt


print_header "18. REMOVE FILE - devops-file.txt"
print_command "sudo chown manis devops-file.txt" "Changing back the owner"
sudo chown manis devops-file.txt
echo "Ower has been changed successfully."
print_command "ls -l devops-file.txt" "Validating new owner"
ls -l devops-file.txt
print_command "rm devops-file.txt" "Removing devops-file.txt file."
rm devops-file.txt
echo "Sucessfully removed devops-file.txt file."
print_command "ls -l devops-file.txt" "Validating the removed file"
ls -l devops-file.txt


print_header "19. REMOVE FILE - project-config.yaml"
print_command "sudo chown manis:manis project-config.yaml" "Changing back the owner and group owner"
sudo chown manis:manis project-config.yaml
echo "Ower has been changed successfully."
print_command "ls -l project-config.yaml" "Validating new owner"
ls -l project-config.yaml
print_command "rm project-config.yaml" "Removing project-config.yaml file."
rm project-config.yaml
echo "Sucessfully removed project-config.yaml file."
print_command "ls -l project-config.yaml" "Validating the removed file"
ls -l project-config.yaml


print_header "20. REMOVE DIRECTORY - APP-LOGS"
print_command "sudo chown manis:manis app-logs" "Changing back the owner and group owner"
sudo chown manis:manis app-logs
echo "Ower has been changed successfully."
print_command "ls -ld app-logs" "Validating new owner"
ls -ld app-logs
print_command "rm -r app-logs" "Removing app-logs directory."
rm -r app-logs
echo "Sucessfully removed app-logs directory."
print_command "ls -ld app-logs" "Validating the removed directory"
ls -ld app-logs


print_header "21. REMOVE DIRECTORY - HEIST-PROJECT"
print_command "sudo chown -R manis:manis heist-project/" "Changing back the owner and group owner"
sudo chown -R manis:manis heist-project/
echo "Ower has been changed successfully."
print_command "tree -pug heist-project/" "Validating new owner"
tree -pug heist-project/
print_command "rm -r heist-project/" "Removing heist-project directory."
rm -r heist-project/
echo "Sucessfully removed heist-project directory."
print_command "ls -ld heist-project/" "Validating the removed directory"
ls -ld heist-project/


print_header "22. REMOVE GROUP - HEIST-TEAM"
print_command "sudo groupdel heist-team" "Removing a group 'heist-team'."
sudo groupdel heist-team
echo "Group 'heist-team' deleted successfully."
print_command "cat /etc/group | grep -e 'heist-team' " "Validating the deleted group."
cat /etc/group | grep -e "heist-team"

print_header "23. REMOVE GROUP - PLANNERS"
print_command "sudo groupdel planners" "Removing a group 'planners'."
sudo groupdel planners
echo "Group 'planners' deleted successfully."
print_command "cat /etc/group | grep -e 'planners' " "Validating the deleted group."
cat /etc/group | grep -e "planners"

print_header "24. REMOVE USER - TOKYO"
print_command "sudo userdel -r tokyo" "Removing a user 'tokyo'."
sudo userdel -r tokyo
echo "User 'tokyo' deleted successfully."
print_command "cat /etc/passwd | grep -e 'tokyo' " "Validating the deleted user."
cat /etc/passwd | grep -e "tokyo" 

print_header "25. REMOVE USER - PROFESSOR"
print_command "sudo userdel -r professor" "Removing a user 'professor'."
sudo userdel -r professor
echo "User 'professor' deleted successfully."
print_command "cat /etc/passwd | grep -e 'professor' " "Validating the deleted user."
cat /etc/passwd | grep -e "professor" 


print_header "26. REMOVE USER - BERLIN"
print_command "sudo userdel -r berlin" "Removing a user 'berlin'."
sudo userdel -r berlin
echo "User 'berlin' deleted successfully."
print_command "cat /etc/passwd | grep -e 'berlin' " "Validating the deleted user."
cat /etc/passwd | grep -e "berlin" 

}