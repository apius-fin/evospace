#!/bin/bash
# Определяем функцию автодополнения
_restricted_path_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -f -d -- "$cur") )
}

preparing_offline_installation() {
    # Попросим пользователя указать путь до установочного файла
    echo -en "${blue_b}Пожалуйста, укажите полный путь до установочного файла (.deb или .rpm):${end_color}\n"
    # Настраиваем bash completion для директорий и файлов
    complete -F _restricted_path_completion -o filenames read
    read -e offline_package_path # Ключ '-e' включает автодополнение
    complete -r read  # Отключаем паттерн автодополнения после ввода

    # Проверка на существование файла и соответствие типу дистрибутива, где он будет устанавливаться
    if [ ! -f "$offline_package_path" ]; then
        echo -e "${yellow_b_in_red_back}Файл не найден. Убедитесь, что путь указан правильно и запустите скрипт заново.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi
    user_package_filename=$(basename "$offline_package_path")

    # Функция для кода на соответствие типу пакета
    copy_func() {
        if [ ! -f  "$download_dir/$user_package_filename" ]; then
            cp "$offline_package_path" "$download_dir/"
            echo -e "Пакет $user_package_filename скопирован в директорию для установки: $download_dir"
            if [ $? -ne 0 ]; then
                echo "Ошибка при копировании файла."
                log_message "$end_log_message"
                exit 1
            fi
        else
            :
        fi
    }

    # Проверка на соответствие типу пакета
    if [[ "$offline_package_path" == *.deb && "$package_type" == "deb" ]]; then
        echo -e "Пакет .deb выбран правильно для вашего $package_type-дистрибутива."
        copy_func
    elif [[ "$offline_package_path" == *.rpm && "$package_type" == "rpm" ]]; then
        echo -e "Пакет .rpm выбран правильно для вашего $package_type-дистрибутива."
        copy_func
    else
        echo "${yellow_b_in_red_back}Тип пакета $offline_package_path не соответствует менеджеру пакетов, используемого $package_type-дистрибутивом. Установка не может продолжиться${end_color}"
        log_message "$end_log_message"
        exit 1
    fi

    export package_filename=$(basename "$download_dir/$user_package_filename")
}