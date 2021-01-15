#!/bin/bash

_item_completions(){
    items=$(curl -X GET "http://localhost:8080/rest/items/" 2>/dev/null| sed 's/,/\n/g' | grep name | grep -v Gruppe | sed 's/name//g' | sed 's/[":]//g')
    local anfang="${COMP_WORDS[$COMP_CWORD]}"

    for item in $( echo $items | sed 's/ /\n/g' | grep -P "^$anfang"); do
	COMPREPLY=("${COMPREPLY[@]}" "$item")
    done
}


complete -F _item_completions item_get item_set item_toggle search_log search_string


item_get(){
    [ -z ${1} ] && echo -e "\e[31mEs wurde kein Item angegeben\e[39m" && return 1
    for item in $@ ; do
        echo -e "\e[36mItem:\e[39m\t$item\n\e[36mStatus:\e[39m\t\c"
        curl -X GET "http://localhost:8080/rest/items/$item/state"
        [[ $# == 1 ]] || echo -e "\n"
    done
    [[ $# == 1 ]] || return
    echo -e "\n\n${1}\e[36m wird hier gefunden:\e[39m"
    cd
    search_string ${1}
    cd - >/dev/null
}


item_set(){
    [ -z ${1} ] && echo -e "\e[31mEs wurde kein Item angegeben\e[39m"   && return 1
    [ -z ${2} ] && echo -e "\e[31mEs wurde kein Status angegeben\e[39m" && return 1
    echo -e "\e[36mItem:\e[39m\t\t${1}"
    echo -e "\e[36mAlter Status:\e[39m\t\c"
    curl -X GET "http://localhost:8080/rest/items/${1}/state"
    echo -e "\n\e[36mNeuer Status:\e[39m\t${2}"
    curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d "${2}" "http://localhost:8080/rest/items/${1}/state"
    echo -e "\n${1}\e[36m wird hier gefunden:\e[39m"
    cd
    search_string ${1}
    cd - >/dev/null
}

item_toggle(){
    [ -z ${1} ] && echo -e "\e[31mEs wurde kein Item angegeben\e[39m" && return 1
    alter_status=$(curl -X GET http://localhost:8080/rest/items/${1}/state 2>/dev/null)
    echo -e "\e[36mItem:\e[39m\t\t${1}"
    echo -e "\e[36mAlter Status:\e[39m\t$alter_status"
    if [[ $alter_status == "ON" || $alter_status == "On" || $alter_status == "on" ]]; then
        neuer_status="OFF"
    elif [[ $alter_status == "OFF" || $alter_status == "Off" || $alter_status == "off" ]]; then
        neuer_status="ON"
    elif [[ $alter_status == "OPEN" ]]; then
        neuer_status="CLOSED"
    elif [[ $alter_status == "CLOSED" ]]; then
        neuer_status="OPEN"
    else
        echo -e "\n\e[33mDer neue Status konnte nicht bestimmt werden\e[39m" && return 1
    fi
    echo -e "\e[36mNeuer Status:\e[39m\t$neuer_status"
    curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d "$neuer_status" "http://localhost:8080/rest/items/${1}/state"
    echo -e "\n${1}\e[36m wird hier gefunden:\e[39m"
    cd
    search_string ${1}
    cd - >/dev/null
}


ssh_permissions(){
    sudo chown -R openhabian:openhabian /etc/openhab2/.ssh
    chmod 700 ~/.ssh
    chmod 644 ~/.ssh/id_ed25519.pub
    chmod 600 ~/.ssh/id_ed25519 ~/.ssh/authorized_keys  ~/.ssh/config
    sudo -u openhab chmod 700 /var/lib/openhab2/.ssh
    sudo -u openhab chmod 644 /var/lib/openhab2/.ssh/id_ed25519.pub
    sudo -u openhab chmod 600 /var/lib/openhab2/.ssh/id_ed25519 #/var/lib/openhab2/.ssh/config
}


fix_permissions(){
    echo -e "Fix Permissions:\n\t1. Apply Improvements\n\t2. Fix Permissions"
    sudo openhabian-config
    sudo chmod -R a+r items/ sitemaps/ things/ scripts/ rules/ transform/ html/ icons/ logconfig.cfg persistence/ services/ sounds/
    ssh_permissions
    echo -e "\e[92mDone\e[39m"
}

search_log(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    grep -T "${1}" /var/log/openhab2/openhab.log /var/log/openhab2/events.log || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}
