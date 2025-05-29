#!/bin/bash

additional_software() {
    sudo pacman -Syu brasero bluez bluez-utils noto-fonts-cjk pipewire \
    pipewire-alsa pipewire-pulse pipewire-jack wireplumber fuse
}