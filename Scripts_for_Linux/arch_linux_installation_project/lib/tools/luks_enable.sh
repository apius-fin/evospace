#!/bin/bash

luks_enable() {
    echo "Setting up LUKS encryption..."

    # Check existing system partition
    if ! sudo blkid -t PARTLABEL="${sgdisk_root_partition_name}" &>/dev/null; then
        error_exit "Partition /dev/disk/by-partlabel/${sgdisk_root_partition_name} not found"
    fi

    # Creating LUKS container
    echo -e "Creating LUKS2 container (this may take a while)..."
    ##
    # Create LUKS container with parameters:
    #   --type luks2            - use modern LUKS2 format
    #   --align-payload=8192    - SSD alignment (8K pages)
    #   -s 256                  - key size 256-bit (128+128 for XTS)
    #   -c aes-xts-plain64      - AES algorithm in XTS mode
    #   --verify-passphrase     - require passphrase confirmation
    ##
    if ! cryptsetup luksFormat --type luks2 \
                               --align-payload=8192 \
                               -s 256 \
                               -c aes-xts-plain64 \
                               --verify-passphrase \
                               "/dev/disk/by-partlabel/${sgdisk_root_partition_name}"; then
        error_exit "Failed to create LUKS container"
    fi

    # Opening LUKS container
    echo "Opening LUKS container..."
    if ! cryptsetup open "/dev/disk/by-partlabel/${sgdisk_root_partition_name}" "${root_name_partition}"; then
        error_exit "Failed to open LUKS container. Repeat typing password"
        if ! cryptsetup open "/dev/disk/by-partlabel/${sgdisk_root_partition_name}" "${root_name_partition}"; then
        error_exit "Failed to open LUKS container. Script ended"
        fi
    fi

    # Check existing encrypted mapper
    if [ ! -e "/dev/mapper/${root_name_partition}" ]; then
        error_exit "LUKS mapping not created at /dev/mapper/${root_name_partition}"
    fi

    echo "LUKS encryption setup completed successfully"
}