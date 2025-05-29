#!/bin/bash
timedatectl_sync() {
    # Setting time syncronyzation
    timedatectl set-ntp true
    timedatectl status
}