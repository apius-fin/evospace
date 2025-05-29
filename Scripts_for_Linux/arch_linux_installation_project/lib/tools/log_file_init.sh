#!/bin/bash
#--------------------------------------------------------------------------------#
#                                    LOG_FUNC                                    #
#--------------------------------------------------------------------------------#
log_message() {
    # Initialize the script log file
    echo -e "${yellow_b_in_purple_back}$(date +'%d/%m/%Y_%H:%M:%S') - ${1}${end_color}\n"
    # We duplicate all further output of the script in the log
    if [[ $2 = true ]]; then
        # Getting the current date and time for the labels in the log file names
        local timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
        export LOG_FILE="$log_dir/${3}_$timestamp.log"
        # A message about the location where the script log is saved
        export end_log_message="The script is completed. The script execution log is saved along the way: $LOG_FILE"
        exec > >(tee "$LOG_FILE") 2>&1
    fi
}

export -f log_message