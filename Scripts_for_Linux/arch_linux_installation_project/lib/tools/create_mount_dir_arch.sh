#!/bin/bash

create_mount_dir_arch(){
    if [ ! -d "$main_arch_mount_dir" ]; then
        echo -e "\n${green_b}${main_arch_mount_dir} doesn't exist. It is mount dir for Arch configuration."
        echo -e "${yellow_b}Creating dir $main_arch_mount_dir...${end_color}"
        mkdir -p "$main_arch_mount_dir"  # Creating dir
    else
        echo -e "\n${green_b}Script will be use $main_arch_mount_dir for mount and configure Arch.${end_color}"
    fi
    echo "" # Space for formatting
}