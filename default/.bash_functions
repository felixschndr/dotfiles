#!/bin/bash

diff_function(){
    files=$(git status | grep "geändert" | cut -d ":" -f2-)
    case $(echo $files | wc -w ) in
        0) echo -e "\e[32mEs wurden keine Dateien modifiziert\e[39m" && return;;
        1) echo -e "\e[1m\nEs wurde 1 Datei modifiziert\e[0m";;
        *) echo -e "\e[1m\nEs wurden $(echo $files | wc -w ) Dateien modifiziert\e[0m";;
    esac
    printf '\n%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
    for file in $files; do
        echo -e "\e[96m\e[1mDatei: $file\e[0m\n"
        git diff --color-words $file
        printf '\n%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
    done
}
