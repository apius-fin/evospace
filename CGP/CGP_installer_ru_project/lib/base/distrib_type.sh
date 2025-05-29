#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ определения дистрибутива----------#
distrib_type() {
    if command -v rpm &>/dev/null; then
        export package_type="rpm"  # Для RPM дистрибутива
        echo -e "${green_b}Тип дистрибутива: RPM${end_color}"
    elif command -v dpkg &>/dev/null; then
        export package_type="deb"  # Для DEB дистрибутива
        echo -e "${green_b}Тип дистрибутива: DEB${end_color}"
    else
        echo -e "${yellow_b_in_red_back}Данный дистрибутив не поддерживает почтовый сервер CommuniGate Pro.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi
}
#----------КОНЕЦ ФУНКЦИИ определения дистрибутива----------#
