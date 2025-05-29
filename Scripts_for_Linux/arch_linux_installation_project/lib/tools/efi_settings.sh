#!/bin/bash

# Setting efi file for boot the system
efi_settings_for_secure_boot() {
    
    # Checking to avoid repeating the function if it has already been successfully completed in the previous script run
    if [ -f "$tech_dir_for_script/secure_boot.ready" ]; then
        echo -e "Secure boot is already configured"
        return 0 # exit from function if $tech_dir_for_script/secure_boot.ready exists
    fi

    function_for_setting_secure_boot() {
        echo -e "Setting secure boot..."
        # Create keys
        if ! sbctl create-keys; then
            error_exit "Failed to create secure boot keys."
        fi

        # Create signed EFI file
        if ! sbctl bundle -s /efi/main.efi; then
            error_exit "Failed to create signed EFI bundle. Ensure the /efi directory exists and is writable."
        fi

        # Add UEFI boot entry
        if ! efibootmgr --create --disk "$disk" --part 1 --label "Linux" --loader 'main.efi' --unicode; then
            error_exit "Failed to create UEFI boot entry. Check if the EFI partition is properly mounted at /efi."
        fi

        # Verify boot entry was created
        if ! efibootmgr | grep -q "Linux"; then
            error_exit "Warning: Boot entry 'Linux' not found in efibootmgr output. The boot entry might not have been created successfully."
        fi
    }
    
    chroot_system "function_for_setting_secure_boot"
    
    touch $tech_dir_for_script/secure_boot.ready
    echo -e "Secure boot is successfully configured!"
}