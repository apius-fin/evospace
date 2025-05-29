#!/bin/bash
# Nvidia driver installation function
nvidia_driver_installation() {
    # Check for NVIDIA GPU
    if lspci | grep -i nvidia; then
        echo "NVIDIA GPU detected. Proceeding with driver installation..."
        pacman -S --noconfirm nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
    else
        echo "No NVIDIA GPU detected. Aborting driver installation."
    fi
}