#!/bin/bash
install_base_system() {
    
    # Checking to avoid repeating the function if it has already been successfully completed in the previous script run
    if [ -f "$tech_dir_for_script/base_install.ready" ]; then
        echo -e "Base packages are already installed"
        return 0 # exit from function if $tech_dir_for_script/base_install.ready exists
    fi

    echo -e "Starting install base packages for Arch..."

    # Computing microcode for the processor
    microcode_check

    # Installation command
    pacstrap -K ${main_arch_mount_dir} base base-devel ${microcode} linux linux-firmware bash-completion cryptsetup \
    htop git base-devel btrfs-progs efibootmgr inotify-tools timeshift vim networkmanager firewalld \
    nmap pkgfile openssh man sudo pacman-contrib reflector tmux sbctl

    # generating fstab for new installation with actual mount parameters
    genfstab -U -p ${main_arch_mount_dir} >> ${main_arch_mount_dir}/etc/fstab
    cat ${main_arch_mount_dir}/etc/fstab

    touch $tech_dir_for_script/base_install.ready
    echo -e "Base system is installed"
}