#!/bin/bash
#--------------------------------------------------------------------------------#
#                          MICROCODE_CHECK_FUNCTION                              #
#--------------------------------------------------------------------------------#
microcode_check() {
# Файл для проверки
local file="/proc/cpuinfo"

# Initialization microcode var
export microcode=""

# Используем awk для проверки содержимого файла
awk '
BEGIN {
    intel_found = 0
    amd_found = 0
}
{
    # Проверяем, является ли первое поле строки "vendor_id"
    if ($1 == "vendor_id") {
        # Проверяем, является ли третье поле строки "GenuineIntel"
        if ($3 == "GenuineIntel") {
            intel_found = 1
        }
        # Проверяем, является ли третье поле строки "AuthenticAMD"
        else if ($3 == "AuthenticAMD") {
            amd_found = 1
        }
    }
}
END {
    # Выводим результат в зависимости от найденных значений
    if (intel_found) {
        print "vendor_id: GenuineIntel"
        print "intel-ucode"
    } else if (amd_found) {
        print "vendor_id: AuthenticAMD"
        print "amd-ucode"
    } else {
        print "Ни 'GenuineIntel', ни 'AuthenticAMD' не найдены в файле " ARGV[1]
    }
}
' "$file"

# Сохраняем значение microcode в переменную оболочки
export microcode=$(awk '
BEGIN {
    intel_found = 0
    amd_found = 0
}
{
    # Проверяем, является ли первое поле строки "vendor_id"
    if ($1 == "vendor_id") {
        # Проверяем, является ли третье поле строки "GenuineIntel"
        if ($3 == "GenuineIntel") {
            intel_found = 1
        }
        # Проверяем, является ли третье поле строки "AuthenticAMD"
        else if ($3 == "AuthenticAMD") {
            amd_found = 1
        }
    }
}
END {
    # Возвращаем значение microcode в зависимости от найденных значений
    if (intel_found) {
        print "intel-ucode"
    } else if (amd_found) {
        print "amd-ucode"
    } else {
        print ""
    }
}
' "$file")

echo "Значение переменной microcode в оболочке: $microcode"
}