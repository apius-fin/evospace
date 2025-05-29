#!/bin/bash

#--------------------------------------------------------------------------------#
#                                   TECH_VARS                                    #
#--------------------------------------------------------------------------------#

# Main directory for chroot Arch
export main_arch_mount_dir="/arch-system"

# Main tech directory for the script
export tech_dir_for_script="/tmp/arch_conf_tech_dir"

#>>>>>>>>>>>>>>>>-LOGGING->>>>>>>>>>>>>>>>#
# Log directory
export log_dir="$tech_dir_for_script/log"
# Log file allias for Arch installation
export log_file_name_allias_for_installation="arch_installation"
# Log file allias for plymouth installation
export log_file_name_allias_for_plymouth_installation="plymouth_installation"
#<<<<<<<<<<<<<<<<-LOGGING-<<<<<<<<<<<<<<<<#

# Root name partition
export root_name_partition="system"
# Sgdisk name
export sgdisk_root_partition_name="mainsystem"

# Default language for the system
default_lang="LANG=en_US.UTF-8"
# Var for keymap
export keymap="ru"