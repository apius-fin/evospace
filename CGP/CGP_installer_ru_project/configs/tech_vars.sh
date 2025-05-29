# Основная директрория для файлов работы скрипта
export download_dir="/root/CGP_tech_directory"

# Директория для логов скрипта
export log_dir="$download_dir/logs"
# Аллиасы для лог-файла
export log_file_name_allias_for_installation="cgp_installation"
export log_file_name_allias_for_backup="cgp_backup"

# Инициализация технической переменной для вывода предупреждения в конце скрипта, если не буйдет найдено других версий CGP
export package_exist="false"

# Имена пакетов
export deb_package_name="cgatepro-linux"
export rpm_package_name="CGatePro-Linux"

# Директория для бэкапов по умолчанию
export default_backup_dir="$download_dir/backup"
# Директория, которую нужно бэкапить
export backup_source="/var/CommuniGate"