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

PS1='\[\e[01;30m\]\t`\
if [ $? = 0 ]; then echo "\[\e[00;32m\] ✔ "; else echo "\[\e[00;31m\] ✘ "; fi`\
\u\[\e[01;37m\]:\[\e[01;36m\]$(pwd)\[\e[00m\]`\
[[ $(git status 2> /dev/null) =~ (modified|geändert|ahead|vor|behind|hinter|deleted|gelöscht|neu|new) ]] && echo "\[\e[31m\]" || echo "\[\e[32m\]"` \
$(__git_ps1 "(%s)")\[\e[00m\]\$ '