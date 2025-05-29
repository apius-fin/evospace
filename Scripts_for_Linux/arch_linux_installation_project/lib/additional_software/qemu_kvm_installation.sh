#!/bin/bash
#--------------------------------------------------------------------------------#
#                          QEMU-KVM_INSTALLATION_FUNC                            #
#--------------------------------------------------------------------------------#
# Manual in github for QEMU-KVM in Arch
# https://gist.github.com/tatumroaquin/c6464e1ccaef40fd098a4f31db61ab22

qemu_kvm_installation() {
    # Check support virtualization on the host
    check_virtualization=$(lscpu | grep -i 'Virtualization' | awk '{print$2}')

    if [[ $check_virtualization = "VT-x" || $check_virtualization = "AMD-Vi" ]]; then
        # Install qemu-kvm
        echo "Virtualization is supported. Installing necessary packages..."
        sudo pacman -S --noconfirm qemu-full qemu-img libvirt virt-install virt-manager virt-viewer \
        edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned
    else
        error_exit "Virtualization is not supported on this host."
    fi
}
# qemu-full - user-space KVM emulator, manages communication between hosts and VMs
# qemu-img - provides create, convert, modify, and snapshot, offline disk images
# libvirt - an open-source API, daemon, and tool for managing platform virtualization
# virt-install - CLI tool to create guest VMs
# virt-manager - GUI tool to create and manage guest VMs
# virt-viewer - GUI console to connect to running VMs
# edk2-ovmf - enables UEFI support for VMs
# dnsmasq - lightweight DNS forwarder and DHCP server
# swtpm - TPM (Trusted Platform Module) emulator for VMs
# guestfs-tools - provides a set of extended CLI tools for managing VMs
# libosinfo - a library for managing OS information for virtualization
# tuned - system tuning service for linux allows us to optimise the hypervisor for speed