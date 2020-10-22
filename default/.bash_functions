#!/bin/bash

print_line(){
    printf '\n%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ${1}
}

center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

diff_function(){
    COLUMNS=$(tput cols)
    files=$(git status | grep "geändert" | cut -d ":" -f2-)
    case $(echo $files | wc -w ) in
        0) echo -e "\e[32mEs wurden keine Dateien modifiziert\e[39m" && return;;
        1) echo -e "\e[96m\e[1m\nEs wurde 1 Datei modifiziert\e[0m";;
        *) echo -e "\e[96m\e[1m\nEs wurden $(echo $files | wc -w ) Dateien modifiziert\e[0m";;
    esac
    changed=false
    counter=1

    #Commits
    for file in $files; do
        echo -e "\e[96m\e[1m"
        center "Datei: $file ($counter/$(echo $files | wc -w))"
        echo -e "\e[0m\n"
        counter=$(($counter + 1))
        git --no-pager diff --color-words $file | tail -n +5
        print_line "-"
        echo -e "\e[96m\e[1mWie soll die Commit-Nachricht lauten?\e[0m"
        read commit_message
        if [ -z $commit_message ]; then
            echo -e "\e[33mEs wurde keine Nachricht angegeben somit die Datei wird übersprungen\e[39m"
            continue
        else
            git commit $file -m "$commit_message"
            changed=true
        fi
    done
    print_line "="

    if [ "$changed" = false ]; then echo -e "\e[31mEs wurden keine Commits angegeben\e[39m"; return; fi
    #Push
    echo -e "\e[32mSollen die Änderungen gepusht werden?\e[39m"
    read answer
    if [[ $answer =~ ^[YyJj]$ ]]; then
        git push
        echo -e "\e[32mDie Commits wurden hochgeladen\e[39m"
    else
        echo -e "\e[33mDie Änderungen werden nicht hochgeladen\e[39m"
    fi
}

