#!/bin/bash

# Функция для проверки установки firewalld и добавления разрешенных портов
setup_firewalld() {
    # Проверяем установку firewalld
    echo -e "${purple_b}!Начало настройки firewalld!${end_color}"
    if ! command -v firewalld &> /dev/null; then
        echo "firewalld не установлен. Устанавливаем..."
        if [ "$package_type" == "deb" ]; then
            sudo apt update
            sudo apt install -y firewalld
        elif [ "$package_type" == "rpm" ]; then
            if command -v dnf &>/dev/null; then
                dnf install -y firewalld &> /dev/null
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты firewalld завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            elif command -v yum &>/dev/null; then
                yum install -y firewalld &> /dev/null
                if [ ! $? -eq 0 ]; then
                    echo -e "${yellow_b_in_red_back}Скачивание или установка утилиты firewalld завершилось с ошибкой${end_color}"
                    log_message "$end_log_message"
                    exit 1
                fi
            else
                echo "Не удалось найти подходящий пакетный менеджер для установки firewalld."
                log_message "$end_log_message"
                exit 1
        fi
    else
        echo "firewalld уже установлен."

    fi

    # Запускаем firewalld, если он неактивен
    if ! systemctl is-active --quiet firewalld; then
        echo -e "Запуск firewalld в systemd..."
        systemctl start firewalld
    fi

    # Добавляем firewalld в автозапуск, если его там нет
    if ! systemctl is-enabled --quiet firewalld; then
        echo -e "Добавление firewalld в автозапуск..." 
        sudo systemctl enable firewalld
    fi

    # Очищаем все имеющиеся активные правила
    echo -e "${yellow_b}Очистка активных правил...${end_color}"
    sudo firewall-cmd --permanent --zone=public --remove-rich-rule="rule family='ipv4' source address='0.0.0.0/0' reject" > /dev/null 2>&1
    sudo firewall-cmd --permanent --zone=public --remove-rich-rule="rule family='ipv6' source address='::/0' reject" > /dev/null 2>&1

    # Добавляем разрешенные порты с комментариями о каждом
    echo -e "${yellow_b}Добавление разрешенных портов...${end_color}"

    # 22/tcp - SSH
    sudo firewall-cmd --permanent --add-port=22/tcp # open ssh
    # 25/tcp - SMTP
    sudo firewall-cmd --permanent --add-port=25/tcp # open smtp
    # 80/tcp - HTTP
    sudo firewall-cmd --permanent --add-port=80/tcp # open http
    # 443/tcp - HTTPS
    sudo firewall-cmd --permanent --add-port=443/tcp # open https
    # 106/tcp - POP3PW (secure POP3)
    sudo firewall-cmd --permanent --add-port=106/tcp # open pop3pw
    # 110/tcp - POP3
    sudo firewall-cmd --permanent --add-port=110/tcp # open pop3
    # 111/tcp - RPCBind
    sudo firewall-cmd --permanent --add-port=111/tcp # open rpcbind
    # 143/tcp - IMAP
    sudo firewall-cmd --permanent --add-port=143/tcp # open imap
    # 389/tcp - LDAP
    sudo firewall-cmd --permanent --add-port=389/tcp # open ldap
    # 465/tcp - SMTPS (secure SMTP)
    sudo firewall-cmd --permanent --add-port=465/tcp # open smtps
    # 587/tcp - Submission (SMTP)
    sudo firewall-cmd --permanent --add-port=587/tcp # open submission
    # 636/tcp - LDAPSSL (secure LDAP)
    sudo firewall-cmd --permanent --add-port=636/tcp # open ldapssl
    # 993/tcp - IMAPS (secure IMAP)
    sudo firewall-cmd --permanent --add-port=993/tcp # open imaps
    # 5060/tcp - SIP
    sudo firewall-cmd --permanent --add-port=5060/tcp # open sip
    # 5061/tcp - SIP-TLS (secure SIP)
    sudo firewall-cmd --permanent --add-port=5061/tcp # open sip-tls
    # 5222/tcp - XMPP client
    sudo firewall-cmd --permanent --add-port=5222/tcp # open xmpp-client
    # 5269/tcp - XMPP server
    sudo firewall-cmd --permanent --add-port=5269/tcp # open xmpp-server
    # 8010/tcp - XMPP web
    sudo firewall-cmd --permanent --add-port=8010/tcp # open xmpp
    # 8100/tcp - XPrint server
    sudo firewall-cmd --permanent --add-port=8100/tcp # open xprint-server
    # 8080/tcp - Alternative HTTPS
    sudo firewall-cmd --permanent --add-port=8080/tcp # open https
    # 9010/tcp - SDR (Software Defined Radio)
    sudo firewall-cmd --permanent --add-port=9010/tcp # open sdr
    # 9100/tcp - JetDirect
    sudo firewall-cmd --permanent --add-port=9100/tcp # open jetdirect

    # Перезагружаем настройки firewalld
    echo "${yellow_b}Перезагрузка настроек firewalld...${end_color}"
    sudo firewall-cmd --reload

    echo -e "${white_b_in_green_back}Настройка firewalld завершена.${end_color}"
}