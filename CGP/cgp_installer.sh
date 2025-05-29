#!/bin/bash
#  __           _       _      __                                                  
# / _\ ___ _ __(_)_ __ | |_   / _| ___  _ __                                       
# \ \ / __| '__| | '_ \| __| | |_ / _ \| '__|                                      
# _\ \ (__| |  | | |_) | |_  |  _| (_) | |                                         
# \__/\___|_|  |_| .__/ \__| |_|  \___/|_|                                         
#                |_|                                                               
#                  _       _   _                               _                   
#  _   _ _ __   __| | __ _| |_(_)_ __   __ _    __ _ _ __   __| |                  
# | | | | '_ \ / _` |/ _` | __| | '_ \ / _` |  / _` | '_ \ / _` |                  
# | |_| | |_) | (_| | (_| | |_| | | | | (_| | | (_| | | | | (_| |                  
#  \__,_| .__/ \__,_|\__,_|\__|_|_| |_|\__, |  \__,_|_| |_|\__,_|                  
#  _    |_|    _        _ _ _          |___/                                       
# (_)_ __  ___| |_ __ _| | (_)_ __   __ _                                          
# | | '_ \/ __| __/ _` | | | | '_ \ / _` |                                         
# | | | | \__ \ || (_| | | | | | | | (_| |                                         
# |_|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |                                         
#    ___                            |___/     _   ___      _         ___           
#   / __\___  _ __ ___  _ __ ___  _   _ _ __ (_) / _ \__ _| |_ ___  / _ \_ __ ___  
#  / /  / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| |/ /_\/ _` | __/ _ \/ /_)/ '__/ _ \ 
# / /__| (_) | | | | | | | | | | | |_| | | | | / /_\\ (_| | ||  __/ ___/| | | (_) |
# \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_\____/\__,_|\__\___\/    |_|  \___/ 
#
#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# color section
end_color="\e[0m" # Reset color
yellow_b_in_red_back="\e[33;1m\e[41m" # Critical remarks and errors
blue_b_in_red_back="\e[36;1m\e[41m" # Highlighting commands, utilities, and users in critical remarks and errors
blue_b="\e[36;1m" # Request for user action
dark_blue_b="\e[34;1m" # Response options in the user action prompt
green_b="\e[32;1m" # Info
white_b_in_green_back="\e[97;1m\e[42m" # Successful script completion
white_b_in_orange_back="\e[97;1m\e[48;5;130m" # Current version of CGP, retrieved from https://doc.communigatepro.ru/packages/
yellow_b="\e[33;1m" # Warnings
purple="\e[35m" # Start of the script and display of CommuniGate Pro package information
yellow_b_in_purple_back="\e[33;1m\e[45m" # Message for log label assignment

echo -e "${purple}                            ____            _       _                                
                           / ___|  ___ _ __(_)_ __ | |_                              
                           \___ \ / __| '__| | '_ \| __|                             
                            ___) | (__| |  | | |_) | |_                              
                           |____/ \___|_|  |_| .__/ \__|                             
                                             |_|                                     
                 __              _           _        _ _ _                          
                / _| ___  _ __  (_)_ __  ___| |_ __ _| | (_)_ __   __ _              
               | |_ / _ \| '__| | | '_ \/ __| __/ _\` | | | | '_ \ / _\` |             
               |  _| (_) | |    | | | | \__ \ || (_| | | | | | | | (_| |             
               |_|  \___/|_|    |_|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |             
                                                                  |___/              
                             _                   _       _   _                       
              __ _ _ __   __| |  _   _ _ __   __| | __ _| |_(_)_ __   __ _           
             / _\` | '_ \ / _\` | | | | | '_ \ / _\` |/ _\` | __| | '_ \ / _\` |          
            | (_| | | | | (_| | | |_| | |_) | (_| | (_| | |_| | | | | (_| |          
             \__,_|_| |_|\__,_|  \__,_| .__/ \__,_|\__,_|\__|_|_| |_|\__, |          
                                      |_|                            |___/           
   ____                                      _  ____       _         ____            
  / ___|___  _ __ ___  _ __ ___  _   _ _ __ (_)/ ___| __ _| |_ ___  |  _ \ _ __ ___  
 | |   / _ \| '_ \` _ \| '_ \` _ \| | | | '_ \| | |  _ / _\` | __/ _ \ | |_) | '__/ _ \ 
 | |__| (_) | | | | | | | | | | | |_| | | | | | |_| | (_| | ||  __/ |  __/| | | (_) |
  \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_|\____|\__,_|\__\___| |_|   |_|  \___/ 
                                                                                     
 
This script is intended for a fresh installation or updating to the latest version of the EXIM mail server${end_color}
"

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}This script must be run as root.${end_color}"
    echo -e "${yellow_b_in_red_back}Please run the command: sudo su before starting the script.${end_color}"
    exit 1
fi

# Initialize the main directory for script operation
download_dir="/root/CGP-install"
# Check if the directory for script operation exists
if [ ! -d "$download_dir" ]; then
    echo -e "\n${green_b}The directory $download_dir does not exist. The script will use this directory to save the script log, installer file, and by default for backups.
Creating the directory $download_dir...${end_color}"
    mkdir -p "$download_dir"  # Create the directory and all intermediate directories
else
    echo -e "\n${green_b}The script will use the directory $download_dir to save the script log, installer file, and by default for backups.${end_color}"
fi
# Initialize the directory for script logs
log_dir="$download_dir/logs"
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi
# Get the current date and time for timestamps in log file names
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
# Initialize the script log file
LOG_FILE="$log_dir/cgp_installer_$timestamp.log"
# Function to add a timestamp to the log
log_message() {
    echo -e "${yellow_b_in_purple_back}$(date +'%d/%m/%Y_%H:%M:%S') - $1${end_color}"
}
# Duplicate all further script output to the log
exec > >(tee "$LOG_FILE") 2>&1
end_log_message="The script has finished. The script execution log is saved at: $LOG_FILE"

ask_user() {
    local attempts=3
    local choice_question="$1"
    local exit_answer="$2"
    # Variable for a constant response options string
    local various_answer="${dark_blue_b}yes/no (y/n):${end_color}"

    while [ $attempts -gt 0 ]; do
        echo -ne "${blue_b}$choice_question $various_answer${end_color} "
        read user_answer
        user_answer=${user_answer,,} # Convert everything to lowercase
        case "$user_answer" in
            yes|y|д|да) return 0 ;;  # If answer is "yes" or "y", return 0 (yes)
            no|n|н|нет) return 1 ;;   # If answer is "no" or "n", return 1 (no)
            *)
                ((attempts--))
                echo -e "${yellow_b_in_red_back}You entered an invalid answer. Attempts left: $attempts.${end_color}"
                ;;
        esac
    done

    echo -e "${yellow_b_in_red_back}$exit_answer${end_color}"
    log_message "$end_log_message"
    exit 1
}
#----------END OF FUNCTION for asking user response----------#

choice_question_start="Continue running the script?"
exit_answer_start="Script execution has been stopped"

ask_user "$choice_question_start" "$exit_answer_start"
response=$?
if [ $response -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}You canceled the script execution${end_color}"
    exit 0
fi
echo "" # Indentation for formatting
log_message "Script execution started"

# Determine the distribution type
if command -v rpm &>/dev/null; then
    package_type="rpm"  # For RPM-based distributions
    echo -e "\n${green_b}Distribution type: RPM${end_color}"
elif command -v dpkg &>/dev/null; then
    package_type="deb"  # For DEB-based distributions
    echo -e "\n${green_b}Distribution type: DEB${end_color}"
else
    echo -e "\n${yellow_b_in_red_back}This distribution does not support the CommuniGate Pro mail server.${end_color}"
    log_message "$end_log_message"
    exit 1
fi

#----------START OF FUNCTION for asking user response----------#
# Function to ask the user for a yes/no (y/n) response with input validation

#----------START OF FUNCTION for checking internet availability----------#
# Check for internet connectivity using ping
check_internet() {
    echo -e "\nChecking access to the resource doc.communigatepro.ru with the repository for CGP..."
    if ping -c 4 doc.communigatepro.ru &>/dev/null; then
        echo -e "${green_b}The CGP repository resource is available. Parsing https://doc.communigatepro.ru/packages/ for the latest CGP version... ${end_color}\n"
        return 0
    else
        echo -e "${yellow_b}No access to the CGP repository resource, there may be issues with the internet connection, or you may be using a closed network.${end_color}\n"
        return 1
    fi
}
#----------END OF FUNCTION for checking internet availability----------#

#----------START OF FUNCTION for getting the download link----------#
# Function to get the list of links for the latest package versions (deb or rpm)
get_latest_package_url() {
    local cgp_url="https://doc.communigatepro.ru/packages/"

    # Check if curl command is available, and install it if missing
    if ! command -v curl &>/dev/null; then
        # Install curl based on the distribution type
        if [ "$package_type" == "deb" ]; then
            apt update && apt install -y curl
        elif [ "$package_type" == "rpm" ]; then
            # For RPM-based distributions (CentOS, RHEL, Fedora, and others) - prioritize the newer package manager DNF
            if command -v dnf &>/dev/null; then
                dnf install -y curl
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b}To correctly run the script in an open network, the curl utility is required.${end_color}"
                    echo -e "${yellow_b_in_red_back}Downloading or installing the curl utility failed${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            elif command -v yum &>/dev/null; then
                yum install -y curl
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b}To correctly run the script in an open network, the curl utility is required.${end_color}"
                    echo -e "${yellow_b_in_red_back}Downloading or installing the curl utility failed${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                echo "Failed to find a suitable package manager for installing curl."
                log_message "$end_log_message"
                exit 1
            fi
        fi
    fi

    # Download the page and search for links to .deb or .rpm files
    page_content=$(curl -s "$cgp_url")

    if [ "$package_type" == "deb" ]; then
        # Search for links to .deb files, excluding "rc" versions
        mapfile -t package_urls < <(echo "$page_content" | grep -oP 'href="([^"]+\.deb)"' | sed 's/href="//' | sed 's/"//' | grep -v "rc" | grep -i CGatePro-Linux)
    elif [ "$package_type" == "rpm" ]; then
        # Search for links to .rpm files, excluding "rc" versions
        mapfile -t package_urls < <(echo "$page_content" | grep -oP 'href="([^"]+\.rpm)"' | sed 's/href="//' | sed 's/"//' | grep -v "rc" | grep -i CGatePro-Linux)
    fi

    # If there are no links, display an error and terminate the script
    if [ -z "$package_urls" ]; then
        echo -e "${yellow_b_in_red_back}Failed to find a link to the package. The script is terminated.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi

    # Sort the package versions by version number and release, select the latest one
    latest_package=$(printf "%s\n" "${package_urls[@]}" | sort -t'-' -k3,3 -k4,4n | tail -n 1)
    echo "$latest_package"
}
#----------END OF LINK FETCHING FUNCTION----------#

#----------START OF BACKUP FUNCTION----------#
# Backup /var/CommuniGate if it exists and the user has consented to do so
backup_func() {
    if [ "$package_type" == "deb" ]; then
        echo -e "${green_b}Package $deb_package_name-$deb_package_name_version is not installed on the system. Continuing installation...${end_color}\n"
    elif [ "$package_type" == "rpm" ]; then
        echo -e "${green_b}Package $rpm_package_name_version is not installed on the system. Continuing installation...${end_color}\n"
    fi
    
    backup_source="/var/CommuniGate"
    # Function to create a backup from the $backup_source directory using the tar utility
    creating_backup() {
        # Define the backup file name
        local backup_filename="CGP_backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
        local progress=0 # Initialize the progress variable
        local current_backup_fd=0 # Initialize the counter for archive progress
        # Count the total number of files, including those in subdirectories
        local total_backup_fd=$(find "$backup_source" | wc -l)

        if [ $total_backup_fd -eq 0 ]; then
            echo -e "${yellow_b}There are no files in the $backup_source directory for archiving. The backup will not be performed.${end_color}"
            return 1
        fi

        # Start archiving with progress
        tar -czf "$backup_dir/$backup_filename" -C /var CommuniGate --verbose | while read -r line; do
        # Each line represents a file or directory being processed into the archive
            if [[ "$line" =~ .*/.* ]]; then
                # Increment the processed items counter
                current_backup_fd=$((current_backup_fd + 1))
                progress=$((current_backup_fd * 100 / total_backup_fd))
                printf "\rProgress: %3d%%  (Processed %d out of %d)" $progress $current_backup_fd $total_backup_fd
            fi
        done

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "\n${green_b}Backup successfully saved to $backup_dir/$backup_filename${end_color}\n"
        else
            echo "\n${yellow_b_in_red_back}Error occurred while creating the backup. The script is stopped. Please check permissions${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    }

    # backup_source="/var/CommuniGate"
    if [ ! -d "$backup_source" ]; then
        echo -e "${yellow_b}The directory $backup_source is missing on the server. Backup is not needed${end_color}\n"
        return 1
    else
        echo "Directory $backup_source found"
        choice_question_backup="Create a backup of the directory $backup_source in tar.gz format with a timestamp in the backup name?"
        exit_answer_backup="You entered invalid answers, please restart the script"

        ask_user "$choice_question_backup" "$exit_answer_backup"
        response=$?

        if [[ $response -eq 0 ]]; then
            # Initialize the default backup directory
            default_backup_dir="$download_dir/backup"
            # Ask the user to enter the path to the backup directory
            echo -en "${blue_b}Enter the path to the DIRECTORY for saving the backup (default: $default_backup_dir):${end_color} "
            read user_backup_dir
            # Initialize the variable for the backup path, which will either use the user's input or the default path if no input is given
            backup_dir="${user_backup_dir:-$default_backup_dir}"
            if [ "$backup_dir" == "$default_backup_dir" ]; then
                # Check if the backup directory exists
                if [ ! -d "$default_backup_dir" ]; then
                    echo -e "${yellow_b}The default backup directory $default_backup_dir does not exist. Creating it...${end_color}"
                    mkdir -p "$default_backup_dir"  # Create the backup directory
                    echo -e "${green_b} Directory $default_backup_dir created, starting backup creation...${end_color}"
                    creating_backup
                else
                    echo -e "Creating backup of the directory $backup_source..."
                    creating_backup
                fi
            elif [ "$backup_dir" == "$user_backup_dir" ]; then
                if [ ! -d "$user_backup_dir" ]; then
                    echo -e "${yellow_b_in_red_back}The specified directory $user_backup_dir is missing or not mounted as external storage on the server${end_color}"
                    choice_question_error="Continue script execution without creating a backup?"
                    exit_answer_error="You entered invalid answers, please restart the script"

                    ask_user "$choice_question_error" "$exit_answer_error"
                    response=$?
                    if [ $response -ne 0 ]; then
                        echo -e "${yellow_b_in_red_back}You declined to continue the script execution${end_color}"
                        log_message "$end_log_message"
                        exit 0
                    fi
                else
                    creating_backup
                fi
            fi
        else
            echo -e "${yellow_b}You entered a negative answer. The backup of the /var/CommuniGate directory will not be performed.${end_color}\n"
        fi
    fi
}

#----------END OF BACKUP FUNCTION----------#

#----------START OF FUNCTION TO DISABLE FIREWALL----------#
firewall_func() {
    echo -e "${yellow_b}For proper operation of CommuniGate Pro, it is recommended to disable the ufw/firewalld firewall before the first installation${end_color} 
${yellow_b}or clear all iptables/nftables rules on this server and configure them on other forwarding equipment/server${end_color}"
    choice_question_firewall="Would you like the script to disable ufw/firewalld and clear iptables/nftables rules, if these services are present on the server?"
    exit_answer_firewall="You entered invalid answers, please restart the script"

    ask_user "$choice_question_firewall" "$exit_answer_firewall"
    response=$?

    # If the user answered "yes", continue script execution
    if [ $response -eq 0 ]; then
        # Flag to track if any firewall was found
        local firewall_found="false"
        local error_disable_firewall=1

        # Check for ufw and disable it
        if command -v ufw &>/dev/null; then
            echo "ufw is installed. Disabling..."
            ufw disable
            if [ $? -eq 0 ]; then
                echo "ufw disabled."
            else
                echo -e "An error occurred while disabling ufw"
                error_disable_firewall=0
                problem_firewall_ufw="ufw"
            fi
            firewall_found="true"
        fi

        # Check for firewalld and disable it
        if command -v firewall-cmd &>/dev/null; then
            echo "firewalld is installed. Disabling..."
            systemctl disable --now firewalld
            if [ $? -eq 0 ]; then
                echo "firewalld disabled."
            else
                echo -e "An error occurred while disabling firewalld"
                error_disable_firewall=0
                problem_firewall_firewalld="firewalld"
            fi
            firewall_found="true"
        fi

        # Check for iptables and flush rules
        if command -v iptables &>/dev/null; then
            echo "iptables is installed. Clearing rules..."
            iptables -F \
            && iptables -X \
            && iptables -t nat -F \
            && iptables -t nat -X \
            && iptables -t mangle -F \
            && iptables -t mangle -X
            if [ $? -eq 0 ]; then
                echo "iptables rules cleared."
            else
                echo -e "An error occurred while clearing iptables rules"
                error_disable_firewall=0
                problem_firewall_iptables="iptables"
            fi
            firewall_found="true"
        fi

        # Check for nftables and flush rules
        if command -v nft &>/dev/null; then
            echo "nftables is installed. Clearing rules..."
            nft flush ruleset
            if [ $? -eq 0 ]; then
                echo "nftables rules cleared."
            else
                echo -e "An error occurred while clearing nftables rules"
                error_disable_firewall=0
                problem_firewall_nftables="nftables"
            fi
            firewall_found="true"
        fi

        # Check if any firewall was found
        if [ "$firewall_found" == "false" ]; then
            echo -e "${green_b}No supported firewalls are installed on the server: ufw, firewalld, iptables, or nftables.${end_color}\n"
        else
            if [ "$error_disable_firewall" -eq 0 ]; then
                # Initialize an empty string for the result
                local problem_firewalls=""

                # Add variables with spaces if they are initialized
                [ -v problem_firewall_ufw ] && problem_firewalls+="$ufw, "
                [ -v problem_firewall_firewalld ] && problem_firewalls+="$firewalld, "
                [ -v problem_firewall_iptables ] && problem_firewalls+="$nftables, "
                [ -v problem_firewall_nftables ] && problem_firewalls+="$iptables, "

                # Remove trailing comma and space (if any)
                problem_firewalls=$(echo "$problem_firewalls" | sed 's/, $//')
                echo -e "${yellow_b_in_red_back}Disabling ${blue_b_in_red_back}'$problem_firewalls'${end_color}${yellow_b_in_red_back} failed, please disable them manually after completing this script${end_color}"
                
                choice_question_error="Continue script execution?"
                exit_answer_error="You entered invalid answers, please restart the script"

                ask_user "$choice_question_error" "$exit_answer_error"
                response=$?
                if [ $response -ne 0 ]; then
                    echo -e "${yellow_b_in_red_back}You declined to continue the script execution, configure ${blue_b_in_red_back}'$problem_firewalls'${end_color}${yellow_b_in_red_back} manually, or restart the script${end_color}"
                    log_message "$end_log_message"
                    exit 0
                fi
            else
                echo -e "${green_b}Check completed. All found firewalls have been disabled.${end_color}\n"
            fi
        fi
    else
        echo -e "${yellow_b_in_red_back}You entered a negative answer. In case of incorrect operation of CommuniGate Pro mail server${end_color} 
${yellow_b_in_red_back}after installation, please check the presence of a firewall on the server and its rules manually${end_color}\n"
    fi
}
#----------END OF FUNCTION TO DISABLE FIREWALL----------#

#----------START OF FUNCTION TO DISPLAY INFORMATION ABOUT THE INSTALLED PACKAGE----------#
info_about_installed_package() {
    echo -e "\n${green_b}Getting information about the installed package...${end_color}"

    if [ "$package_type" == "deb" ]; then
        echo -e "${purple}"
        dpkg -s "$deb_package_name" 
        echo -e "${end_color}"
    elif [ "$package_type" == "rpm" ]; then
        echo -e "${purple}"
        rpm -qi "$rpm_package_name_version"
        echo -e "${end_color}"
    else
        echo "${yellow_b}Failed to get information about the installed package.${end_color}"
    fi
}
#----------END OF FUNCTION TO DISPLAY INFORMATION ABOUT THE INSTALLED PACKAGE----------#

#----------------------------------------------------------MAIN BODY OF THE SCRIPT----------------------------------------------------------#
# Checking the availability of the CGP repository resource
if ! check_internet; then
    choice_question_offline="You do not have access to the CGP repository resource. Do you want to continue the installation with closed network options?"
    exit_answer_offline="You entered invalid answers, please restart the script"

    ask_user "$choice_question_offline" "$exit_answer_offline"
    response=$?

    if [[ $response -ne 0 ]]; then
        echo -e "${yellow_b_in_red_back}You canceled the installation in a closed network. Restore access to the resource https://doc.communigatepro.ru/packages/ with the CGP repository and try again.${end_color}"
        log_message "$end_log_message"
        exit 1
    else
            # Ask the user to specify the path to the installation file
        echo -en "${blue_b}Please specify the full path to the installation file (.deb or .rpm):${end_color} "
        read offline_package_path

        # Check if the file exists and matches the distribution type where it will be installed
        if [ ! -f "$offline_package_path" ]; then
            echo -e "${yellow_b_in_red_back}File not found. Please ensure the path is correct and restart the script.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
        user_package_filename=$(basename "$offline_package_path")

        # Function to copy the package
        copy_func() {
            if [ ! -f  "$download_dir/$user_package_filename" ]; then
                cp "$offline_package_path" "$download_dir/"
                echo -e "The package $user_package_filename has been copied to the installation directory: $download_dir"
                if [ $? -ne 0 ]; then
                    echo "Error copying the file."
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                :
            fi
        }

        # Check if the package matches the type
        if [[ "$offline_package_path" == *.deb && "$package_type" == "deb" ]]; then
            echo "The .deb package has been selected correctly."
            copy_func
        elif [[ "$offline_package_path" == *.rpm && "$package_type" == "rpm" ]]; then
            echo "The .rpm package has been selected correctly."
            copy_func
        else
            echo "${yellow_b_in_red_back}The package type does not match the package manager used by the $package_type distribution. The installation cannot continue.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi

        package_filename=$(basename "$download_dir/$user_package_filename")
        fi
else
    # Get the link to the latest package
    package_url=$(get_latest_package_url)
    package_filename=$(basename "$package_url")
    full_url="https://doc.communigatepro.ru/packages/$package_url"

    # Check if the link actually leads to a file before downloading
    if [[ ! "$package_url" =~ \.deb$ && ! "$package_url" =~ \.rpm$ ]]; then
        echo -e "${yellow_b_in_red_back}Invalid package URL: $full_url.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi
    
    echo -e "${white_b_in_orange_back}The current version of the CommuniGate Pro mail server package found: $package_filename${end_color}\n"

    if [ ! -f $download_dir/$package_filename ]; then
        # Download the file
        echo "Downloading the file from URL: $full_url to directory $download_dir"
        wget -q --show-progress "$full_url" -O "$download_dir/$package_filename"

        # Check if the download was successful
        if [ $? -eq 0 ]; then
            echo "The file has been successfully downloaded and saved to $download_dir/$package_filename"
        else
            echo -e "${yellow_b_in_red_back}Error downloading the file. Please check your internet connection.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    else
        echo -e "${yellow_b}Downloading the installer file is not necessary, the current version of the CommuniGate Pro mail server is already located at $download_dir/$package_filename
Installation will be performed from this package.${end_color}"
    fi
fi

package_exist="false" # Initialization of a technical variable for displaying a warning at the end of the script if no other CGP versions are found
# Checking if this package with this version is already installed
if [ "$package_type" == "deb" ]; then
    # Get the exact name and version of the package from the downloaded .deb file
    deb_package_name="cgatepro-linux"
    deb_package_name_version=$(dpkg-deb -I "$download_dir/$package_filename" | grep Version | awk '{print $2}')

    # Check if the package is already installed
    dpkg -s "$deb_package_name" &>/dev/null
    if [ $? -eq 0 ]; then
        installed_version=$(dpkg -s "$deb_package_name" | grep "Version" | awk '{print $2}')
        if [ "$installed_version" == "$deb_package_name_version" ]; then
            echo -e "${white_b_in_green_back}The package $deb_package_name-$installed_version is already installed on the system.${end_color}"
            info_about_installed_package
            log_message "$end_log_message"
            exit 0
        else
            package_exist="true"
            backup_func
        fi
    else
        # A backup will be created only when the script confirms the need to install/update the CGP package
        backup_func
        # Offer to disable the firewall during the initial installation of CGP on the server
        firewall_func
    fi
elif [ "$package_type" == "rpm" ]; then
    # Get the package name from the downloaded .rpm file
    rpm_package_name="CGatePro-Linux"
    rpm_package_name_version=$(rpm -qp "$download_dir/$package_filename")

    # Check if the package is already installed
    rpm -q "$rpm_package_name" &>/dev/null
    if [ $? -eq 0 ]; then
            rpm -q "$rpm_package_name_version" &>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${white_b_in_green_back}The package $rpm_package_name_version is already installed on the system.${end_color}"
                info_about_installed_package
                log_message "$end_log_message"
                exit 0
            else
                package_exist="true"
                backup_func
            fi
    else
        # A backup will be created only when the script confirms the need to install/update the CGP package
        backup_func
        # Offer to disable the firewall during the initial installation of CGP on the server
        firewall_func
    fi
fi

# Check the presence and status of the "CommuniGate" service in systemd
echo -e "${green_b}Checking for the running 'CommuniGate' service on the server...${end_color}"
if systemctl list-units --type=service --all | grep "CommuniGate"; then
    # If the service is found, check its status
    if systemctl is-active --quiet CommuniGate; then
        systemctl stop CommuniGate
        echo -e "${green_b}The 'CommuniGate' service has been stopped.${end_color}\n"
    else 
        echo -e "${green_b}The 'CommuniGate' service is inactive.${end_color}\n"
    fi
else
    echo -e "${green_b}The CommuniGate service was not found, stopping is not required.${end_color}\n"
fi

# Install the downloaded file depending on the package type
echo -e "${yellow_b}Installing package: $download_dir/$package_filename${end_color}"

if [ "$package_type" == "deb" ]; then
    # Install the .deb file using dpkg
    dpkg -i "$download_dir/$package_filename"
    if [ $? -eq 0 ]; then
        echo -e "${white_b_in_green_back}The .deb package has been successfully installed.${end_color}"
    else
        echo -e "${yellow_b}Error installing .deb package. Trying to fix dependencies...${end_color}"
        apt-get install -f -y  # Fixing dependencies for Debian/Ubuntu
        if [ $? -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}Failed to install the package $download_dir/$package_filename. The script will terminate.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    fi
elif [ "$package_type" == "rpm" ]; then
    # Install the .rpm file using rpm
    rpm -ivh "$download_dir/$package_filename"
    if [ $? -eq 0 ]; then
        echo -e "${white_b_in_green_back}The .rpm package has been successfully installed.${end_color}"
    else
        echo -e "${yellow_b}Error installing .rpm package. Attempting to install using DNF...${end_color}"
        dnf install "$download_dir/$package_filename"
        if [ $? -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}Failed to install the package $download_dir/$package_filename. The script will terminate.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
    fi
else
    echo -e "${yellow_b_in_red_back}Unknown package type. Installation was not performed. Please check if the file $download_dir/$package_filename is an installer.${end_color}"
    log_message "$end_log_message"
    exit 1
fi

# Display information about the installed package
info_about_installed_package

# Add the CommuniGate service to autostart if necessary
if ! systemctl is-enabled --quiet CommuniGate; then
    echo -e "${yellow_b}Adding the 'CommuniGate' service to autostart...${end_color}"
    systemctl enable CommuniGate
    echo -e "${green_b}The 'CommuniGate' service has been added to autostart.${end_color}\n"
else
    echo -e "${green_b}The 'CommuniGate' service is already added to autostart.${end_color}\n"
fi

# Function for warning in case CGP is being installed for the first time on the server.
notice_end_output(){
    if [[ "$package_exist" != "true" ]]; then
        echo -e "\n${yellow_b_in_red_back}\e[4mIMPORTANT WARNING:${end_color}${yellow_b_in_red_back} If you are installing CommuniGate Pro mail server for the first time,${end_color} 
${yellow_b_in_red_back}after reboot, you will need to run the command ${blue_b_in_red_back}'systemctl start CommuniGate'${end_color}${yellow_b_in_red_back} in the terminal to start the CGP service if it doesn't start automatically after the reboot,${end_color} 
${yellow_b_in_red_back}then within 10 minutes visit ${blue_b_in_red_back}https://localhost:9010 ${end_color}${yellow_b_in_red_back}to set the password for the user ${blue_b_in_red_back}'postmaster'${end_color}${yellow_b_in_red_back}, who is the administrator of CGP${end_color}\n"
        return 0
    fi
}

# Prompt for reboot
choice_question_reboot="A server reboot may be required to complete the installation. Do you want to reboot the server now?"
exit_answer_reboot="Reboot cancelled. Please perform it manually for stable operation of CommuniGate Pro!"

ask_user "$choice_question_reboot" "$exit_answer_reboot"
response=$?

if [[ "$response" -eq 0 ]]; then
    notice_end_output
    if [ $? -eq 0 ]; then
        echo -e "${blue_b}Press ENTER to continue with the reboot...${end_color}"
        read  # Waits for ENTER press
    fi
    log_message "$end_log_message"
    sleep 1s
    echo -e "${yellow_b}\nRebooting the server...${end_color}"
    sleep 3s
    reboot
else
    echo -e "${yellow_b_in_red_back}You declined the reboot. Please perform it manually for stable operation of CommuniGate Pro!${end_color}"
    notice_end_output
    log_message "$end_log_message"
fi