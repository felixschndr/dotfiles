_item_completions()
{
    items=$(curl -X GET "http://localhost:8080/rest/items/" 2>/dev/null| sed 's/,/\n/g' | grep name | grep -v Gruppe | sed 's/name//g' | sed 's/[":]//g')
    local anfang="${COMP_WORDS[$COMP_CWORD]}"

    for item in $( echo $items | sed 's/ /\n/g' | grep -P "^$anfang"); do
	    COMPREPLY=("${COMPREPLY[@]}" "$item")
    done
}

complete -F _item_completions itemget itemset


itemget(){
    [ -z ${1} ] && echo "Es wurde kein Item angegeben" && return 1
    while (( "$#" )); do
        echo -e "Item:\t${1}\nState:\t\c"
        curl -X GET "http://localhost:8080/rest/items/${1}/state"
        echo
        shift
    done
}

itemset(){
    [ -z ${1} ] && echo "Es wurde kein Item angegeben" && return 1
    [ -z ${2} ] && echo "Es wurde kein Status angegeben" && return 1
    echo -e "Item:\t${1}\nState:\t${2}"
    curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d "${2}" "http://localhost:8080/rest/items/${1}/state"
}


ssh_permissions(){
	chmod 700 ~/.ssh
	chmod 644 ~/.ssh/id_rsa.pub
	chmod 600 ~/.ssh/id_rsa ~/.ssh/authorized_keys  ~/.ssh/config
	sudo -u openhab chmod 700 /var/lib/openhab2/.ssh
    sudo -u openhab chmod 644 /var/lib/openhab2/.ssh/id_rsa.pub
    sudo -u openhab chmod 600 /var/lib/openhab2/.ssh/id_rsa /var/lib/openhab2/.ssh/config
	echo "Done"
}