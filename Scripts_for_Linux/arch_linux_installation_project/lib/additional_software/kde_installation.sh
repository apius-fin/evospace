#!/bin/bash
#--------------------------------------------------------------------------------#
#                              KDE_INSTALLATION_FUNC                             #
#--------------------------------------------------------------------------------#

kde_installation() {
    # install kde and addons for it
    sudo pacman -Syu --noconfirm plasma-desktop plasma-pa plasma-nm plasma-systemmonitor plasma-firewall \
    plasma-browser-integration kscreen kwalletmanager kwallet-pam bluedevil powerdevil \
    power-profiles-daemon kdeplasma-addons xdg-desktop-portal-kde kde-gtk-config breeze-gtk konsole \
    dolphin ffmpegthumbs chromium kate okular gwenview ark flameshot haruna

    # Plasma Desktop Core >>>
    # plasma-desktop - Main KDE Plasma desktop environment
    # plasma-pa - PulseAudio integration (volume control)
    # plasma-nm - NetworkManager applet for Plasma
    # plasma-systemmonitor - System resource monitor widget
    # plasma-firewall - Firewall management frontend

    # Hardware/System Integration >>>
    # kscreen - Display configuration tool
    # bluedevil - Bluetooth management
    # powerdevil - Power management daemon
    # power-profiles-daemon - Power mode switching (Performance/Battery)
    # kwalletmanager - Encrypted password storage
    # kwallet-pam - Auto-unlock KWallet at login

    # Plasma Add-ons & Utilities >>>
    # kdeplasma-addons - Extra Plasma widgets and themes
    # xdg-desktop-portal-kde - Desktop integration for Flatpak/Snap apps
    # kde-gtk-config - GTK theme/behavior configuration
    # breeze-gtk - Breeze theme for GTK apps

    # Default Applications for KDE >>>
    # konsole - Terminal emulator
    # dolphin - File manager
    # kate - Advanced text editor
    # okular - Document viewer (PDF, EPUB)
    # gwenview - Image viewer
    # ark - Archive manager
    # haruna - MPV-based video player
    # flameshot - Screenshot tool

    # Multimedia & Thumbnails >>>
    # ffmpegthumbs - Video thumbnails in Dolphin
    # chromium - Web browser (often default in KDE)

    # Browser Integration >>>
    # plasma-browser-integration - Connect browsers to Plasma (KDE Connect, media controls)

    # Settings login manager
    # Install SDDM
    pacman -S --noconfirm sddm

    # Enable SDDM service to make it start on boot
    sudo systemctl enable sddm

    # If using KDE I suggest installing this to control the SDDM configuration from the KDE settings App
    pacman -S --needed --noconfirm sddm-kcm

    echo "KDE installation is ended. Reboot recommended"
}