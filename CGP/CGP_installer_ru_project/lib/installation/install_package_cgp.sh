install_package_cgp() {
    # Проверяем, установлен ли уже этот пакет с такой версией
    if [ "$package_type" == "deb" ]; then
        # Получаем точное имя и версию пакета из скачанного .deb файла
        deb_package_name_version=$(dpkg-deb -I "$download_dir/$package_filename" | grep Version | awk '{print $2}')

        # Проверка, установлен ли уже пакет в deb-дистрибутиве
        dpkg -s "$deb_package_name" &>/dev/null
        if [ $? -eq 0 ]; then
            installed_version=$(dpkg -s "$deb_package_name" | grep "Version" | awk '{print $2}')
            if [ "$installed_version" == "$deb_package_name_version" ]; then
                echo -e "${white_b_in_green_back}Пакет $deb_package_name-$installed_version уже установлен в системе.${end_color}"
                info_about_installed_package
                log_message "$end_log_message" false
                exit 0
            else
                package_exist="true"
                backup_var_cgp
            fi
        else
            if [ "$package_type" == "deb" ]; then
                echo -e "${green_b}Пакет $deb_package_name-$deb_package_name_version не установлен в системе. Продолжаем установку...${end_color}\n"
            elif [ "$package_type" == "rpm" ]; then
                echo -e "${green_b}Пакет $rpm_package_name_version не установлен в системе. Продолжаем установку...${end_color}\n"
            fi
            # Бэкап в целях экономии места на диске будет создан только в том случае, когда скрипт убедиться в необходимости установки/обновления пакета CGP
            backup_var_cgp
            # Предлагаем отключить фаервол при первоначальной установке CGP на сервер
            firewall_func
        fi
    elif [ "$package_type" == "rpm" ]; then
        # Получаем имя пакета из скачанного файла .rpm
        rpm_package_name_version=$(rpm -qp "$download_dir/$package_filename")

        # Проверка, установлен ли уже пакет в rpm-дистрибутиве
        rpm -q "$rpm_package_name" &>/dev/null
        if [ $? -eq 0 ]; then
                rpm -q "$rpm_package_name_version" &>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${white_b_in_green_back}Пакет $rpm_package_name_version уже установлен в системе.${end_color}"
                    info_about_installed_package
                    log_message "$end_log_message"
                    exit 0
                else
                    package_exist="true"
                    backup_var_cgp
                fi
        else
            if [ "$package_type" == "deb" ]; then
                echo -e "${green_b}Пакет $deb_package_name-$deb_package_name_version не установлен в системе. Продолжаем установку...${end_color}\n"
            elif [ "$package_type" == "rpm" ]; then
                echo -e "${green_b}Пакет $rpm_package_name_version не установлен в системе. Продолжаем установку...${end_color}\n"
            fi
            # Бэкап в целях экономии места на диске будет создан только в том случае, когда скрипт убедиться в необходимости установки/обновления пакета CGP
            backup_var_cgp
            # Предлагаем отключить фаервол при первоначальной установке CGP на сервер
            firewall_func
        fi
    fi

    # Проверяем наличие и статус службы "CommuniGate" в systemd
    echo -e "${green_b}Проверка наличия запущенной службы 'CommuniGate' на сервере...${end_color}"
    if systemctl list-units --type=service --all | grep "CommuniGate"; then
        # Если служба найдена, проверим её статус
        if systemctl is-active --quiet CommuniGate; then
            systemctl stop CommuniGate
            echo -e "${green_b}Служба 'CommuniGate' остановлена.${end_color}\n"
        else 
            echo -e "${green_b}Служба 'CommuniGate' неактивна.${end_color}\n"
        fi
    else
        echo -e "${green_b}Служба CommuniGate не найдена, остановка не требуется.${end_color}\n"
    fi

    # Устанавливаем скачанный файл в зависимости от типа пакета
    echo -e "${yellow_b}Устанавливаем пакет: $download_dir/$package_filename${end_color}"

    if [ "$package_type" == "deb" ]; then
        # Устанавливаем .deb файл с помощью dpkg
        dpkg -i "$download_dir/$package_filename"
        if [ $? -eq 0 ]; then
            echo -e "${white_b_in_green_back}Пакет .deb успешно установлен.${end_color}"
        else
            echo -e "${yellow_b}Ошибка при установке .deb пакета. Попробуем исправить зависимостями...${end_color}"
            apt-get install -f -y  # Исправление зависимостей для Debian/Ubuntu
            if [ $? -ne 0 ]; then
                echo -e "${yellow_b_in_red_back}Не удалось установить пакет $download_dir/$package_filename. Работа скрипта завершена${end_color}"
                log_message "$end_log_message"
                exit 1
            fi
        fi
    elif [ "$package_type" == "rpm" ]; then
        # Устанавливаем .rpm файл с помощью rpm
        rpm -ivh "$download_dir/$package_filename"
        if [ $? -eq 0 ]; then
            echo -e "${white_b_in_green_back}Пакет .rpm успешно установлен.${end_color}"
        else
            echo -e "${yellow_b}Ошибка при установке .rpm пакета. Попытка установить при помощи DNF...${end_color}"
            dnf install "$download_dir/$package_filename"
            if [ $? -ne 0 ]; then
                echo -e "${yellow_b_in_red_back}Не удалось установить пакет $download_dir/$package_filename. Работа скрипта завершена${end_color}"
                log_message "$end_log_message"
                exit 1
            fi
        fi
    else
        echo -e "${yellow_b_in_red_back}Неизвестный тип пакета. Установка не выполнена. Проверьте, что файл $download_dir/$package_filename является установщиком${end_color}"
        log_message "$end_log_message"
        exit 1
    fi

    # Выводим информацию об установленном пакете
    info_about_installed_package

    # Добавляем службу CommuniGate в автозагрузку, если это необходимо
    if ! systemctl is-enabled --quiet CommuniGate; then
        echo -e "${yellow_b}Добавление службы 'CommuniGate' в автозагрузку...${end_color}"
        systemctl enable CommuniGate
        echo -e "${green_b}Служба 'CommuniGate' добавлена в автозагрузку${end_color}\n"
    else
        echo -e "${green_b}Служба 'CommuniGate' уже добавлена в автозагрузку.${end_color}\n"
    fi
}