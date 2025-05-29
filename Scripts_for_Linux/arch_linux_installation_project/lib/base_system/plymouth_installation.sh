#!/bin/bash
plymouth_installation() {
    
    # Start the installation process for plymouth from AUR
    echo -e "Beginning installation of plymouth..."

    pacman -S --noconfirm cargo 

    function_for_plymouth_installation() {

        echo -e "${blue_b}Type login for user with admin privilegies (non root):${end_color}\n"
        read admin_user

        # Validate input
        if [[ -z "$admin_user" ]]; then
            error_exit "Username cannot be empty."
        fi

        # Check if user exists
        if ! id -u "$admin_user" >/dev/null 2>&1; then
            error_exit "User '$admin_user' does not exist."
        fi

        # Check if user has sudo privileges
        if ! sudo -l -U "$admin_user" >/dev/null 2>&1; then
            error_exit "User '$admin_user' doesn't have sudo privileges."
        fi

        function_for_user_installing_plymouth() {
            # Creating a build directory
            echo "Creating build directory..."
            mkdir -p Build && cd Build || {
                error_exit "Failed to create or navigate to Build directory. Aborting installation."
            }

            # Cloning the aura repository
            echo "Cloning the aura repository..."
            if ! git clone https://aur.archlinux.org/aura.git; then
                error_exit "Failed to clone the aura repository. Aborting installation."
            fi

            cd aura || {
                error_exit "Failed to navigate to aura directory. Aborting installation."
            }

            # Building and installing aura
            echo "Building and installing aura..."
            if ! makepkg -is --noconfirm; then
                cd .. && rm -rf aura
                error_exit "Failed to build and install aura. Aborting installation."
            fi

            # Cleaning up by removing the aura folder
            cd .. && rm -rf aura
            echo "Aura installed successfully."
        }

        change_user_bash "$admin_user" "function_for_user_installing_plymouth"

        # Continue to root bash

        # Installing plymouth-git using aura
        echo "Installing plymouth-git..."
        if ! aura -Ax --noconfirm plymouth-git; then
            error_exit "Failed to install plymouth-git using aura. Aborting installation."
        fi

        # Setting default plymouth theme
        echo "Setting default plymouth theme..."
        if ! plymouth-set-default-theme -R spinner; then
            error_exit "Failed to set default plymouth theme. Aborting installation."
        fi

        # Rebuilding the kernel
        echo "Rebuilding the kernel..."
        if ! mkinitcpio -P; then
            error_exit "Kernel rebuild failed. Aborting installation."
        fi

        # Generating sbctl bundles
        echo "Generating sbctl bundles..."
        if ! sbctl generate-bundles -s; then
            error_exit "Failed to generate sbctl bundles. Aborting installation."
        fi
    }
    
    chroot_system "function_for_plymouth_installation"

    echo -e "Plymouth installation completed successfully!"
}