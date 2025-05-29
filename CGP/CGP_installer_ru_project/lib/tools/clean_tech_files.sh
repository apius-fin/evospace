#!/bin/bash

clean_tech_files() {
    if [[ $1 == "all-files" ]]; then
        if [[ -d "$download_dir" ]]; then
            rm -rf $download_dir
            echo -e "${yellow_b}Директория $download_dir удалена полностью со всем содержимым${end_color}"
        else
            echo -e "${yellow_b_in_red_back}Директория $download_dir отсутствует на сервере, удаление не требуется${end_color}"
            exit 1
        fi
    fi
}