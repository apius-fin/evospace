#!/bin/bash
#----------------COLOR SECTION----------------#
export end_color="\e[0m" #  Сброс цвета
export yellow_b_in_red_back="\e[33;1m\e[41m" # Критические замечания и ошибки
export blue_b_in_red_back="\e[36;1m\e[41m" # Подсветка команд, утилит и пользователей в критических замечаниях и ошибках
export blue_b="\e[36;1m" # Запрос действий от пользователя
export dark_blue_b="\e[34;1m" # Варианты ответа в запросе действий от пользователя
export green_b="\e[32;1m" # Инфо
export white_b_in_green_back="\e[97;1m\e[42m" # Успешное завершение скрипта или функции
export white_b_in_orange_back="\e[97;1m\e[48;5;130m" # Актуальная версия CGP, полученная с ресурса https://doc.communigatepro.ru/packages/
export yellow_b="\e[33;1m" # Предупреждения
export purple="\e[35m" # Отображение информации об установленном пакете CommuniGate Pro
export purple_b="\e[35;1m" # Начало скрипта или функции
export yellow_b_in_purple_back="\e[33;1m\e[45m" # Сообщение для задания метки лога
export underline_text="\e[4m" # Акцент подчёркиванием на важных моментах в выводе
export disable_underline="\e[24m" # Отключение подчёркивания
#----------------COLOR SECTION----------------#