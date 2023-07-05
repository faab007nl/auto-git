#!/bin/bash

if ! git ls-files >& /dev/null; then
  clear
  
  echo "------------------"
  echo "-----Auto Git-----"
  echo "------------------"
  echo ""
  
  echo "The current directory is not a valid git repository!!"
  
  return 0
fi

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

echo "Running as $(whoami)"
echo ""
echo "Please select a ssh key:"

eval "$(ssh-agent -s)" > /dev/null 2>&1

while :
do
    files=$(ls ~/.ssh/)
    i=1
    
    for j in $files
    do
    
    echo "$i. $j"
    file[i]=$j
    i=$(( i + 1 ))
    
    done

    echo ""
    echo "Enter number"
    read -r input
    
    sshFile="${file[${input}]}"
    
    clear

    if [ -z "${sshFile-unset}" ]; then
        echo "------------------"
        echo "-----Auto Git-----"
        echo "------------------"
        echo ""
        
        echo "Running as $(whoami)"
        echo ""
        
        echo "Please select a valid ssh key!"
    else
        break
    fi
done

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

echo "Adding ${sshFile}"
ssh-add ~/.ssh/"$sshFile"

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""
echo "Please enter you git name:"

while :
do
    read -r gitName
    
    clear

    if [ -z "${gitName-unset}" ]; then
        echo "------------------"
        echo "-----Auto Git-----"
        echo "------------------"
        echo ""
        echo "Please enter a valid git name:"
    else
        break
    fi
done

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

echo "Please enter you git email: (Press enter to use filename)"
read -r gitEmail

if [ -z "${gitEmail-unset}" ]; then
  echo "Using filename as email"
  gitName="$sshFile"
  sleep 1
fi

git config user.name "${gitName}"
git config user.email "${gitEmail}"

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

echo "Git configured:"
echo "file: ${sshFile}"
echo "name: ${gitName}"
echo "email: ${gitEmail}"
