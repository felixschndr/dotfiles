#!/bin/bash

print_line(){
    #Zeichnet eine horizontale Linie; Zeichen wird per ${1} übertragen
    COLUMNS=$(tput cols)
    printf '\n%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ${1}
}


center() {
    #Schreibt einen Text mittig auf der Konsole; Text wird per ${1} übertragen
    termwidth="$(tput cols)"
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}


check_if_repo_exists(){
    #Prüfen, ob ein GIT Repo gefunden wurde
    if [[ $(git status 2>&1) == *"Kein Git-Repo"* ]]; then
        echo -e "\e[31mEs wurde kein GIT Repository gefunden\e[39m"
        return 1
    fi
}


commit_files(){
    #Die Dateien durchgehen und Files committen
    changed=false
    counter=1
    for file in $files; do
        echo -e "\e[96m\e[1m"
        center "Datei: $file ($counter/$(echo $files | wc -w))"
        echo -e "\e[0m\n"
        counter=$(($counter + 1))
        git --no-pager diff --color-words $file | tail -n +5
        print_line "-"
        echo -e "\e[96m\e[1mWie soll die Commit-Nachricht lauten?\e[0m"
        read -e commit_message
        if [[ -z $commit_message ]]; then
            echo -e "\e[33mEs wurde keine Nachricht angegeben, somit die Datei wird übersprungen\e[39m"
            continue
        elif [[ $commit_message == "l" ]] && [[ ! -z $last_commit_message ]]; then
            echo "Die letzte Commit-Nachricht wird verwendet"
            git commit $file -m "$last_commit_message"
        else
            commit_message=$(echo $commit_message)
            last_commit_message=$commit_message
            git commit $file -m "$commit_message"
        fi
        changed=true
    done

    print_line "="

    #Prüfen, ob Commits angegeben wurden
    if [ "$changed" = false ]; then echo -e "\e[31mEs wurden keine Commits angegeben\e[39m"; return 1; fi
}


push(){
    read -e answer
    if [[ $answer =~ ^[YyJj]$ ]]; then
        git push 1>/dev/null &&  echo -e "\e[32mDie Commits wurden hochgeladen\e[39m" || echo -e "\e[31mEs gab ein Problem beim Hochladen\e[39m"
    else
        echo -e "\e[33mDie Änderungen werden nicht hochgeladen\e[39m"
    fi
}


diff_function(){
    if ! check_if_repo_exists; then return; fi

    #Veränderte Files finden und je nach Anzahl verschiedene Verhalten starten
    files=$(git status | grep "geändert\|neue\|gelöscht" | cut -d ":" -f2-)
    case $(echo $files | wc -w ) in
        0) #Es wurden keine Dateien verändert; gibt es noch Commits, die nicht hochgeladen wurden?
            if [[ $(git status) == *"Commit vor"* ]] || [[ $(git status) == *"Commits vor"* ]]; then
                amount=$(git status | sed '2!d' | sed 's/[^0-9]*//g')
		if [[ $amount == 1 ]]; then
		    echo -e "\e[33mEs gibt noch einen Commit, der noch nicht hochgeladen wurden. Soll er jetzt hochgeladen werden?\e[39m"
		    git log origin/master..master | grep -v "Author\|commit\|Date" | sed '/^[[:space:]]*$/d'
		else
		    echo -e "\e[33mEs gibt noch $amount Commits, die noch nicht hochgeladen wurden. Sollen sie jetzt hochgeladen werden?\e[39m"
		    git log origin/master..master  | sed -n 5p
		fi
                push
                return
            fi
            echo -e "\e[32mEs wurden keine Dateien modifiziert\e[39m"
            return;;
        1) echo -e "\e[96m\e[1m\nEs wurde 1 Datei modifiziert\e[0m";;
        *) echo -e "\e[96m\e[1m\nEs wurden $(echo $files | wc -w ) Dateien modifiziert\e[0m";;
    esac

    if ! check_if_repo_exists; then return; fi

    if ! commit_files; then return; fi

    echo -e "\e[32mSollen die Änderungen gepusht werden?\e[39m"
    push
}
