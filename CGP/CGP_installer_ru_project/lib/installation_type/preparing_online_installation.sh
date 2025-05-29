#!/bin/bash
preparing_online_installation() {
    # Проверка доступности ресурса с репозиториями CGP
    if ! check_internet; then
        choice_question_offline="У вас нет доступа к ресурсу с репозиторием CGP. Хотите продолжить установку с опциями закрытого контура?"
        exit_answer_offline="Вы ввели недопустимые ответы, запустите скрипт заново"

        ask_user "$choice_question_offline" "$exit_answer_offline"
        response=$?

        if [[ $response -ne 0 ]]; then
            echo -e "${yellow_b_in_red_back}Вы отменили установку в закрытом контуре. Восстановите доступ к ресурсу https://doc.communigatepro.ru/packages/ с репозиторием CGP и попробуйте снова.${end_color}"
            log_message "$end_log_message"
            exit 1
        else
            offline_installation
        fi
    else
        # Получаем ссылку на последний пакет
        package_url=$(get_latest_package_url)
        export package_filename=$(basename "$package_url")
        full_url="https://doc.communigatepro.ru/packages/$package_url"

        # Проверяем, действительно ли ссылка ведет на файл перед скачиванием
        if [[ ! "$package_url" =~ \.deb$ && ! "$package_url" =~ \.rpm$ ]]; then
            echo -e "${yellow_b_in_red_back}Неверный URL пакета: $full_url.${end_color}"
            log_message "$end_log_message"
            exit 1
        fi
        
        echo -e "${white_b_in_orange_back}Найдена актуальная на данный момент версия пакета почтового сервера CommuniGate Pro: $package_filename${end_color}\n"

        if [ ! -f "$download_dir/$package_filename" ]; then
            # Скачиваем файл
            # Проверка наличия утилиты wget и её установка, если она отсутствует
            wget_is_true
            echo "Скачиваем файл с URL: $full_url в директорию $download_dir"
            wget -q --show-progress "$full_url" -O "$download_dir/$package_filename"

            # Проверяем успешность скачивания
            if [ $? -eq 0 ]; then
                echo "Файл успешно загружен и сохранен в $download_dir/$package_filename"
            else
                echo -e "${yellow_b_in_red_back}Ошибка при скачивании файла. Пожалуйста, проверьте интернет-соединение.${end_color}"
                log_message "$end_log_message"
                exit 1
            fi
        else
            echo -e "${yellow_b}Загрузка файла установщика не нужна, актуальная версия почтового сервера CommuniGate Pro уже лежит по пути $download_dir/$package_filename
Будет выполнена установка из данного пакета.${end_color}"
        fi
    fi
}