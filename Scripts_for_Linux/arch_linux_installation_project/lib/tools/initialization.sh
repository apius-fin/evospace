#!/bin/bash
initialization() {
    # Check before start script for root privilegious
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${yellow_b_in_red_back}This script must be run as the root user.${end_color}"
        echo -e "${yellow_b_in_red_back}Please run the following command before running the script: ${underline_text}sudo su${end_color}"
        exit 1
    fi

    choice_question_start="Should I continue executing the script?"
    exit_answer_start="Script execution stopped"

    ask_user "$choice_question_start" "$exit_answer_start"
    response=$?
    if [ $response -ne 0 ]; then
        echo -e "${yellow_b_in_red_back}You refused to execute the script${end_color}"
        exit 0
    fi

    if [[ $1 = "installation" ]]; then
        if [ ! -d "$tech_dir_for_script" ]; then
            echo -e "\n${green_b}${tech_dir_for_script} doesn't exist. It is technical dir for script, its files and logs."
            echo -e "${yellow_b}Creating dir $tech_dir_for_script...${end_color}"
            mkdir -p "$tech_dir_for_script"  # Creating dir
            else
            echo -e "\n${green_b}Script will be use $tech_dir_for_script for tech files and logs.${end_color}"
        fi
        echo "" # Space for formatting
        
        # Log directory init
        if [ ! -d "$log_dir" ]; then
            mkdir -p "$log_dir"
        fi
        log_message "Starting script" true "$2"
    fi
}