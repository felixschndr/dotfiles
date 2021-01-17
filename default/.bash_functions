#!/bin/bash

search_string(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return 1
    if [[ $# == 1 ]]; then
        grep -inrs "${1}" ./* || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
    else
        grep -inrs "${1}" "${2}" || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
    fi
}

search_file(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return 1
    #Grep, um eine Fehlermeldung bei keinen Suchergebnissen anzeigen zu können und die Fundorte farbig zu markieren
    find . -iname "*${1}*" | grep -i "${1}" --color=always || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}

search_help(){
    echo -e "\e[96mFunktion\t\tBeschreibung\e[39m\n"
    echo -e "search_string\t\tSucht rekursiv nach einem gegebenen String im aktuellen Verzeichnis\n\t\t\t    oder in einem als zweites Argument übergebenen gegeben Verzeichnis"
    echo -e "search_file\t\tSucht rekursiv nach einer Datei mit dem gegebenen Namen im aktuellen Verzeichnis"
    [[ $(hostname) == "openhab" ]] && echo -e "search_log\t\tSucht nach einem gegebenen String in den Logs"
    echo -e "search_help\t\tZeigt diese Hilfe an"
}


repeat(){
    [[ -z ${2} ]] && sleeptime="1.0" || sleeptime=$(echo ${2} | sed 's/,/./')
    local counter=0
    while (true); do
        ((counter ++))
        echo -e "\n\e[96m\e[1m"; center "   $(date +%T)   |   Durchlauf: $counter   |   Alle $(echo $sleeptime | sed 's/\./,/')s   |   Kommando: ${1}   "; echo -e "\e[0m"
        bash -c "${1}"
        read -t $sleeptime
    done
}
