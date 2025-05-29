#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ запроса ответа----------#
# Функция для запроса ответа yes/no(y/n) со стороны пользователя с проверкой ввода
ask_user() {
    local attempts=3
    local choice_question="$1"
    local exit_answer="$2"
    # Переменная для задания постоянной строки с вариантами ответа на вопрос
    local various_answer="${dark_blue_b}yes/no (y/n):${end_color}"

    while [ $attempts -gt 0 ]; do
        echo -ne "${blue_b}$choice_question $various_answer${end_color} "
        read user_answer
        user_answer=${user_answer,,} # Преобразуем всё в нижний регистр
        case "$user_answer" in
            yes|y|д|да) return 0 ;;  # Если ответ "yes" или "y", возвращаем 0 (да)
            no|n|н|нет) return 1 ;;   # Если ответ "no" или "n", возвращаем 1 (нет)
            *)
                ((attempts--))
                echo -e "${yellow_b_in_red_back}Вы ввели недопустимый ответ. Осталось попыток: $attempts.${end_color}"
                ;;
        esac
    done

    echo -e "${yellow_b_in_red_back}$exit_answer${end_color}"
    log_message "$end_log_message" false
    exit 1
}
#----------КОНЕЦ ФУНКЦИИ запроса ответа----------#
