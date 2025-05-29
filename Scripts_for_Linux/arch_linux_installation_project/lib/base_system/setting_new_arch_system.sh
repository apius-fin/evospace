#!/bin/bash
# Setting new system
setting_new_arch_system() {

    # Checking to avoid repeating the function if it has already been successfully completed in the previous script run
    if [ -f "$tech_dir_for_script/system.ready" ]; then
        echo -e "Base system is already configured"
        return 0 # exit from function if $tech_dir_for_script/system.ready exists
    fi

    function_for_setting_new_arch_system() {
        # Setting timezone and hwclock
        ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
        hwclock --systohc

        # Setting hostname and hosts
        echo -e "${blue_b}Type hostname for new Arch system:${end_color}\n"
        read myHostName
        echo "$myHostName" > /etc/hostname

        # Setting /etc/hosts
        cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${myHostName}.localdomain ${myHostName}
EOF

        # Adding EN, RU, CN and TW
        sed -i "s/^#\(en_US.UTF-8\)/\1/" /etc/locale.gen
        sed -i "s/^#\(ru_RU.UTF-8\)/\1/" /etc/locale.gen
        sed -i "s/^#\(zh_CN.UTF-8\)/\1/" /etc/locale.gen
        sed -i "s/^#\(zh_TW.UTF-8\)/\1/" /etc/locale.gen

        # Install default lang for the system
        echo "$default_lang" > /etc/locale.conf

        # Generating locales
        locale-gen

        # Setting keymap for console
        echo "KEYMAP=${keymap}" > /etc/vconsole.conf

        # Setting password for root
        echo -e "${blue_b}Type password for root:${end_color}\n"
        passwd

        # Setting new_admin_user
        echo -e "${blue_b}Type name for new user with admin privilegies:${end_color}\n"
        read new_admin_user
        export new_admin_user
        useradd -m -G wheel -s /bin/bash ${new_admin_user}
        echo -e "${blue_b}Type password for new admin user:${end_color}\n"
        passwd ${new_admin_user}

        # Uncommenting wheel line in sudoers
        sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

        # Enable network_manager when starting
        systemctl enable NetworkManager

        # Enable firewalld when starting
        systemctl enable firewalld
    }

    # Chroot in new arch system, /bin/bash -c '' - executing all function commands in chroot
    chroot_system "function_for_setting_new_arch_system"

    touch $tech_dir_for_script/system.ready
    echo -e "Base system is configured"
}