#!/bin/bash

setting_kernel_parameters_for_encryption() {
    
    # Checking to avoid repeating the function if it has already been successfully completed in the previous script run
    if [ -f "$tech_dir_for_script/kernel_parameters.ready" ]; then
        echo -e "disk and fs are already configured"
        return 0 # exit from function if $tech_dir_for_script/kernel_parameters.ready exists
    fi

    # Setting kernel parameters
    sed -i "s|^HOOKS=(.*|HOOKS=($new_hooks)|" ${main_arch_mount_dir}/etc/mkinitcpio.conf
    echo "${list_kernel_parameters_for_cmdline}" > ${main_arch_mount_dir}/etc/kernel/cmdline
    echo "${list_kernel_parameters_for_crypttab}" > ${main_arch_mount_dir}/etc/crypttab.initramfs
    
    # Rebuilding kernel
    echo -e "Rebuilding kernel..."
    arch-chroot ${main_arch_mount_dir} mkinitcpio -P

    echo -e "Kernel parameters are configured"
    touch $tech_dir_for_script/kernel_parameters.ready
}