#!/bin/bash
#--------------------------------------------------------------------------------#
#                             CHECK_INTERNET_FUNC                                #
#--------------------------------------------------------------------------------#
# Checking for access to archlinux.org using the ping utility
check_internet() {
    echo -e "\n"
    if ping -c 4 archlinux.org; then
        echo -e "${green_b}You have access to archlinux.org${end_color}\n"
    else
        error_exit "Resource archlinux.org unavailable. Stopping script"
    fi
}