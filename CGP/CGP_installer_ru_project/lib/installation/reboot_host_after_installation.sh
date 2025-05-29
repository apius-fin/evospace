#!/bin/bash

# Функция для вывода предупреждения перед перезагрузкой в случае, если CGP устанавливается на сервере впервые.
notice_end_output(){
    if [[ "$package_exist" != "true" ]]; then
        echo -e "\n${yellow_b_in_red_back}\e[4mВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ:${end_color}${yellow_b_in_red_back} Если вы впервые устанавливаете почтовый сервер CommuniGate Pro,${end_color} 
${yellow_b_in_red_back}после перезагрузки нужно будет выполнить в терминале команду ${blue_b_in_red_back}'systemctl start CommuniGate'${end_color}${yellow_b_in_red_back}, чтобы запустить сервис CGP, если он не запустится автоматически после ребута,${end_color} 
${yellow_b_in_red_back}затем в течение 10 минут перейдите по адресу ${blue_b_in_red_back}https://localhost:8010 ${end_color}${yellow_b_in_red_back}для задания пароля УЗ ${blue_b_in_red_back}'postmaster'${end_color}${yellow_b_in_red_back}, являющегося администратором CGP${end_color}\n"
        return 0
    fi
}

# Запрос на перезагрузку
reboot_host_after_installation() {
    choice_question_reboot="Для завершения установки может потребоваться перезагрузка сервера. Хотите перезагрузить сервер сейчас?"
    exit_answer_reboot="Перезагрузка отменена. Выполните её самостоятельно для стабильной работы CommuniGate Pro!"

    ask_user "$choice_question_reboot" "$exit_answer_reboot"
    response=$?

    if [[ "$response" -eq 0 ]]; then
        notice_end_output
        if [ $? -eq 0 ]; then
            echo -e ""
            log_message "$end_log_message"
            echo -e "${blue_b}Для продолжения перезагрузки нажмите ENTER...${end_color}"
            read  # Ожидает нажатия ENTER
        fi
        sleep 1s
        echo -e "${yellow_b}\nПерезагружаем сервер...${end_color}"
        sleep 3s
        reboot
    else
        echo -e "${yellow_b_in_red_back}Вы отказались от перезагрузки. Выполните её самостоятельно для стабильной работы CommuniGate Pro!${end_color}"
        notice_end_output
        echo -e ""
        log_message "$end_log_message"
    fi
}