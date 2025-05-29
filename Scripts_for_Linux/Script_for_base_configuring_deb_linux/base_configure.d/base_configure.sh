#!/bin/bash
#-----------------------------------------------------------------------------------
# Script for base configuration of Debian-like OS (for example: Debian, Ubuntu)
# Prod by Alexander Guzeev in 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# This script should be used on a freshly installed Debian OS

# Check that the script is being run as root or another user with sudo privileges
if [[ $EUID -eq 0 ]]
then

    echo -e "This script should be used on a freshly installed Debian OS\n"
    sleep 1s
    # Display the repositories to be added, unnecessary information removed using sed
    echo -e "The following repositories will be specified in the file /etc/apt/sources.list: \n\n$(sed '/^#\|^$/d' techFiles/repo.txt) \n"
    sleep 1s
    # Display the packages to be installed
    echo -e "The following packages will be installed by this script: $(cat techFiles/packageList.txt). \nYou can also optionally apply updates to the OS and install VSCode"
    sleep 2s

    # Initialize variable responseOnFerstQuestion for the case statement that controls script execution
    read -p "Do you want to run the script? Yes/No: " responseOnFerstQuestion

    case $responseOnFerstQuestion in

    "Y" | "y" | "yes" | "YES" | "Yes" | "Д" | "д" | "да" | "ДА" | "Да")
        # Overwrite /etc/apt/sources.list according to the repo.txt file
        echo -e "1. Running the script"
        sleep 1s
        sudo cat techFiles/repo.txt > /etc/apt/sources.list
        echo -e "\n2. The file /etc/apt/sources.list has been overwritten, the main repositories from repo.txt have been added"

        sleep 2s

        # The correction function removes packages that were installed automatically, 
        # because they were required by other packages, but after removing those packages, they are no longer needed.
        function correction {
            sleep 1s
            echo -e "\n5. Running the correction with apt autoremove\n"
            sleep 1s
            sudo apt autoremove -y
            sleep 2s
        }

        sudo apt update 2> techFiles/logs/preerror_update.log

        # If the repository update was successful
        if [ $? -eq 0 ]
            then 
            # The packages listed in packageList.txt will be installed
            echo -e "\n3. The apt update command was applied successfully, package installation will start in 5 seconds: $(cat techFiles/packageList.txt)"
            sleep 5s
            sudo dpkg -a --configure
            sudo apt install -f
            sudo apt install $(cat techFiles/packageList.txt) -y 2> techFiles/logs/preerror_install.log

            # If the package installation was successful
            if [ $? -eq 0 ]
                then echo -e "\n4. PACKAGES: $(cat techFiles/packageList.txt) INSTALLED CORRECTLY"
                # Run the correction function
                correction

                # Loop to update all OS packages to the latest version with triple confirmation in case of incorrect response
                for (( var1=1; var1 <= 3; var1++ ))
                do
                echo -e "\nCheck for available package and kernel updates and install them if any?"
                # Initialize the response variable
                read -p 'Yes/No: ' response
                sleep 1s
                    # If the user agrees - update the OS. It could have been implemented with a case statement, but for demonstration purposes, it's done with if-elif-else
                    if [[ "$response" == "Yes" ]] || [[ "$response" == "yes" ]] || [[ "$response" == "YES" ]] || [[ "$response" == "y" ]] || [[ "$response" == "Y" ]] || [[ "$response" == "Да" ]] || [[ "$response" == "да" ]] || [[ "$response" == "ДА" ]] || [[ "$response" == "д" ]] || [[ "$response" == "Д" ]]
                        then
                        echo -e "\nChecking for OS package updates"
                        sleep 1s
                        sudo apt update
                        echo -e "\nThe installation of available OS updates will begin in 5 seconds"
                        sleep 5s
                        sudo apt dist-upgrade -y
                        sleep 1s
                        echo -e "\nPackage updates have been installed, a reboot is required"
                        break
                    # User refuses to update
                    elif [[ "$response" == "No" ]] || [[ "$response" == "no" ]] || [[ "$response" == "NO" ]] || [[ "$response" == "n" ]] || [[ "$response" == "N" ]] || [[ "$response" == "Нет" ]] || [[ "$response" == "нет" ]] || [[ "$response" == "НЕТ" ]] || [[ "$response" == "н" ]] || [[ "$response" == "Н" ]]
                        then
                        echo -e "You have refused to install OS package updates"
                        break
                    # User entered an invalid response, loop restarts up to three times
                    else
                        echo -e "You entered a word or symbol that cannot be interpreted as a response to the update installation question. Please try again"
                    fi
                done
                sleep 1s
            
                # Check if VSCode is present on the system, if not, offer to install
                echo -e "\nChecking for VSCode in the system"
                sleep 2s
                dpkg --status code &> /dev/null
                
                # If VSCode is already installed
                if [ $? -eq 0 ]
                    then
                    echo -e "\nVSCode is already installed on the system"
                # If VSCode is not installed, offer installation
                else
                    # Installing VSCode. This is done via a case statement
                    for (( var2=1; var2 <= 3; var2++ ))
                    do
                    echo -e "\nThe package is not present on the system. Install Visual Studio Code?"
                    # Initialize responseOnTrhitdQuestion for the case statement
                    read -p "Yes/No: " responseOnTrhitdQuestion
                    sleep 1s
                    case $responseOnTrhitdQuestion in
                        # User agrees to install VSCode
                        "Y" | "y" | "yes" | "YES" | "Yes" | "Д" | "д" | "да" | "ДА" | "Да")
                            sudo apt install software-properties-common apt-transport-https wget gnupg -y
                            wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg
                            echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
                            # Update the package database after adding the repository for VSCode installation
                            sudo apt update
                            # Install VSCode
                            sudo apt install code -y
                            break
                        ;;
                        # User refuses to install VSCode
                        "N" | "n" | "no" | "NO" | "No" | "Н" | "н" | "нет" | "НЕТ" | "Нет")
                            echo -e "You have refused to install VSCode"
                            break
                        ;;
                        # User entered an invalid response
                        *) 
                            echo -e "You entered an invalid response. Please try again"
                        ;;

                    esac
                    done
                fi
            
            # If the package installation failed
            else
                sudo mv techFiles/logs/preerror_install.log techFiles/logs/error_install.log
                echo -e "\n4. One or more packages from the list: $(cat techFiles/packageList.txt) were not installed correctly. The apt install error output has been redirected to the file error_install.log, located at techFiles/logs/"
                # Run the correction function
                correction
            fi
        # Repository update failed
        elif [ $? -ne 0 ]
            then sudo mv techFiles/logs/preerror_update.log techFiles/logs/error_update.log
            echo -e "\n3. The apt update command failed, check your Internet connection and try again. \nIf this doesn't help, the file error_update.log has been created in techFiles/logs/ for analyzing apt update errors"
        fi

        # Remove technical log files that were used during the script execution
        rm techFiles/logs/preerror_update.log 2> /dev/null
        rm techFiles/logs/preerror_install.log 2> /dev/null

        echo -e "\nScript execution is complete"
    ;;

    # User refused to run the script
    "N" | "n" | "no" | "NO" | "No" | "Н" | "н" | "нет" | "НЕТ" | "Нет")
        echo -e "You have refused to run the script"
    ;;

    # User entered an invalid response
    *) 
        echo -e "You entered an invalid response, please run the script again"
    ;;

    esac

# Script was run without sudo privileges
else
    echo -e "You have run the script without superuser privileges. \nPlease run the script as root, or use sudo with a user who has such privileges"
fi