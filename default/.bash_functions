#!/bin/bash

search_function(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    grep -inr "$1" ./* || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}

alias search='search_function'
