#!/bin/bash
#  __           _       _      __                                                  
# / _\ ___ _ __(_)_ __ | |_   / _| ___  _ __                                       
# \ \ / __| '__| | '_ \| __| | |_ / _ \| '__|                                      
# _\ \ (__| |  | | |_) | |_  |  _| (_) | |                                         
# \__/\___|_|  |_| .__/ \__| |_|  \___/|_|                                         
#                |_|                                                               
#                  _       _   _                               _                   
#  _   _ _ __   __| | __ _| |_(_)_ __   __ _    __ _ _ __   __| |                  
# | | | | '_ \ / _` |/ _` | __| | '_ \ / _` |  / _` | '_ \ / _` |                  
# | |_| | |_) | (_| | (_| | |_| | | | | (_| | | (_| | | | | (_| |                  
#  \__,_| .__/ \__,_|\__,_|\__|_|_| |_|\__, |  \__,_|_| |_|\__,_|                  
#  _    |_|    _        _ _ _          |___/                                       
# (_)_ __  ___| |_ __ _| | (_)_ __   __ _                                          
# | | '_ \/ __| __/ _` | | | | '_ \ / _` |                                         
# | | | | \__ \ || (_| | | | | | | | (_| |                                         
# |_|_| |_|___/\__\__,_|_|_|_|_| |_|\__, |                                         
#    ___                            |___/     _   ___      _         ___           
#   / __\___  _ __ ___  _ __ ___  _   _ _ __ (_) / _ \__ _| |_ ___  / _ \_ __ ___  
#  / /  / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| |/ /_\/ _` | __/ _ \/ /_)/ '__/ _ \ 
# / /__| (_) | | | | | | | | | | | |_| | | | | / /_\\ (_| | ||  __/ ___/| | | (_) |
# \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_\____/\__,_|\__\___\/    |_|  \___/ 
#
#-----------------------------------------------------------------------------------
# Developed by Alexander Guzeew (@guzeew_alex) in December 2024
# All Rights reserved by the LICENSE. Copyright © 2024 Guzeew Alexander
#-----------------------------------------------------------------------------------

# Activating strict mode
# set -euo pipefail

# Переход в директорию скрипта
cd "$(dirname "$0")" || { echo "Failed to change directory"; exit 1; }

# Функция для вывода справки
usage() {
    echo -e "Вы пытаетесь выполнить скрипт без использования аргументов, для запуска скрипта выберите нужную вам опцию"
    echo "Использование: $0 [аргумент]"
    echo "Опции:"
    echo "  deploy --online            Запустить полную онлайн установку CommuniGate Pro (из Интернета)"
    echo "  deploy --offline           Запустить полную офлайн установку CommuniGate Pro (для закрытого контура)"
    echo "  backup --full              Запустить полный бэкап директории /var/CommuniGate"
    echo "  clean --all-files          Удалить технические файлы, оставшиеся после выполнения скрипта с другими опциями"
    echo "  -h, --help                 Показать полную справку о скрипте"
    exit 1
}

check_libs_and_vars_files() {
    lib_dir="./lib"
    conf_dir="./configs"

    # Все файлы должны существовать
    required_files=(
        "./bin/main.sh"
        "$lib_dir/base/ask_user.sh"
        "$lib_dir/base/initialization.sh"
        "$lib_dir/base/log_file_init.sh"
        "$lib_dir/base/distrib_type.sh"
        "$lib_dir/base/reference.sh"
        "$lib_dir/tools/backup_var_cgp.sh"
        "$lib_dir/tools/check_internet.sh"
        "$lib_dir/tools/clean_tech_files.sh"
        "$lib_dir/tools/firewall_func.sh"
        "$lib_dir/tools/requirement_software.sh"
        "$lib_dir/tools/setup_firewalld.sh"
        "$lib_dir/installation/get_latest_package_url.sh"
        "$lib_dir/installation/info_about_installed_cgp_pkg.sh"
        "$lib_dir/installation/install_package_cgp.sh"
        "$lib_dir/installation/reboot_host_after_installation.sh"
        "$lib_dir/installation_type/preparing_offline_installation.sh"
        "$lib_dir/installation_type/preparing_online_installation.sh"
        "$conf_dir/color_vars.sh"
        "$conf_dir/tech_vars.sh"
    )

    # Проверяем всё заранее
    missing_files=()
    for file in "${required_files[@]}"; do
        [[ -f "$file" ]] || missing_files+=("$file")
    done

    # Если есть недостающие — выводим список и выходим
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        echo "Error: Missing required files:" >&2
        printf '  - %s\n' "${missing_files[@]}" >&2
        exit 1
    else
        echo "Все необходимые для работы скрипта файлы функций и конфигураций на месте"
    fi

    # Загружаем (теперь гарантированно без ошибок)
    for file in "${required_files[@]}"; do
        source "$file"
    done
}

check_libs_and_vars_files

# Обработка аргументов
if [[ $# -eq 0 ]]; then
    usage
fi

#-------------------------------------------ВЫЗОВ ФУНКЦИИ MAIN СКРИПТА С ПЕРЕДАЧЕЙ ВСЕХ ВВЕДЁННЫХ АРГУМЕНТОВ-------------------------------------------#
main "$@"
