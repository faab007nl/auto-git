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

eval "$(ssh-agent -s)" > /dev/null 2>&1

echo "Please select a ssh key:"

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
read -r gitName

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

echo "Please enter you git email: (Press enter to use filename)"
read -r gitEmail

if [ -z "$var" ]
then
  echo "Using filename as email"
  gitName = "$sshFile"
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
