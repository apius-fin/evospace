#!/bin/bash

# Reboot require
reboot_host() {
    choice_question_reboot="Do you want to reboot host right now?"
    exit_answer_reboot="Reboot cancelled"

    ask_user "$choice_question_reboot" "$exit_answer_reboot"
    response=$?

    if [[ $1 = "after_installation" ]]; then
        umount -R ${main_arch_mount_dir}
    fi

    if [[ "$response" -eq 0 ]]; then
        if [ $? -eq 0 ]; then
            echo -e ""
            echo -e "${blue_b}Press ENTER to continue reboot...${end_color}"
            read  # Waiting to press ENTER
        fi
        sleep 1s
        echo -e "${yellow_b}\nRebooting host...${end_color}"
        sleep 3s
        reboot
    else
        echo -e "${yellow_b_in_red_back}You cancelled reboot${end_color}"
        echo -e ""
    fi
}