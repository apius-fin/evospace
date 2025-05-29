# evospace/main
## Repository with Programs. MAIN branch

**Contact the author: telegram - [@guzeew_alexander](https://t.me/guzeew_alexander)**  

### [CGP](https://github.com/apius-fi/evospace/tree/main/CGP) Directory
Here are the scripts and programs for working with the Russian mail server CommuniGate Pro:
1. cgp_installer.sh (cgp_installer_ru - Russian version) - A script that allows for fully automated installation/update of CommuniGate Pro. This script includes a parser function implemented in bash, which finds and downloads the latest version of CGP and then installs or updates it to the latest version. If CGP is being installed for the first time, it will suggest disabling the firewall and display useful warnings. Additionally, this script offers the ability to create a backup of the main mail directory (/var/CommuniGate) to a user-specified path or the default path suggested by the script.
2. /Parser/cgp_parser.py - A simple parser for downloading the CommuniGate Pro package based on the user-selected distribution type.

-------------------------------------------------------------------------------------------
### [Scripts_for_Linux](https://github.com/apius-fi/evospace/tree/main/Scripts_for_Linux) Directory
Here are the scripts designed to automate routine tasks in Linux-based operating systems:
1. /Script_for_base_configuring_deb_linux/base-configure.d/base_configure.sh - A script for basic configuration of Debian-based Linux distributions. It contains technical files that will configure the OS repositories and install the specified packages.
2. node_exporter_installer.sh - A script for installing node exporter on a host for monitoring through Prometheus.

-------------------------------------------------------------------------------------------
### [Site_about_Space](https://github.com/apius-fi/evospace/tree/main/Site_about_Space) Directory
This is a website about space that I created in 2019 using HTML and CSS. Inside there is a simple server, implemented by me in python, as well as a site generator based on a template, with paths to static files taken as variables.<br><br>

## RU:

### Директория [CGP](https://github.com/apius-fi/evospace/tree/main/CGP)
Здесь находятся скрипты и программы для работы с российским почтовым сервером CommuniGate Pro:
1. cgp_installer.sh (cgp_installer_ru - русифицированная версия) - Скрипт, позволяющий произвести полностью автоматизированную установку/обновление CommuniGate Pro. В данном скрипте есть функционал парсера, реализованный на bash, позволяющий найти и скачать последнюю версию CGP, а затем произвести его установку или обновление до актуальной версии. Если CGP устанавливается впервые, то будет предложено произвести отключение файервола а также отобразятся полезные предупреждения. Также данным скриптом предусмотрена возможность создать бэкап основной почтовой директории /var/CommuniGate по указанному пользователем пути, либо предложенным по умолчанию скриптом.
2. /Parser/cgp_parser.py - Простой парсер для скачивания пакета CommuniGate Pro в зависимости от выбранного пользователем типа дистрибутива.

-------------------------------------------------------------------------------------------
### Директория [Scripts_for_Linux](https://github.com/apius-fi/evospace/tree/main/Scripts_for_Linux)
Здесь расположены скрипты, предназначенные для автоматизации рутинных задач в ОС на базе ядра Linux:
1. /Script_for_base_configuring_deb_linux/base-configure.d/base_configure.sh - Скрипт для проведения базовой конфигурации debian-подобных дистрибутивов Linux. Внутри есть технические файлы, в соотвествии с которыми скрипт настроит репозитории для ОС и установит указанные пакеты.
2. node_exporter_installer.sh - Скрипт для установки node exporter на хост для мониторинга через Prometheus.

-------------------------------------------------------------------------------------------
### Директория [Site_about_Space](https://github.com/apius-fi/evospace/tree/main/Site_about_Space)
Это сайт о космосе, который я написал в 2019 году с использованием HTML и CSS. Внутри есть простой сервер, реализованный мною на python, а также генератор сайта на основе шаблона, в качестве переменных взяты пути до статических файлов.