#!/bin/bash

#-------------------------------------------------------------------------------------------------------------------#
#                                               INIT MAIN FUNCTION                                                  #
#-------------------------------------------------------------------------------------------------------------------#

main() {

    deploy=false
    software=false
    encryption=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            deploy)
                deploy=true
                shift

                # Check that the next argument is true
                if [[ $# -eq 0 || ("$1" != "--base-installation" && "$1" != "--plymouth-installation") ]]; then
                    echo -e "${yellow_b_in_red_back}Error: after 'deploy' required argument --base-installation or --plymouth-installation${end_color}"
                    usage
                fi
                ;;

            --base-installation)
                if [[ "$deploy" != true ]]; then
                    error_exit "Error: --base-installation required argument 'deploy' at first"
                fi
                shift  # Move past --base-installation

                # Check for optional --with-encryption
                if [[ $# -gt 0 && "$1" == "--with-encryption" ]]; then
                    encryption=true
                    shift  # Move past --with-encryption
                fi

                # 1. Initialization
                initialization "installation" "$log_file_name_allias_for_installation"

                # 2. Check Internet
                check_internet

                # 3. Sync time
                timedatectl_sync

                # 4. Setting disks and fs then install Arch system
                if [[ "$encryption" == true ]]; then
                    # Setting encrypted system fs on the disk
                    setting_disks_and_fs "encrypt"
                    # Install base pkgs
                    install_base_system
                    # Setting new system
                    setting_new_arch_system
                    # Setting kernel parameters for boot
                    setting_kernel_parameters_for_encryption
                    # Setting secure boot
                    efi_settings_for_secure_boot
                else
                    setting_disks_and_fs "noencrypt"
                    install_base_system
                    efi_settings_for_secure_boot
                fi

                # 5. Successfull output
                echo -e "${white_b_in_green_back}Script successfully ended!${end_color}"
                ;;
            
            --plymouth-installation)
                if [[ "$deploy" != true ]]; then
                    error_exit "Error: --plymouth-installation required argument 'deploy' at first"
                fi
                shift  # Move past --plymouth-installation
                
                # 1. Initialization
                initialization "installation" "$log_file_name_allias_for_plymouth_installation"

                # 2. Check Internet
                check_internet

                # 3. Plymouth installation
                plymouth_installation
                ;;

            complete)
                complete=true
                shift

                # Check that the next argument is true
                if [[ $# -eq 0 || ("$1" != "--reboot-after-installation" && "$1" != "--enroll-keys-after-installation") ]]; then
                    echo -e "${yellow_b_in_red_back}Error: after 'complete' required argument --reboot-after-installation or --enroll-keys-after-installation${end_color}"
                    usage
                fi
                ;;
            
            --reboot-after-installation)
                # Check that the next argumen# Обработанный аргумент
                if [[ "$complete" != true ]]; then
                    error_exit "Error: --reboot-after-installation required argument 'complete' at first"
                fi
                shift  # Move past --reboot-after-installation

                # Reboot
                reboot_host "after_installation"
                ;;

            --enroll-keys-after-installation)
                # Check that the next argumen# Обработанный аргумент
                if [[ "$complete" != true ]]; then
                    error_exit "Error: --enroll-keys-after-installation required argument 'complete' at first"
                fi
                shift  # Move past --enroll-keys-after-installation

                # Reboot
                enroll_keys_uefi
                ;;

            software) 
                software=true
                shift # Move past software
                # Check that the next argument is true
                if [[ $# -eq 0 || ("$1" != "--kde-installation" && "$1" != "--qemu-kvm-installation" && "$1" != "--additional-software" && "$1" != "--nvidia-driver-installation") ]]; then
                    echo -e "${yellow_b_in_red_back}Error: after 'software' required argument --kde-installation, --qemu-kvm-installation, --nvidia-driver-installation or --install-yay${end_color}"
                    usage
                fi
                ;;
            
            --kde-installation)
                # Check that the next argumen# Обработанный аргумент
                if [[ "$software" != true ]]; then
                    error_exit "Error: --kde-installation required argument 'software' at first"
                fi
                shift  # Move past --kde-installation

                # 1. Initialization
                initialization

                # 2. Check Internet
                check_internet

                # 3. Install KDE and addons for it
                kde_installation
                ;;

            --qemu-kvm-installation)
                # Check that the next argumen# Обработанный аргумент
                if [[ "$software" != true ]]; then
                    error_exit "Error: --qemu-kvm-installation required argument 'software' at first"
                fi
                shift  # Move past --qemu-kvm-installation

                # 1. Initialization
                initialization

                # 2. Check Internet
                check_internet

                # 3. Install QEMU-KVM
                qemu_kvm_installation
                ;;

            --additional-software)
                # Check that the next argumen# Обработанный аргумент
                if [[ "$software" != true ]]; then
                    error_exit "Error: --additional-software required argument 'software' at first"
                fi
                shift  # Move past --additional-software

                # 1. Initialization
                initialization

                # 2. Check Internet
                check_internet

                # 3. Install QEMU-KVM
                additional_software
                ;;

            --nvidia-driver-installation)
                # Check that the next argumen# Обработанный аргумент
                if [[ "$software" != true ]]; then
                    error_exit "Error: --nvidia-driver-installation required argument 'software' at first"
                fi
                shift  # Move past --nvidia-driver-installation

                # 1. Initialization
                initialization

                # 2. Check Internet
                check_internet

                # 3. Install nvidia-driver
                nvidia_driver_installation
                ;;

            --install-yay)
                if [[ "$software" != true ]]; then
                    error_exit "Error: --install-yay required argument 'software' at first"
                fi
                shift  # Move past --install-yay

                # 1. Initialization
                initialization

                # 2. Check Internet
                check_internet

                # 3. Install YAY
                yay_installation
                ;;

            -h|--help)
                reference
                ;;

            *)
                echo -e "${yellow_b_in_red_back}Error: Unknown argument '\$1'${end_color}"
                usage
                ;;
        esac
    done
}