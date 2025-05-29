#!/bin/bash
#--------------------------------------------------------------------------------#
#                               ERROR_EXIT_FUNC                                  #
#--------------------------------------------------------------------------------#
error_exit() {
    echo -e "${yellow_b_in_red_back}Error: ${1}${end_color}" >&2
    log_message "$end_log_message" false
    exit 1
}

# Exporting function for child proccess
export -f error_exit