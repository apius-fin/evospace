#!/bin/bash

# Проверка наличия утилиты curl и её установка, если она отсутствует
curl_is_true() {
    if ! command -v curl &>/dev/null; then
        echo -e "${yellow_b}Для корректной работы скрипта в открытом контуре необходима утилита curl.${end_color}"
        echo -e "${yellow_b}Установка curl...${end_color}"
        # Установка curl в зависимости от типа дистрибутива
        if [ "$package_type" == "deb" ]; then
            apt-get update &> /dev/null 
            apt-get install -y curl &> /dev/null
        elif [ "$package_type" == "rpm" ]; then
            # Для RPM дистрибутивов (CentOS, RHEL, Fedora и другие) - приоритет для более нового пакетного менеджера DNF
            if command -v dnf &>/dev/null; then
                dnf install -y curl &> /dev/null
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты curl завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            elif command -v yum &>/dev/null; then
                yum install -y curl &> /dev/null
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты curl завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                echo "Не удалось найти подходящий пакетный менеджер для установки curl."
                log_message "$end_log_message"
                exit 1
            fi
        fi
    fi
}

wget_is_true() {
    if ! command -v wget &>/dev/null; then
        echo -e "${yellow_b}Для корректной работы скрипта в открытом контуре необходима утилита wget.${end_color}"
        echo -e "${yellow_b}Установка wget...${end_color}"
        # Установка wget в зависимости от типа дистрибутива
        if [ "$package_type" == "deb" ]; then
            apt-get update &> /dev/null 
            apt-get install -y wget &> /dev/null
        elif [ "$package_type" == "rpm" ]; then
            # Для RPM дистрибутивов (CentOS, RHEL, Fedora и другие) - приоритет для более нового пакетного менеджера DNF
            if command -v dnf &>/dev/null; then
                dnf install -y wget &> /dev/null
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты wget завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            elif command -v yum &>/dev/null; then
                yum install -y wget &> /dev/null
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты wget завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                echo "Не удалось найти подходящий пакетный менеджер для установки wget."
                log_message "$end_log_message"
                exit 1
            fi
        fi
    fi    
}