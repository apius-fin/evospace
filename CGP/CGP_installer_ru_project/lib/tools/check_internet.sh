#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ проверки наличия Интернета----------#
# Проверка наличия интернета с помощью ping
check_internet() {
    echo -e "\nПроверка доступа к ресурсу doc.communigatepro.ru с репозиторием для CGP..."
    if ping -c 4 doc.communigatepro.ru &>/dev/null; then
        echo -e "${green_b}Ресурс c репозиторием для CGP доступен. Парсим https://doc.communigatepro.ru/packages/ в поисках актуальной версии CGP... ${end_color}\n"
        return 0
    else
        echo -e "${yellow_b}Нет доступа к ресурсу с репозиториями CGP, возможно, проблемы с интернет-соединением, либо у вас используется закрытый контур.${end_color}\n"
        return 1
    fi
}
#----------КОНЕЦ ФУНКЦИИ проверки наличия Интернета----------#
