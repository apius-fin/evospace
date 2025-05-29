#!/bin/bash
# Setting disk and fs
setting_disks_and_fs() {
    
    # Checking to avoid repeating the function if it has already been successfully completed in the previous script run
    if [ -f "$tech_dir_for_script/disk_fs.ready" ]; then
        echo -e "disk and fs are already configured"
        return 0 # exit from function if $tech_dir_for_script/disk_fs.ready exists
    fi

    # List all disks (include partitions)
    lsblk -o NAME,ROTA,SIZE,TYPE,MOUNTPOINTS,MODEL

    # Set up completion function for disk paths
    _disk_completion() {
        local cur=${COMP_WORDS[COMP_CWORD]}
        COMPREPLY=( $(compgen -f -o plusdirs -- "$cur") )
    }

    echo -e "\n${blue_b}Type disk (not partition!) for installation (For example, /dev/sda or /dev/nvme0n1)${end_color}"
    # Set the completion function for the read command
    complete -F _disk_completion -o filenames read
    # Read user input with autocomplete enabled
    read -e user_answer_for_disk
    export disk=$user_answer_for_disk

    # Remove the completion after we're done
    complete -r read
    
    # Creating EFI (1) and system (2) partitions
    sgdisk_create() {
        # Erasing partitons on selected dev
        wipefs -af $disk
        sgdisk --zap-all --clear $disk
        partprobe $disk
        sgdisk --clear --new=1:0:+512MiB --typecode=1:ef00 --change-name=1:EFI --new=2:0:0 --typecode=2:8300 --change-name=2:${sgdisk_root_partition_name} "$disk"
        sgdisk -p "$disk"
    }
    
    if [[ $1 = "encrypt" ]]; then
        export root_partition="/dev/mapper/${root_name_partition}"
        mounted_partitions_check
        sgdisk_create
        # Encrypting root partition
        luks_enable
        create_mount_dir_arch
    elif [[ $1 = "noencrypt" ]]; then
        export root_partition="/dev/disk/by-partlabel/${root_name_partition}"
        mounted_partitions_check
        sgdisk_create
        create_mount_dir_arch
    fi

    # Create filesystems with error checking
    echo "Creating filesystems..."
    if ! mkfs.vfat -F32 -n ESP /dev/disk/by-partlabel/EFI; then
        error_exit "Failed to create FAT32 filesystem for EFI partition"
    fi

    if ! mkfs.btrfs --force --label "${root_name_partition}" "${root_partition}"; then
        error_exit "Failed to create Btrfs filesystem for root partition"
    fi

    # Mount root filesystem
    if ! mount LABEL="${root_name_partition}" ${main_arch_mount_dir}; then
        error_exit "Failed to mount root partition"
    fi

    # Create Btrfs subvolumes
    echo "Creating Btrfs subvolumes..."
    for subvol in @ @home @snapshots; do
        if ! btrfs subvolume create "${main_arch_mount_dir}/${subvol}"; then
            error_exit "Failed to create subvolume ${subvol}"
        fi
    done

    # Unmount everything
    if ! umount -R ${main_arch_mount_dir}; then
        error_exit "Failed to unmount filesystems"
    fi

    # Remount with subvolumes
    echo "Remounting with subvolumes..."
    if ! mount -o ${sv_opts},subvol=@ "${root_partition}" ${main_arch_mount_dir}; then
        error_exit "Failed to mount root subvolume"
    fi

    # Create directories and mount other subvolumes and EFI partition
    mkdir -p ${main_arch_mount_dir}/{home,.snapshots,efi} || error_exit "Failed to create mount directories"

    if ! mount -o ${sv_opts},subvol=@home "${root_partition}" ${main_arch_mount_dir}/home; then
        error_exit "Failed to mount home subvolume"
    fi

    if ! mount -o ${sv_opts},subvol=@snapshots "${root_partition}" ${main_arch_mount_dir}/.snapshots; then
        error_exit "Failed to mount snapshots subvolume"
    fi

    # Mount EFI partition
    if ! mount LABEL=ESP ${main_arch_mount_dir}/efi; then
        error_exit "Failed to mount EFI partition"
    fi

    touch "$tech_dir_for_script/disk_fs.ready"
    echo -e "Filesystem setup completed successfully!"
}