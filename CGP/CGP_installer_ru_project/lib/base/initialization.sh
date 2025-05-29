#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ инициализации скрипта----------#
initialization() { 
    if [[ $1 == "deploy" ]]; then
        echo -e "\n${purple_b}Вы запустили скрипт $0 с опцией deploy. Он является интерактивным и в данной вариации использования 
предназначен для установки с нуля или обновления до актуальной версии почтового сервера CommuniGate Pro${end_color}\n"
    elif [[ $1 == "backup" ]]; then
        echo -e "\n${purple_b}Вы запустили скрипт $0 с опцией backup. Он является интерактивным и в данной вариации использования 
предназначен для бэкапа рабочих директорий почтового сервера CommuniGate Pro${end_color}\n"
    elif [[ $1 == "clean" ]]; then
        echo -e "\n${purple_b}Вы запустили скрипт $0 с опцией clean. Он является интерактивным и в данной вариации использования 
предназначен для удаления технических файлов скрипта, которые были созданы во время его выполнения с другими параметрами${end_color}\n"
        choice_question_start="Вы уверены в том, что хотите полностью удалить техническую директорию скрипта $download_dir со всем содержимым?"
        exit_answer_start="Выполнение скрипта остановлено"

        ask_user "$choice_question_start" "$exit_answer_start"
        response=$?
        if [ $response -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}Вы отказались от удаления директории ${download_dir}${end_color}"
            exit 0
        fi
    fi

    # Проверяем, что скрипт запущен от имени пользователя root
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${yellow_b_in_red_back}Этот скрипт должен быть запущен от имени пользователя root.${end_color}"
        echo -e "${yellow_b_in_red_back}Пожалуйста, выполните перед запуском скрипта команду: ${underline_text}sudo su${end_color}"
        exit 1
    fi

    if [[ $1 == "deploy" || $1 == "backup" ]]; then
        choice_question_start="Продолжить выполнение скрипта?"
        exit_answer_start="Выполнение скрипта остановлено"

        ask_user "$choice_question_start" "$exit_answer_start"
        response=$?
        if [ $response -ne 0 ]; then
            echo -e "${yellow_b_in_red_back}Вы отказались от выполнения скрипта${end_color}"
            exit 0
        fi
        # Инициализируем основную директорию для работы скрипта
        # Проверяем, существует ли директория для работы скрипта
        if [[ $1 == "deploy" ]]; then
            if [ ! -d "$download_dir" ]; then
                echo -e "\n${green_b}Директория $download_dir не существует. Скрипт будет использовать эту директорию для сохранения лога скрипта, файла установщика и по умолчанию для бэкапов.
            Создаём директорию $download_dir...${end_color}"
                mkdir -p "$download_dir"  # Создаём директорию и все промежуточные
            else
                echo -e "\n${green_b}Скрипт будет использовать директорию $download_dir для сохранения лога скрипта, файла установщика и по умолчанию для бэкапов.${end_color}"
            fi
        fi
            echo "" # Отступ для красивого оформления
            # Инициализируем директорию для логов скрипта, если она отсутствует
            if [ ! -d "$log_dir" ]; then
                mkdir -p "$log_dir"
            fi
            log_message "Starting script" true "$2"
    fi

}
#----------КОНЕЦ ФУНКЦИИ инициализации скрипта----------#
