#!/bin/bash

_item_completions(){
    items=$(curl -X GET "http://localhost:8080/rest/items/" 2>/dev/null| sed 's/,/\n/g' | grep name | grep -v Gruppe | sed 's/name//g' | sed 's/[":]//g')
    local anfang="${COMP_WORDS[$COMP_CWORD]}"

    for item in $( echo $items | sed 's/ /\n/g' | grep -P "^$anfang"); do
	COMPREPLY=("${COMPREPLY[@]}" "$item")
    done
}


complete -F _item_completions itemget itemset


itemget(){
    [ -z ${1} ] && echo -e "\e[31mEs wurde kein Item angegeben\e[39m" && return 1
    for item in $@ ; do
        echo -e "\e[36mItem:\e[39m\t$item\n\e[36mStatus:\e[39m\t\c"
        curl -X GET "http://localhost:8080/rest/items/$item/state"
        [[ $# == 1 ]] || echo -e "\n"
    done
    [[ $# == 1 ]] || return
    echo -e "\e[36m\n\n${1} wird hier gefunden:\e[39m"
    search ${1}
}


itemset(){
    [ -z ${1} ] && echo -e "\e[31mEs wurde kein Item angegeben\e[39m"   && return 1
    [ -z ${2} ] && echo -e "\e[31mEs wurde kein Status angegeben\e[39m" && return 1
    echo -e "\e[36mItem:\e[39m\t\t${1}"
    echo -e "\e[36mAlter Status:\e[39m\t\c"
    curl -X GET "http://localhost:8080/rest/items/${1}/state"
    echo -e "\n\e[36mNeuer Status:\e[39m\t${2}"
    curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d "${2}" "http://localhost:8080/rest/items/${1}/state"
    echo -e "\e[36m\n${1} wird hier gefunden:\e[39m"
    search ${1}
}


ssh_permissions(){
    sudo chown -R openhabian:openhabian /etc/openhab2/.ssh
    chmod 700 ~/.ssh
    chmod 644 ~/.ssh/id_rsa.pub
    chmod 600 ~/.ssh/id_rsa ~/.ssh/authorized_keys  ~/.ssh/config
    sudo -u openhab chmod 700 /var/lib/openhab2/.ssh
    sudo -u openhab chmod 644 /var/lib/openhab2/.ssh/id_rsa.pub
    sudo -u openhab chmod 600 /var/lib/openhab2/.ssh/id_rsa /var/lib/openhab2/.ssh/config
}


fix_permissions(){
    echo -e "Fix Permissions:\n\t1. Apply Improvements\n\t2. Fix Permissions"
    sudo openhabian-config
    ssh_permissions
    echo -e "\e[92mDone\e[39m"
}

logsearch(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return
    grep -Tinr "$1" /var/log/openhab2/openhab.log /var/log/openhab2/events.log || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}