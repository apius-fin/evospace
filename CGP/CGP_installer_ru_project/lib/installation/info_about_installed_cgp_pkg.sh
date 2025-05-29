#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ, выводящей информацию об установленном пакете----------#
info_about_installed_package() {
    echo -e "\n${green_b}Получаем информацию об установленном пакете...${end_color}"

    if [ "$package_type" == "deb" ]; then
        echo -e "${purple}"
        dpkg -s "$deb_package_name" 
        echo -e "${end_color}"
    elif [ "$package_type" == "rpm" ]; then
        echo -e "${purple}"
        rpm -qi "$rpm_package_name_version"
        echo -e "${end_color}"
    else
        echo "${yellow_b}Не удалось получить информацию об установленном пакете.${end_color}"
    fi
}
#----------КОНЕЦ ФУНКЦИИ, выводящей информацию об установленном пакете----------#
