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
    #Die Dateien durchgehen und gegebenenfalls committen
    unset commit_messages
    changed=false
    file_counter=1


    for file in $files; do #Gehe alle Files durch
        echo -e "\e[96m\e[1m"; center "Datei: $file ($file_counter/$(echo $files | wc -w))"; echo -e "\e[0m\n" #Dateinamen mittig und fett anzeigen
        git --no-pager diff --color-words $file | tail -n +5 #ohne pager, dass alles direkt ausgedruckt wird
        print_line "-"


        echo -e "\e[96m\e[1mWie soll die Commit-Nachricht lauten?\e[0m"
        [[ ${#commit_messages[@]} != 0 ]] && echo -e "Die letzten Commit Nachrichten: \e[2m(Um eine davon zu benutzen, die entsprechende Zahl angeben) \e[0m" #Wenn es vorherige Commits gibt werden diese nun angezeigt
        commit_counter=0
        for commit in ${commit_messages[@]} ; do
            commit_counter=$(( $commit_counter + 1 ))
            [[ -z ${commit_messages[commit_counter]} ]] || echo -e "$commit_counter. ${commit_messages[commit_counter]}"
        done
        read -e commit_message


        last_commit_message=${commit_messages[$(($file_counter - 1))]}
        if [[ -z $commit_message ]]; then #Keine Nachricht angegeben
            echo -e "\e[33mEs wurde keine Nachricht angegeben, somit die Datei wird übersprungen\e[39m"
            continue
        elif [[ $commit_message =~ ^[0-9]+$ ]]; then #Eine Zahl angegeben
            if [[ ${commit_messages[commit_message]} != "0" ]]; then #Gibt es einen Commit, auf den die Zahl trifft? Wenn ja, benutze ihn
                echo -e "Es wird die Nachricht aus einem vorherigen Commit benutzt: \"${commit_messages[commit_message]}\""
                git commit $file -m "${commit_messages[commit_message]}"
            else #Sonst verwerfe ihn
                echo -e "\e[33mEs wurde keine Nachricht angegeben, somit die Datei wird übersprungen\e[39m"
                continue
            fi
        elif [[ $commit_message == "a" ]]; then #Abbrechen
            echo -e "\e[31mAbbrechen\e[39m"
            return 1
        elif [[ $commit_message == "l" ]]; then #Der letzte Commit soll verwendet werden
            if [[ $last_commit_message == "" ]]; then #Gibt es einen letzten Commit?
                echo -e "\e[33mEs wurde keine Nachricht angegeben, somit die Datei wird übersprungen\e[39m"
                continue
            fi
            echo "Die letzte Commit-Nachricht wird verwendet"
            git commit $file -m "$last_commit_message"
        else #Commit mit dem angegeben Text
            commit_messages[$((${#commit_messages[@]} + 1 ))]="$commit_message" #Den aktuellen Commit ins Array packen
            git commit $file -m "$commit_message"
        fi
        file_counter=$(($file_counter + 1))
        changed=true
    done


    unset commit_messages #Das Array mit den Commitnachrichten wieder leeren


    print_line "="


    #Prüfen, ob Commits angegeben wurden
    if [ "$changed" = false ]; then echo -e "\e[31mEs wurden keine Commits angegeben\e[39m"; return 1; fi
}


push(){
    #Hier geht es drum alle Änderungen zu pushehn
    read -e answer
    if [[ $answer =~ ^[YyJj]$ ]]; then
        output=$(git push 2>&1)
	if [[ $output == *"completed"* ]]; then
	    echo -e "\e[32mDie Commits wurden hochgeladen\e[39m"
	elif [[ $output == *"git pull"* ]]; then
	    echo -e "\e[33mDas Repository muss erst gemergt werden\e[39m"
	    git pull
	    git push
	    echo -e "\e[32mDie Commits wurden hochgeladen\e[39m"
	else
	    echo -e "\e[31mEs gab ein Problem beim Hochladen!\e[39m"
	fi
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
            if [[ $(git status) == *"Commit vor "* ]] || [[ $(git status) == *"Commits vor "* ]]; then
                amount=$(git status | sed '2!d' | sed 's/[^0-9]*//g')
		if [[ $amount == 1 ]]; then
		    echo -e "\e[33mEs gibt noch einen Commit, der noch nicht hochgeladen wurde. Soll er jetzt hochgeladen werden?\e[39m"
		    git log origin/master..master | sed -n 5p
		else
		    echo -e "\e[33mEs gibt noch $amount Commits, die noch nicht hochgeladen wurden. Sollen sie jetzt hochgeladen werden?\e[39m"
		    git log origin/master..master | grep -v "Author\|Date" | egrep -v [a-z0-9]{40} | sed '/^[[:space:]]*$/d' | nl
		fi
                push
                return
            fi
            echo -e "\e[32mEs wurden keine Dateien modifiziert\e[39m"
            return;;
        1) echo -e "\e[96m\e[1m\nEs wurde eine Datei modifiziert\e[0m";;
        *) echo -e "\e[96m\e[1m\nEs wurden $(echo $files | wc -w ) Dateien modifiziert\e[0m";;
    esac


    if ! commit_files; then return; fi


    echo -e "\e[32mSollen die Änderungen gepusht werden?\e[39m"
    push
}
