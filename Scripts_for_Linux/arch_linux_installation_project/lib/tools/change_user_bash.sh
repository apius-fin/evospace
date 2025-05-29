#!/bin/bash

change_user_bash() {
    sudo -u "$1" -i /bin/bash <<EOF
        $(declare -f $2)
        $2
EOF
}

export -f change_user_bash