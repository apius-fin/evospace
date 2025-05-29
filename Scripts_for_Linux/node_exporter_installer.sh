#!/bin/bash
#                        ____            _       _                           
#                       / ___|  ___ _ __(_)_ __ | |_                         
#                       \___ \ / __| '__| | '_ \| __|                        
#                        ___) | (__| |  | | |_) | |_                         
#                       |____/ \___|_|  |_| .__/ \__|                        
#                                         |_|                                
#            __              _           _        _ _ _                      
#           / _| ___  _ __  (_)_ __  ___| |_ __ _| | (_)_ __   __ _          
#          | |_ / _ \| '__| | | '_ \/ __| __/ _` | | | | '_ \ / _` |         
#          |  _| (_) | |    | | | | \__ | || (_| | | | | | | | (_| |         
#          |_|  \___/|_|    |_|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |         
#                                                             |___/          
#                        _                   _       _   _                   
#         __ _ _ __   __| |  _   _ _ __   __| | __ _| |_(_)_ __   __ _       
#        / _` | '_ \ / _` | | | | | '_ \ / _` |/ _` | __| | '_ \ / _` |      
#       | (_| | | | | (_| | | |_| | |_) | (_| | (_| | |_| | | | | (_| |      
#        \__,_|_| |_|\__,_|  \__,_| .__/ \__,_|\__,_|\__|_|_| |_|\__, |      
#                                 |_|                            |___/       
#                     _                                       _              
#     _ __   ___   __| | ___        _____  ___ __   ___  _ __| |_ ___ _ __   
#    | '_ \ / _ \ / _` |/ _ \_____ / _ \ \/ | '_ \ / _ \| '__| __/ _ | '__|  
#    | | | | (_) | (_| |  __|_____|  __/>  <| |_) | (_) | |  | ||  __| |     
#    |_| |_|\___/ \__,_|\___|      \___/_/\_| .__/ \___/|_|   \__\___|_|     
#                                           |_|                              
#    __              ____                           _   _                    
#   / _| ___  _ __  |  _ \ _ __ ___  _ __ ___   ___| |_| |__   ___ _   _ ___ 
#  | |_ / _ \| '__| | |_) | '__/ _ \| '_ ` _ \ / _ | __| '_ \ / _ | | | / __|
#  |  _| (_) | |    |  __/| | | (_) | | | | | |  __| |_| | | |  __| |_| \__ \
#  |_|  \___/|_|    |_|   |_|  \___/|_| |_| |_|\___|\__|_| |_|\___|\__,_|___/
                                                                          
#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# color section
end_color="\e[0m" # Reset color
green_b="\e[32m" # Just info
yellow_b="\e[33;1m" # Warnings
blue_b="\e[36;1m" # Request for user action
dark_blue_b="\e[34;1m" # Response options in the user action prompt
purple="\e[35m" # Start of the script and display of service info
yellow_b_in_red_back="\e[33;1m\e[41m" # Critical warnings and errors
white_b_in_orange_back="\e[97;1m\e[48;5;130m" # Current version of node-exporter from github
white_b_in_green_back="\e[97;1m\e[42m" # Successful script completion

service_name_ne="node-exporter"

# Check if the script is run as the root user
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}This script must be run as the root user.${end_color}"
    echo -e "${yellow_b_in_red_back}Please run the command: sudo su before running the script.${end_color}"
    exit 1
fi

echo -e "${purple}
This script is intended for a fresh installation or updating to the latest version of the node-exporter${end_color}
"                                                                       

ask_user() {
    local attempts=3
    local choice_question="$1"
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

    echo -e "${yellow_b_in_red_back}Script execution has been stopped${end_color}"
    log_message "$end_log_message"
    exit 1
}

# Start script question
choice_question_start="Continue running the script?"
ask_user "$choice_question_start"
response=$?
if [ $response -ne 0 ]; then
    echo -e "${yellow_b_in_red_back}You canceled the script execution${end_color}"
    exit 0
fi

# Determine the distribution type
if command -v rpm &>/dev/null; then
    package_type="rpm"  # For RPM-based distribution
    echo -e "\n${green_b}Distribution type: RPM${end_color}"
elif command -v dpkg &>/dev/null; then
    package_type="deb"  # For DEB-based distribution
    echo -e "\n${green_b}Distribution type: DEB${end_color}"
elif command -v pacman &>/dev/null; then
    package_type="arch" # For ARCH-based distribution
    echo -e "\n${green_b}Distribution type: ARCH${end_color}"
else
    echo -e "\n${yellow_b_in_red_back}This distribution is not supported by the script.${end_color}"
    exit 1
fi

# Check init system
if [ "$(readlink /sbin/init)" == "/lib/systemd/systemd" ] || [ "$(ps -p 1 -o comm=)" == "systemd" ]; then
    type_sys_init="Systemd"
elif [ -d "/etc/init.d" ] && [ "$(ls -A /etc/init.d)" ]; then
    # If /etc/init.d exists and is not empty, this could be SysV
    if command -v openrc &>/dev/null; then
        type_sys_init="OpenRC"
    else
        type_sys_init="SysV"
    fi
else
    echo -e "${yellow_b_in_red_back}Usupported system init for this script${end_color}"
    exit 1
fi

echo "${green}Init system detected: $type_sys_init${end_color}"

# Create a temporary directory in /tmp for the downloaded node_exporter archive
download_dir=$(mktemp -d)

# Install wget if it is not installed
if ! command -v wget &>/dev/null; then
    if [ "$package_type" == "rpm" ]; then
        if command -v dnf &>/dev/null; then
            dnf install -y wget || { echo "Failed to install wget"; exit 1; }
        else
            yum install -y wget || { echo "Failed to install wget"; exit 1; }
        fi
    elif [ "$package_type" == "deb" ]; then
        apt install -y wget || { echo "Failed to install wget"; exit 1; }
    elif [ "$package_type" == "arch" ]; then
        pacman -S wget || { echo "Failed to install wget"; exit 1; }
    fi
fi

# Check the presence and status of the "CommuniGate" service in systemd
echo -e "${green_b}Checking for the running '$service_name_ne' service on the server...${end_color}"

if [ "$type_sys_init" == "Systemd" ]; then
    # Check for node-exporter service in systemd
    if systemctl list-units --type=service --all | grep "$service_name_ne"; then
        # If the service is found, check its status
        if systemctl is-active --quiet "$service_name_ne"; then
            systemctl stop "$service_name_ne"
            echo -e "${green_b}The '$service_name_ne' service has been stopped (Systemd).${end_color}\n"
        else 
            echo -e "${green_b}The '$service_name_ne' service is inactive (Systemd).${end_color}\n"
        fi
    else
        echo -e "${green_b}The '$service_name_ne' service was not found (Systemd), stopping is not required.${end_color}\n"
    fi

elif [ "$type_sys_init" == "SysV" ]; then
    # Check for node-exporter service in SysV init
    if service --status-all | grep "$service_name_ne" > /dev/null; then
        # If the service is found, check its status
        if service "$service_name_ne" status > /dev/null; then
            service "$service_name_ne" stop
            echo -e "${green_b}The '$service_name_ne' service has been stopped (SysV).${end_color}\n"
        else
            echo -e "${green_b}The '$service_name_ne' service is inactive (SysV).${end_color}\n"
        fi
    else
        echo -e "${green_b}The '$service_name_ne' service was not found (SysV), stopping is not required.${end_color}\n"
    fi

elif [ "$type_sys_init" == "OpenRC" ]; then
    # Check for node-exporter service in OpenRC
    if rc-service --list | grep "$service_name_ne" > /dev/null; then
        # If the service is found, check its status
        if rc-service "$service_name_ne" status > /dev/null; then
            rc-service "$service_name_ne" stop
            echo -e "${green_b}The '$service_name_ne' service has been stopped (OpenRC).${end_color}\n"
        else
            echo -e "${green_b}The '$service_name_ne' service is inactive (OpenRC).${end_color}\n"
        fi
    else
        echo -e "${green_b}The '$service_name_ne' service was not found (OpenRC), stopping is not required.${end_color}\n"
    fi
fi

echo -e "Parsing repository github.com/prometheus/node_exporter"
page_ne_content=$(curl -s https://github.com/prometheus/node_exporter/tags)
latest_v_tag=$(echo "$page_ne_content" | grep -oP 'href="([^"]+v\d+\.\d+\.\d+)"' | sed 's/href="//' | sed 's/"//' | sort -r | uniq | head -n 1)
latest_version_ne=$(echo "$latest_v_tag" | grep -oP '\d+\.\d+\.\d+')
echo -e "${white_b_in_orange_back}Latest version node-exporter: $latest_version_ne${end_color}"
package_url=https://github.com/prometheus/node_exporter/releases/download/v${latest_version_ne}/node_exporter-${latest_version_ne}.linux-amd64.tar.gz

wget -P "$download_dir" "$package_url" || { echo "Error downloading the file. Check the resource availability."; exit 1; }

file_archive=$(basename "$package_url")
archive_dir=$(tar -tf "$download_dir/$file_archive" | head -n 1 | cut -f1 -d"/")
tar -xzvf "$download_dir/$file_archive" -C "$download_dir/" || { echo "Error extracting the file."; exit 1; }
if [ -f "$download_dir/$archive_dir/node_exporter" ]; then
  mv "$download_dir/$archive_dir/node_exporter" /usr/local/bin/node_exporter
else
  echo "Error: node_exporter file not found."
  exit 1
fi

chmod +x /usr/local/bin/node_exporter

admin_node_exporter="node_exporter"
group_admin_ne="node_exporter"
if ! getent passwd "$admin_node_exporter" &>/dev/null; then
    useradd -rs /bin/false "$admin_node_exporter"
else
    echo -e "User $admin_node_exporter already exists"
fi

chown "$admin_node_exporter:$group_admin_ne" /usr/local/bin/node_exporter

# Function to validate port input
validate_port() {
    local port="$1"
    # Check if the port is a number and within the valid TCP/UDP range (1-65535)
    if [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
        return 0  # Valid port
    else
        return 1  # Invalid port
    fi
}

# Define the port to check if it's in use
availability_port() {
    local port=$1
    # Check if the port is in use using lsof
    if lsof -i :$port > /dev/null; then
        echo -e "${yellow_b}Port $port is already in use. List of busy ports:${end_color}"
        lsof -i -n -P
        return 1  # Port is in use
    else
        return 0  # Port is available
    fi
}

# Prompt the user to input the port number and validate it
default_listening_port="9100"
attempts=3

while [ $attempts -gt 0 ]; do
    echo -en "${blue_b}Enter the port $service_name_ne will listen on. (Default: $default_listening_port):${end_color} "
    read user_listening_port

    # First attempt to validate user input
    if [ -n "$user_listening_port" ] && ! validate_port "$user_listening_port"; then
        echo -e "${yellow_b_in_red_back}Invalid port number. Please enter a value between 1 and 65535.${end_color}"
        ((attempts--))
        echo -e "Attempts left: $attempts"
    else
        # If input is valid or empty, use user input or the default
        listening_port="${user_listening_port:-$default_listening_port}"

        # Check if the port is available
        if ! availability_port "$listening_port"; then
            echo -e "${yellow_b_in_red_back}Port $listening_port is already in use. Please choose a different port.${end_color}"
            ((attempts--))
            echo -e "Attempts left: $attempts"
        else
            break  # Port is available, break the loop
        fi
    fi
done

# If all attempts are used up, check if the default port is available
if [ $attempts -eq 0 ]; then
    echo -e "${yellow_b_in_red_back}You have exceeded the number of attempts. Checking default port availability.${end_color}"
    # Check if default port is available
    if ! availability_port "$default_listening_port"; then
        echo -e "${yellow_b_in_red_back}The default port $default_listening_port is also in use. Please try again later or choose a different port.${end_color}"
        exit 1  # Exit as no valid port is available
    else
        echo -e "${yellow_b_in_red_back}Using default port: $default_listening_port.${end_color}"
        listening_port="$default_listening_port"
    fi
fi

# Output the chosen port
echo "Using port: $listening_port"
listening_port="0.0.0.0:${listening_port}"

# Systemd service definition
contain_unitd=$(cat <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=$admin_node_exporter
Group=$group_admin_ne
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address="$listening_port"

[Install]
WantedBy=multi-user.target
EOF
)

unitd="/etc/systemd/system/$service_name_ne.service"

# SysV Init script
contain_sysv_script=$(cat <<EOF
#!/bin/bash
### BEGIN INIT INFO
# Provides:          $service_name_ne
# Required-Start:    $network $syslog
# Required-Stop:     $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Node Exporter Service
# Description:       Prometheus Node Exporter for system metrics
### END INIT INFO

NODE_EXPORTER="/usr/local/bin/node_exporter"
USER="node_exporter"
GROUP="node_exporter"
LISTEN_PORT="$listening_port"

case "\$1" in
  start)
    start-stop-daemon --start --quiet --background --make-pidfile --pidfile /var/run/node_exporter.pid --chuid \$USER:\$GROUP --exec \$NODE_EXPORTER -- --web.listen-address=":\$LISTEN_PORT"
    ;;
  stop)
    start-stop-daemon --stop --quiet --pidfile /var/run/node_exporter.pid
    ;;
  restart)
    \$0 stop
    \$0 start
    ;;
  status)
    if [ -f /var/run/node_exporter.pid ]; then
      echo "Node Exporter is running (PID: \$(cat /var/run/node_exporter.pid))"
    else
      echo "Node Exporter is not running."
    fi
    ;;
  *)
    echo "Usage: \$0 {start|stop|restart|status}"
    exit 1
    ;;
esac
exit 0
EOF
)

sysv_script="/etc/init.d/$service_name_ne"

# OpenRC script content
contain_openrc_script=$(cat <<EOF
#!/sbin/openrc-run

name="$service_name_ne"
description="Prometheus Node Exporter"

# Path to the executable file
command="/usr/local/bin/node_exporter"
pidfile="/var/run/node_exporter/node_exporter.pid"  # Path to the PID file

# Directory where the PID file will be created
required_dirs="/var/run/node_exporter"

# Function for preparation before starting (create the directory if it doesn't exist)
start_pre() {
    mkdir -p /var/run/node_exporter
}

# Function to start the service
start() {
    ebegin "Starting \$name"

    start_pre  # Run preparatory steps

    # If the PID file already exists, remove it
    if [ -f "\$pidfile" ]; then
        rm -f "\$pidfile"
    fi

    # Start the service in the background
    \$command --web.listen-address="$listening_port" &

    # Write the PID of the process to the file
    echo \$! > "\$pidfile"

    # Set the ownership of the PID file
    chown node_exporter:node_exporter "\$pidfile"

    eend \$?  # Finish with the success code
}

# Function to stop the service
stop() {
    ebegin "Stopping \$name"

    # Check for the existence of the PID file
    if [ -f "\$pidfile" ]; then
        pid=\$(cat "\$pidfile")  # Read the PID from the file

        # Terminate the process using the PID
        kill "\$pid" && rm -f "\$pidfile"  # Remove the PID file after stopping

        eend \$?  # Finish with the success code
    else
        eerror "PID file not found, service might not be running."
        eend 1  # Finish with an error
    fi
}

# Function to restart the service
restart() {
    stop  # Stop the service
    start  # Start the service
}

# Function to check the status of the service
status() {
    if [ -f "\$pidfile" ]; then
        pid=\$(cat "\$pidfile")  # Read the PID from the file
        if ps -p "\$pid" > /dev/null; then
            echo "\$name is running with PID \$pid"
            return 0
        else
            eerror "\$name is not running but PID file exists."
            return 1
        fi
    else
        eerror "No PID file found, service is not running."
        return 1
    fi
}
EOF
)

# Set OpenRC script path
openrc_script="/etc/init.d/$service_name_ne"

# Write systemd unit or SysV init script depending on the init system
write_systemd_unit() {
    echo "$contain_unitd" > "$unitd" || { echo "Error creating systemd service file."; exit 1; }
    chmod +x "$unitd"
}

write_sysv_init() {
    echo "$contain_sysv_script" > "$sysv_script" || { echo "Error creating SysV init script."; exit 1; }
    chmod +x "$sysv_script"
}

# OpenRC Init script creation function
write_openrc_init() {
    echo "$contain_openrc_script" > "$openrc_script" || { echo "Error creating OpenRC init script."; exit 1; }
    chmod +x "$openrc_script"
}

# Check for Systemd and create the service
if [ "$type_sys_init" == "Systemd" ]; then
    if [ ! -f "$unitd" ]; then
        write_systemd_unit
    else
        echo -e "File $unitd already exists in the system"
        choice_question_wu="Overwrite $unitd?"
        ask_user "$choice_question_wu"
        response=$?
        if [ "$response" -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}You canceled overwrite $unitd${end_color}"
            exit 0
        elif [ "$response" -eq 0 ]; then
            write_systemd_unit
        fi
    fi

    systemctl daemon-reload

    start_service_systemd(){
        systemctl start "$service_name_ne" || { echo "Error starting the service."; exit 1; }
        systemctl status "$service_name_ne" --no-pager
        echo -e "\n${white_b_in_green_back}${service_name_ne}-${latest_version_ne} successfully installed${end_color}"
        echo -e "\n${purple}`node_exporter --version`${end_color}\n"
    }

    if ! systemctl is-enabled --quiet $service_name_ne; then
        echo -e "${yellow_b}Adding the '$service_name_ne' service to autostart...${end_color}"
        systemctl enable "$service_name_ne"
        echo -e "${green_b}The '$service_name_ne' service has been added to autostart.${end_color}\n"
        start_service_systemd
    else
        echo -e "${green_b}The '$service_name_ne' service is already added to autostart.${end_color}\n"
        start_service_systemd
    fi

# Check for SysV and create the service
elif [ "$type_sys_init" == "SysV" ]; then
    if [ ! -f "$sysv_script" ]; then
        write_sysv_init
    else
        echo -e "File $sysv_script already exists in the system"
        choice_question_wu="Overwrite $sysv_script?"
        ask_user "$choice_question_wu"
        response=$?
        if [ "$response" -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}You canceled overwrite $sysv_script${end_color}"
            exit 0
        elif [ "$response" -eq 0 ]; then
            write_sysv_init
        fi
    fi

    start_service_sysv(){
        service "$service_name_ne" start || { echo "Error starting the service."; exit 1; }
        service "$service_name_ne" status
        echo -e "\n${white_b_in_green_back}${service_name_ne}-${latest_version_ne} successfully installed${end_color}"
        echo -e "\n${purple}`node_exporter --version`${end_color}\n"
    }

    if ! chkconfig --list "$service_name_ne" | grep -q "$service_name_ne"; then
        echo -e "${yellow_b}Adding the '$service_name_ne' service to autostart...${end_color}"
        chkconfig "$service_name_ne" on
        echo -e "${green_b}The '$service_name_ne' service has been added to autostart.${end_color}\n"
        start_service_sysv
    else
        echo -e "${green_b}The '$service_name_ne' service is already added to autostart.${end_color}\n"
        start_service_sysv
    fi

# Check for OpenRC and create the service
elif [ "$type_sys_init" == "OpenRC" ]; then
    if [ ! -f "$openrc_script" ]; then
        write_openrc_init
    else
        echo -e "File $openrc_script already exists in the system"
        choice_question_wu="Overwrite $openrc_script?"
        ask_user "$choice_question_wu"
        response=$?
        if [ "$response" -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}You canceled overwrite $openrc_script${end_color}"
            exit 0
        elif [ "$response" -eq 0 ]; then
            write_openrc_init
        fi
    fi

    start_service_openrc(){
        rc-service "$service_name_ne" start || { echo "Error starting the service."; exit 1; }
        rc-service "$service_name_ne" status
        echo -e "\n${white_b_in_green_back}${service_name_ne}-${latest_version_ne} successfully installed${end_color}"
        echo -e "\n${purple}`node_exporter --version`${end_color}\n"
    }

    if ! rc-update show | grep -q "$service_name_ne"; then
        echo -e "${yellow_b}Adding the '$service_name_ne' service to autostart...${end_color}"
        rc-update add "$service_name_ne" default
        echo -e "${green_b}The '$service_name_ne' service has been added to autostart.${end_color}\n"
        start_service_openrc
    else
        echo -e "${green_b}The '$service_name_ne' service is already added to autostart.${end_color}\n"
        start_service_openrc
    fi
fi

rm -rf "$download_dir"