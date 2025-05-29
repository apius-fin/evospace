#!/bin/bash

#-------------------------------------------------------------------------------------------------------------------#
#                                             USAGE AND HELP BLOCK                                                  #
#-------------------------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------#
#                                    USAGE_FUNC                                  #
#--------------------------------------------------------------------------------#
# Funcion for base man
usage() {
    echo "Usage: $0 [arguments]"
    echo "Options:"
    echo "  deploy --base-installation                          Start installation Arch on disk" 
    echo "         --base-installation --with-encryption        Start installation Arch on disk with enctrypted partition"
    echo "         --plymouth-installation                      Start installation Arch on disk"
    echo ""
    echo "  complete --reboot-after-installation                Reboot the system after Arch installation"
    echo "           --enroll-keys-after-installation           Enroll keys in TPM for secure boot. Do it after first login in installed system"
    echo ""
    echo "  software --kde-installation                         Install kde and kde-addons"
    echo "           --qemu-kvm-installation                    Install QEMU-KVM"
    echo "           --additional-software                      Install additional software"
    echo "           --nvidia-driver-installation               Install NVIDIA driver for your NVIDIA card"
    echo "           --install-yay                              Install AUR helper yay"
    echo ""
    echo "  -h, --help                                          Full manual for this script"
    exit 1
}

#--------------------------------------------------------------------------------#
#                                   HELP_FUNC                                    #
#--------------------------------------------------------------------------------#

help() {
    
    echo "This script written by apius-fin"
    
    echo "Usage: $0 [arguments]"
    echo "Options:"
    echo "  deploy --base-installation                          Start installation Arch on disk" 
    echo "         --base-installation --with-encryption        Start installation Arch on disk with enctrypted partition"
    echo "         --plymouth-installation                      Start installation Arch on disk"
    echo ""
    echo "  complete --reboot-after-installation                Reboot the system after Arch installation"
    echo "           --enroll-keys-after-installation           Enroll keys in TPM for secure boot. Do it after first login in installed system"
    echo ""
    echo "  software --kde-installation                         Install kde and kde-addons"
    echo "           --qemu-kvm-installation                    Install QEMU-KVM"
    echo "           --additional-software                      Install additional software"
    echo "           --nvidia-driver-installation               Install NVIDIA driver for your NVIDIA card"
    echo "           --install-yay                              Install AUR helper yay"
    echo ""
    echo "  -h, --help                                          Full manual for this script"
    exit 0
}