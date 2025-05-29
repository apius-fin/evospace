#!/bin/bash
reference() {
    echo "Использование: $0 [аргумент]"
    echo "Опции:"
    echo "  deploy --online            Запустить полную онлайн установку CommuniGate Pro (из Интернета)"
    echo "  deploy --offline           Запустить полную офлайн установку CommuniGate Pro (для закрытого контура)"
    echo "  backup --full              Запустить полный бэкап директории /var/CommuniGate"
    echo "  clean --all-files          Удалить технические файлы, оставшиеся после выполнения скрипта с другими опциями"
    echo "  -h, --help                 Показать полную справку о скрипте"
    exit 0
}