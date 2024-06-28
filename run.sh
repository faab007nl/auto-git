#!/bin/bash
export sshFile=""
export gitName=""
export gitEmail=""

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
    files=$(find ~/.ssh/ -maxdepth 1 -type f)
    i=1
    
    for j in $files
    do
    
    tempfilename=$(basename "$j")
    echo "$i. $tempfilename"
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

chmod 400 "$sshFile"

mkdir -p configs

# Load the config file when file exitst
sshFileName=$(basename "$sshFile")
CONFIG_FILE="configs/${sshFileName}.cfg"
if [[ -f "$CONFIG_FILE" ]]; then
    chmod 600 "$CONFIG_FILE"
    # Load the config file
    source "$CONFIG_FILE"
    CONFIG_CREATED=0
else
    CONFIG_CREATED=1
    touch "${CONFIG_FILE}"
fi

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

echo "Adding ${sshFile}"
ssh-add "$sshFile"

clear

if [[ $CONFIG_CREATED -eq 1 ]]; then

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
        gitEmail="${sshFileName}"
    fi

    if grep -q "^NAME=" "$CONFIG_FILE"; then
        # If the key exists, update its value
        sed -i "s/^NAME=.*/NAME=$gitName/" "$CONFIG_FILE"
    else
        # If the key does not exist, add the key-value pair
        echo "NAME=$gitName" >> "$CONFIG_FILE"
    fi
    if grep -q "^EMAIL=" "$CONFIG_FILE"; then
        # If the key exists, update its value
        sed -i "s/^EMAIL=.*/EMAIL=$gitEmail/" "$CONFIG_FILE"
    else
        # If the key does not exist, add the key-value pair
        echo "EMAIL=$gitEmail" >> "$CONFIG_FILE"
    fi

else
    # Ask user for confirmation
    echo "------------------"
    echo "-----Auto Git-----"
    echo "------------------"
    echo ""
    read -p "Reconfigure git config? (y/n): " answer

    # Process the user's response
    case "$answer" in
        [yY]|[yY][eE][sS])
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
                gitEmail="${sshFileName}"
            fi

            if grep -q "^NAME=" "$CONFIG_FILE"; then
                # If the key exists, update its value
                sed -i "s/^NAME=.*/NAME=$gitName/" "$CONFIG_FILE"
            else
                # If the key does not exist, add the key-value pair
                echo "NAME=$gitName" >> "$CONFIG_FILE"
            fi
            if grep -q "^EMAIL=" "$CONFIG_FILE"; then
                # If the key exists, update its value
                sed -i "s/^EMAIL=.*/EMAIL=$gitEmail/" "$CONFIG_FILE"
            else
                # If the key does not exist, add the key-value pair
                echo "EMAIL=$gitEmail" >> "$CONFIG_FILE"
            fi
            ;;
        [nN]|[nN][oO])
            clear
            ;;
        *)
            clear
            ;;
    esac

    gitName="${NAME}"
    gitEmail="${EMAIL}"
fi

git config user.name "${gitName}"
git config user.email "${gitEmail}"

clear

echo "------------------"
echo "-----Auto Git-----"
echo "------------------"
echo ""

if [[ $CONFIG_CREATED -eq 1 ]]; then
    echo "Git configured:"
else
    echo "Git configured from cfg:"
fi
echo "file: ${sshFile}"
echo "name: ${gitName}"
echo "email: ${gitEmail}"
