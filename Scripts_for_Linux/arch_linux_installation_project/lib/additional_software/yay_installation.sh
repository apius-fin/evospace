#!/bin/bash
#--------------------------------------------------------------------------------#
#                             YAY_INSTALLATION_FUNC                              #
#--------------------------------------------------------------------------------#

yay_installation() {
    echo -e "${blue_b}Type login for user with admin privilegies (non root):${end_color}\n"
    read admin_user

    # Validate input
    if [[ -z "$admin_user" ]]; then
        echo -e "${yellow_b_in_red_back}Username cannot be empty.${end_color}"
        exit 1
    fi

    # Check if user exists
    if ! id -u "$admin_user" >/dev/null 2>&1; then
        error_exit "${User} '$admin_user' does not exist."
    fi

    # Check if user has sudo privileges
    if ! sudo -l -U "$admin_user" >/dev/null 2>&1; then
        echo -e "${yellow_b_in_red_back}User '$admin_user' doesn't have sudo privileges.${end_color}"
        exit 1
    fi

    mkdir -p ~/AUR
    cd ~/AUR
    git clone https://aur.archlinux.org/yay-git.git
    cd yay-git
    makepkg -si

# Additional softwares from AUR (future concept):
# Pinta (drawing), openvpn3
}