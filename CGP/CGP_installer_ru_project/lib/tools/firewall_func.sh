#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ по отключению фаервола----------#
firewall_func() {
    echo -e "${yellow_b}Для корректной работы CommuniGate Pro перед первой установкой рекомендуется настроить фаервол firewalld${end_color} 
${yellow_b}при этом будет удалён ufw, если он есть, и очищены все правила для iptables/nftables на данном сервере${end_color}
${yellow_b_in_red_back}ВАЖНО! Если вы ранее самостоятельно настраивали firewalld, то все текущие настройки будут сброшены и перезаписаны под корректную работу почтового сервера CommuniGate Pro${end_color}"
    choice_question_firewall="Хотите ли вы, чтобы скрипт настроил firewalld, отключил ufw и очистил правила для iptables/nftables, если указанные сервисы есть на сервере?"
    exit_answer_firewall="Вы ввели недопустимые ответы, запустите скрипт заново"

    ask_user "$choice_question_firewall" "$exit_answer_firewall"
    response=$?

    # Если пользователь ответил "yes", продолжаем выполнение скрипта
    if [ $response -eq 0 ]; then
        # Флаг для отслеживания, найден ли хотя бы один фаервол
        local firewall_found="false"
        local error_disable_firewall=1

        # Проверка наличия ufw и его отключение
        if command -v ufw &>/dev/null; then
            echo "Установлен ufw. Отключаем..."
            ufw disable
            if [ $? -eq 0 ]; then
                echo "ufw отключен."
            else
                echo -e "Возникла ошибка при отключении ufw"
                error_disable_firewall=0
                problem_firewall_ufw="ufw"
            fi
            firewall_found="true"
        fi

        # Проверка наличия iptables и его сброс
        if command -v iptables &>/dev/null; then
            echo "Установлен iptables. Очищаем правила..."
            iptables -F \
            && iptables -X \
            && iptables -t nat -F \
            && iptables -t nat -X \
            && iptables -t mangle -F \
            && iptables -t mangle -X
            if [ $? -eq 0 ]; then
                echo "Правила iptables очищены."
            else
                echo -e "Возникла ошибка при очистке правил iptables"
                error_disable_firewall=0
                problem_firewall_iptables="iptables"
            fi
            firewall_found="true"
        fi

        # Проверка наличия nftables и его сброс
        if command -v nft &>/dev/null; then
            echo "Установлен nftables. Очищаем правила..."
            nft flush ruleset
            if [ $? -eq 0 ]; then
                echo "Правила nftables очищены."
            else
                echo -e "Возникла ошибка при очистке правил nftables"
                error_disable_firewall=0
                problem_firewall_nftables="nftables"
            fi
            firewall_found="true"
        fi

        # Проверка, был ли найден фаервол
        if [ "$firewall_found" == "false" ]; then
            echo -e "${green_b}На сервере НЕ установлен ни один из перечисленных фаерволов: ufw, iptables и nftables.${end_color}\n"
            # Настройка firewalld
            setup_firewalld
        else
            if [ "$error_disable_firewall" -eq 0 ]; then
                # Инициализация пустой строки для результата
                local problem_firewalls=""

                # Добавляем переменные с пробелами, если они инициализированы
                [ -v problem_firewall_ufw ] && problem_firewalls+="$ufw, "
                [ -v problem_firewall_iptables ] && problem_firewalls+="$nftables, "
                [ -v problem_firewall_nftables ] && problem_firewalls+="$iptables, "

                # Убираем лишнюю запятую и пробел в конце (если они есть)
                problem_firewalls=$(echo "$problem_firewalls" | sed 's/, $//')
                echo -e "${yellow_b_in_red_back}Отключение ${blue_b_in_red_back}'$problem_firewalls'${end_color}${yellow_b_in_red_back} завершилось с ошибкой, выполните их отключение и настройте firwalld (либо любой другой на ваш выбор) самостоятельно после завершения работы данного скрипта${end_color}"
                
                choice_question_error="Продолжить выполнение скрипта?"
                exit_answer_error="Вы ввели недопустимые ответы, запустите скрипт заново"

                ask_user "$choice_question_error" "$exit_answer_error"
                response=$?
                if [ $response -ne 0 ]; then
                    echo -e "${yellow_b_in_red_back}Вы отказались от дальнейшего выполнения скрипта, настройте ${blue_b_in_red_back}'$problem_firewalls'${end_color}${yellow_b_in_red_back} самостоятельно, либо запустите скрипт заново${end_color}"
                    log_message "$end_log_message"
                    exit 0
                fi
            else
                echo -e "${green_b}Проверка завершена. Все найденные фаерволы были отключены.${end_color}\n"
                # Настройка firewalld
                setup_firewalld
            fi
        fi
    else
        echo -e "${yellow_b_in_red_back}Вы ввели отрицательный ответ. В случае некорректной работы почтового сервера CommuniGate Pro${end_color} 
${yellow_b_in_red_back}после установки проверьте наличие фаервола на сервере и правил для него самостоятельно${end_color}\n"
    fi
}
#----------КОНЕЦ ФУНКЦИИ по отключению фаервола----------#
