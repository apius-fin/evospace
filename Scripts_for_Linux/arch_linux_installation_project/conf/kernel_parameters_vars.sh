#!/bin/bash

#--------------------------------------------------------------------------------#
#                            KERNEL_PARAMETERS_VARS                              #
#--------------------------------------------------------------------------------#

#>>>>>>>>>>>>>>>>-HOOKS->>>>>>>>>>>>>>>>#
# Export a space-separated string of mkinitcpio hooks to be included in the initramfs
export new_hooks="base systemd plymouth modconf keyboard sd-vconsole block sd-encrypt filesystems btrfs fsck"
# These hooks are essential for a system with systemd, encryption, and btrfs filesystem

# Basic Required Hooks:
# base                  # Provides basic filesystem utilities and library support
# systemd               # Replaces traditional 'udev' hook with systemd's device management

# Boot Process Features:
# plymouth              # Enables Plymouth splash screen support

# Hardware Detection:
# modconf               # Loads modules from /etc/modprobe.d and /usr/lib/modprobe.d
# keyboard              # Adds keyboard support for early console (essential for encryption)

# Storage and Block Devices:
# block                 # Provides block device support and functions for device discovery

# Encryption Support:
# sd-encrypt            # Systemd-based hook for LUKS encrypted volumes (replaces 'encrypt')

# Filesystem Support:
# filesystems           # Includes support for common filesystems (ext4, xfs, fat, etc.)
# btrfs                 # Adds specific support for Btrfs filesystem features

# Filesystem Checking:
# fsck                  # Includes filesystem check utilities (required for root fs checking)
#<<<<<<<<<<<<<<<<-HOOKS-<<<<<<<<<<<<<<<<#

#>>>>>>>>>>>>>>>>-KERNEL_CMDLINE->>>>>>>>>>>>>>>>#
# Kernel parameters for /etc/kernel/cmdline
export list_kernel_parameters_for_cmdline="fbcon=nodefer rw rd.luks.allow-discards quiet bgrt_disable root=LABEL=system rootflags=subvol=@,rw splash vt.global_cursor_default=0"
# These parameters will be passed to the Linux kernel during boot
#
# fbcon=nodefer                # Framebuffer console: disable deferred takeover
# rw                           # Mount root filesystem in read-write mode
# rd.luks.allow-discards       # Allow TRIM/discards on LUKS encrypted devices
# quiet                        # Suppress most boot messages (quiet mode)
# bgrt_disable                 # Disable BGRT (Boot Graphics Resource Table) if problematic
# root=LABEL=system            # Specify root filesystem by label 'system'
# rootflags=subvol=@,rw        # Btrfs mount options: use subvolume '@' as root (read-write)
# splash                       # Enable splash screen during boot
# vt.global_cursor_default=0   # Disable blinking cursor in virtual terminals
#<<<<<<<<<<<<<<<<-KERNEL_CMDLINE-<<<<<<<<<<<<<<<<#

# Kernel parameters for crypttab
export list_kernel_parameters_for_crypttab="system /dev/disk/by-partlabel/mainsystem none timeout=180"
