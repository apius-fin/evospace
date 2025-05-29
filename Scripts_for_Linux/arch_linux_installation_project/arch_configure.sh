#!/bin/bash

#-------------------------------------------------------------------------------------------------------------------#
#                                               EXECUTION BLOCK                                                     #
#-------------------------------------------------------------------------------------------------------------------#

# Activating strict mode
# set -euo pipefail

# Change directory for script directory
cd "$(dirname "$0")" || { echo "Failed to change directory"; exit 1; }

# Function for checking existance of needed files
check_libs_and_vars_files() {
    lib_dir="./lib"
    conf_dir="./conf"

    # File list
    required_files=(
        "./bin/main.sh"
        "$lib_dir/usage_and_help.sh"
        "$lib_dir/additional_software/additional_software.sh"
        "$lib_dir/additional_software/yay_installation.sh"
        "$lib_dir/additional_software/kde_installation.sh"
        "$lib_dir/additional_software/nvidia_driver_installation.sh"
        "$lib_dir/additional_software/qemu_kvm_installation.sh"
        "$lib_dir/base_system/install_base_system.sh"
        "$lib_dir/base_system/setting_disks_and_fs.sh"
        "$lib_dir/base_system/setting_kernel_parameters.sh"
        "$lib_dir/base_system/setting_new_arch_system.sh"
        "$lib_dir/base_system/plymouth_installation.sh"
        "$lib_dir/tools/ask_user.sh"
        "$lib_dir/tools/log_file_init.sh"
        "$lib_dir/tools/luks_enable.sh"
        "$lib_dir/tools/change_user_bash.sh"
        "$lib_dir/tools/check_internet.sh"
        "$lib_dir/tools/chroot_system.sh"
        "$lib_dir/tools/create_mount_dir_arch.sh"
        "$lib_dir/tools/error_exit.sh"
        "$lib_dir/tools/efi_settings.sh"
        "$lib_dir/tools/enroll_keys_uefi.sh"
        "$lib_dir/tools/initialization.sh"
        "$lib_dir/tools/mounted_partitions_check.sh"
        "$lib_dir/tools/reboot_host.sh"
        "$lib_dir/tools/timedatectl_sync.sh"
        "$conf_dir/color_vars.sh"
        "$conf_dir/microcode_check.sh"
        "$conf_dir/mount_sv_opts.sh"
        "$conf_dir/kernel_parameters_vars.sh"
        "$conf_dir/tech_files_vars.sh"
    )

    # Checking needed files
    missing_files=()
    for file in "${required_files[@]}"; do
        [[ -f "$file" ]] || missing_files+=("$file")
    done

    # If missing exist - output it
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        echo "Error: Missing required files:" >&2
        printf '  - %s\n' "${missing_files[@]}" >&2
        exit 1
    else
        echo "All the necessary function and configuration files are in place for the script to work."
    fi

    # Загружаем (теперь гарантированно без ошибок)
    for file in "${required_files[@]}"; do
        source "$file"
    done
}

check_libs_and_vars_files

# Processing arguments
if [[ $# -eq 0 ]]; then
    usage
fi

#-------------------------------------------INIT MAIN FUNCTION-------------------------------------------#
main "$@"