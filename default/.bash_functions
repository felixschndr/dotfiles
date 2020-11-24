#!/bin/bash

search_string(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    grep -inr "$1" ./* || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}

search_file(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    find . -name "*$1*" | grep . --color=never || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}

search_help(){
    echo -e "\e[96mFunktion\tBeschreibung\e[39m\n"
    echo -e "search_string\tSucht nach einem gegebenen String im aktuellen Verzeichnis"
    echo -e "search_file\tSucht nach einer Datei mit dem gegebenen Namen im aktuellen Verzeichnis"
    echo -e "search_log\tSucht nach einem gegebenen String in den Logs \e[2m(Nur auf OpenHAB verfügbar)\e[0m"
    echo -e "search_help\tZeigt diese Hilfe an"
}
