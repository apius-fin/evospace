#!/bin/bash
# Enroll keys after installation and start new system
enroll_keys_uefi() {
    echo "Starting key enrollment process..."
    # Checking sbctl is exist
    if ! command -v sbctl &> /dev/null; then
        error_exit "Error: sbctl is not installed. Please install it to enroll keys."
    fi
    # Attempt to register keys in TPM
    if sbctl enroll-keys; then
        echo -e "Keys enrolled successfully."
    else
        error_exit "Error: Failed to enroll keys. Check for any errors above."
    fi
    echo -e "${green_b}Key enrollment completed.${end_color}"
}