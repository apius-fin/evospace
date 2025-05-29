#!/bin/bash
#----------------------------------------------------------ОСНОВНАЯ ФУНКЦИЯ СКРИПТА----------------------------------------------------------#
main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            deploy) 
                deploy=true
                shift
                # Проверяем, что следующий аргумент --online или --offline
                if [[ $# -eq 0 || ("$1" != "--online" && "$1" != "--offline") ]]; then
                    echo -e "${yellow_b_in_red_back}Ошибка: после 'deploy' требуется аргумент --online или --offline${end_color}"
                    usage
                    exit 1
                fi
                ;;
            --online)
            if [[ "$deploy" != true ]]; then
                echo -e "${yellow_b_in_red_back}Ошибка: --online требует аргумента 'deploy' в начале${end_color}"
                exit 1
            fi
                # Инициализация скрипта
                initialization "deploy" "$log_file_name_allias_for_installation"

                # Определяем тип дистрибутива
                distrib_type

                # Запускаем функции онлайн установки
                preparing_online_installation
                install_package_cgp

                # Reboot
                reboot_host_after_installation

                shift  # Обработанный аргумент
                ;;
            --offline)
                if [[ "$deploy" != true ]]; then
                    echo -e "${yellow_b_in_red_back}Ошибка: --offline требует аргумента 'deploy' в начале${end_color}"
                    exit 1
                fi
                # Инициализация скрипта
                initialization "deploy" "$log_file_name_allias_for_installation"

                # Определяем тип дистрибутива
                distrib_type

                # Запускаем функции офлайн установки
                preparing_offline_installation
                install_package_cgp

                # Reboot
                reboot_host_after_installation
                
                shift  # Обработанный аргумент
                ;;
            backup) 
                backup=true
                shift
                # Проверяем, что следующий аргумент --full
                if [[ $# -eq 0 || ("$1" != "--full") ]]; then
                    echo -e "${yellow_b_in_red_back}Ошибка: после 'backup' требуется аргумент --full${end_color}"
                    usage
                    exit 1
                fi
                ;;
            --full)
                if [[ "$backup" != true ]]; then
                    echo -e "${yellow_b_in_red_back}Ошибка: --full требует аргумента 'backup' в начале${end_color}"
                    exit 1
                fi
                # Полный бэкап директории /var/CommuniGate
                initialization "backup" "$log_file_name_allias_for_backup"
                backup_var_cgp "local"

                shift  # Обработанный аргумент
                ;;
            clean) 
                clean=true
                shift
                # Проверяем, что следующий аргумент --all-files
                if [[ $# -eq 0 || ("$1" != "--all-files") ]]; then
                    echo -e "${yellow_b_in_red_back}Ошибка: после 'clean' требуется аргумент --all-files${end_color}"
                    usage
                    exit 1
                fi
                ;;
            --all-files)
                if [[ "$clean" != true ]]; then
                    echo -e "${yellow_b_in_red_back}Ошибка: --all-files требует аргумента 'clean' в начале${end_color}"
                    exit 1
                fi
                # Полный бэкап директории /var/CommuniGate
                initialization "clean"
                clean_tech_files "all-files"

                shift  # Обработанный аргумент
                ;;
            -h|--help)
                reference
                ;;
            *)
                echo -e "${yellow_b_in_red_back}Ошибка: Неизвестный аргумент '$1'${end_color}"
                usage
                ;;
        esac
    done
}
#----------------------------------------------------------КОНЕЦ ОСНОВНОЙ ФУНКЦИИ СКРИПТА----------------------------------------------------------#