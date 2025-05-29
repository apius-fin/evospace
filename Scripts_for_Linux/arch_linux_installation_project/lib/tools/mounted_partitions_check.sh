#!/bin/bash

# Check if mounted partitions
    mounted_partitions_check() {
        
        if sudo blkid -t PARTLABEL="${sgdisk_root_partition_name}" &>/dev/null; then

            # Init local vars for the func
            local device_path=""
            local is_luks=false

            # Checking where exactly the section exists (via blkid)
            # Checking /dev/mapper/
            if sudo blkid "/dev/mapper/${root_name_partition}" &>/dev/null; then
                device_path="/dev/mapper/${root_name_partition}"
                is_luks=true
            # Checking /dev/disk/by-partlabel/
            elif sudo blkid "/dev/disk/by-partlabel/${root_name_partition}" &>/dev/null; then
                device_path="/dev/disk/by-partlabel/${root_name_partition}"
            else
                return 0
            fi

            # Getting the mounting points for the found device
            local mount_points=$(mount | grep "^${device_path} " | awk '{print $3}')
            
            if [ -n "$mount_points" ]; then
                echo "Found mounting points for '${device_path}':"
                echo "$mount_points"
                for point in $mount_points; do
                    echo "Unmounting $point..."
                    if ! umount "$point"; then
                        echo "Error: couldn't unmount $point"
                        # We are trying to force unmount in case of failure
                        echo "Trying a forced unmount..."
                        umount -f "$point" || {
                            error_exit "Cannot be unmounted $point"
                        }
                    fi
                done
            else
                echo "There are no mounting points for '${device_path}'"
            fi
        else
            return 0
        fi

        if [[ $is_luks = true ]]; then
            # Closing container
            echo "Closing the LUKS container '${root_name_partition}'..."
            if cryptsetup close "${root_name_partition}"; then
                echo "The container has been successfully closed"
                return 0
            else
                error_exit "The container cannot be closed"
            fi
        fi
    }
