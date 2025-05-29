#!/bin/bash

chroot_system() {
    # Chroot in new arch system, /bin/bash -c '' - executing all function commands in chroot
    arch-chroot $main_arch_mount_dir /bin/bash -c "
        $(declare -f $1)
        $1
    "
}