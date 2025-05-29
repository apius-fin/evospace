#!/bin/bash

# Функция для автодополнения директорий
_dir_complete() {
    local current_cmd_word=${COMP_WORDS[COMP_CWORD]} # Текущее слово
    COMPREPLY=( $(compgen -d -- "$current_cmd_word") ) # Предложить только директории
    return 0
}

# Error log message checking for backup and installation
error_log_message_check() {
    if [[ $1 == "local" ]]; then
        log_message "$end_log_message_for_backup" false
    else
        log_message "$end_log_message_for_installation" false
    fi
}

    # Функция для создания бэкапа из директории $backup_source при помощи утилиты tar
    creating_backup() {
        # Определяем имя файла для бэкапа
        local backup_filename="CGP_backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
        local progress=0 # Инициализация переменной progress
        local current_backup_fd=0 # Инициализация счётчика для прогресса архивации
        # Подсчитываем общее количество файлов, включая те, что находятся в подкаталогах
        local total_backup_fd=$(find "$backup_source" | wc -l)

        if [ $total_backup_fd -eq 0 ]; then
            echo -e "${yellow_b}В директории $backup_source нет файлов для архивации. Бэкап не будет выполнен.${end_color}"
            return 1
        fi

        # Запускаем архивацию с прогрессом
        tar -czf "$backup_dir/$backup_filename" -C /var CommuniGate --verbose | while read -r line; do
        # Каждая строка - это один файл или каталог, обрабатываемый в архив
            if [[ "$line" =~ .*/.* ]]; then
                # Увеличиваем счётчик обработанных позиций
                current_backup_fd=$((current_backup_fd + 1))
                progress=$((current_backup_fd * 100 / total_backup_fd))
                printf "\rПрогресс: %3d%%  (Обработано %d из %d)" $progress $current_backup_fd $total_backup_fd
            fi
        done

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "\n${green_b}Бэкап успешно сохранён в $backup_dir/$backup_filename${end_color}\n"
        else
            echo "\n${yellow_b_in_red_back}Ошибка при создании бэкапа. Скрипт остановлен. Пожалуйста, проверьте права доступа${end_color}"
            error_log_message_check
            exit 1
        fi
    }

#----------НАЧАЛО ФУНКЦИИ бэкапа----------#

# Бэкапим /var/CommuniGate, если она существует и пользователь дал согласие на это
backup_var_cgp() {
    # backup_source="/var/CommuniGate"
    if [ ! -d "$backup_source" ]; then
        echo -e "${yellow_b}Директория $backup_source отсутствует на сервере. Бэкап не нужен${end_color}\n"
        if [[ $1 == "local" ]]; then
            log_message "$end_log_message_for_backup" false
            exit 1
        fi
        return 1
    else
        echo "Найдена директория $backup_source"
        choice_question_backup="Создать бэкап директории $backup_source в формате tar.gz с меткой времени в имени бэкапа?"
        exit_answer_backup="Вы ввели недопустимые ответы, запустите скрипт заново"

        ask_user "$choice_question_backup" "$exit_answer_backup"
        response=$?

        if [[ $response -eq 0 ]]; then
            # Просим пользователя ввести путь до заданной им директории для бэкапа
            echo -en "${blue_b}Введите путь до ДИРЕКТОРИИ для сохранения бэкапа (по умолчанию: $default_backup_dir):${end_color}\n"
        
            # Включаем автодополнение только для директорий
            complete -o nospace -F _dir_complete -o dirnames read
            read -e user_backup_dir
            complete -r read  # Отключаем автодополнение после ввода
    
            # Инициализируем переменную для пути к бэкапу, которая выберет значение, введённое пользователем, либо, если его нет, возьмёт путь по умолчанию
            backup_dir="${user_backup_dir:-$default_backup_dir}"
            if [ "$backup_dir" == "$default_backup_dir" ]; then
                # Проверяем, существует ли директория для бэкапов
                if [ ! -d "$default_backup_dir" ]; then
                    echo -e "${yellow_b}Заданная по умолчанию директория $default_backup_dir для бэкапов не существует. Создаём её...${end_color}"
                    mkdir -p "$default_backup_dir"  # Создаём директорию для бэкапов
                    echo -e "${green_b} Директория $default_backup_dir создана, приступаем к созданию бэкапа...${end_color}"
                    creating_backup
                else
                    echo -e "Создаём бэкап директории $backup_source..."
                    creating_backup
                fi
            elif [ "$backup_dir" == "$user_backup_dir" ]; then
                if [ ! -d "$user_backup_dir" ]; then
                    echo -e "${yellow_b_in_red_back}Заданная директория $user_backup_dir отсутствует или не примонтирована к серверу в качестве внешнего хранилища${end_color}"
                    if [[ $1 != "local" ]]; then
                        choice_question_error="Продолжить выполнение скрипта без создания бэкапа?"
                        exit_answer_error="Вы ввели недопустимые ответы, запустите скрипт заново"

                        ask_user "$choice_question_error" "$exit_answer_error"
                        response=$?
                        if [ $response -ne 0 ]; then
                            echo -e "${yellow_b_in_red_back}Вы отказались от дальнейшего выполнения скрипта${end_color}"
                            log_message "$end_log_message_for_installation" false
                            exit 0
                        fi
                    else
                        echo -e "${yellow_b_in_red_back}Бэкап директории /var/CommuniGate не может быть выполнен по указанному пути.${end_color}\n"
                        log_message "$end_log_message_for_backup" false
                        exit 1
                    fi
                else
                    creating_backup
                fi
            fi
        else
            echo -e "${yellow_b}Вы ввели отрицательный ответ. Бэкап директории /var/CommuniGate не будет выполнен.${end_color}\n"
        fi
        if [[ $1 == "local" ]]; then
            log_message "$end_log_message_for_backup" false
            exit 0
        fi
    fi
}

#----------КОНЕЦ ФУНКЦИИ бэкапа----------#
