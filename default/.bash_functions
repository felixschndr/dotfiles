#!/bin/bash

search_string(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    if [[ $# == 1 ]]; then
        grep -inrs "${1}" ./* || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
    else
        grep -inrs "${1}" "${2}" || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
    fi
}

search_file(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    #Grep, um eine Fehlermeldung bei keinen Suchergebnissen anzeigen zu können und die Fundorte farbig zu markieren
    find . -iname "*${1}*" | grep -i "${1}" --color=always || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}

search_help(){
    echo -e "\e[96mFunktion\tBeschreibung\e[39m\n"
    echo -e "search_string\tSucht rekursiv nach einem gegebenen String im aktuellen Verzeichnis\n\t\t    oder in einem als zweites Argument übergebenen gegeben Verzeichnis"
    echo -e "search_file\tSucht rekursiv nach einer Datei mit dem gegebenen Namen im aktuellen Verzeichnis"
    [[ $(hostname) == "openhab" ]] && echo -e "search_log\tSucht nach einem gegebenen String in den Logs"
    echo -e "search_help\tZeigt diese Hilfe an"
}


repeat(){
    trap 'echo "" && return 0' SIGINT
    local counter=0
    while (true); do
        ((counter ++))
        echo -e "\e[96m\e[1m\n"; center "$(date +%T) ($counter)"; echo -e "\e[0m"
        bash -c "$@"
        sleep 1
    done
}

complete COMPREPLY=("\"") repeat #Füge ein " nach dem Kommando repeat ein