#!/bin/bash
#----------НАЧАЛО ФУНКЦИИ получения ссылки----------#
# Функция для получения списка ссылок на последние версии пакетов (deb или rpm)
get_latest_package_url() {
    local cgp_url="https://doc.communigatepro.ru/packages/"

    # Проверка наличия утилиты curl и её установка, если она отсутствует
    curl_is_true

    # Загружаем страницу и ищем ссылки на файлы .deb или .rpm
    page_content=$(curl -s "$cgp_url")

    if [ "$package_type" == "deb" ]; then
        # Ищем ссылки на .deb файлы, исключая "rc" версии
        mapfile -t package_urls < <(echo "$page_content" | grep -oP 'href="([^"]+\.deb)"' | sed 's/href="//' | sed 's/"//' | grep -v "rc" | grep -i CGatePro-Linux)
    elif [ "$package_type" == "rpm" ]; then
        # Ищем ссылки на .rpm файлы, исключая "rc" версии
        mapfile -t package_urls < <(echo "$page_content" | grep -oP 'href="([^"]+\.rpm)"' | sed 's/href="//' | sed 's/"//' | grep -v "rc" | grep -i CGatePro-Linux)
    fi

    # Если нет ссылок, выводим ошибку и завершаем выполнение скрипта
    if [ -z "$package_urls" ]; then
        echo -e "${yellow_b_in_red_back}Не удалось найти ссылку на пакет. Скрипт завершен.${end_color}"
        log_message "$end_log_message"
        exit 1
    fi

    # Сортируем версии пакетов по номеру версии и релизу, выбираем последний
    latest_package=$(
        printf "%s\n" "${package_urls[@]}" | 
        awk -F'[-_]' '{ 
            # Извлекаем версию и номер релиза
            ver = $3;
            # Заменяем "release" на точку
            sub("release", ".", $4);
            rel = $4;
            print ver "." rel " " $0
        }' | 
        sort -t. -k1,1n -k2,2n -k3,3n -k4,4n | 
        awk '{print $2}' | 
        tail -n 1
    )
    echo "$latest_package"
}
#----------КОНЕЦ ФУНКЦИИ получения ссылки----------#
