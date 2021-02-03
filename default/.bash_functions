#!/bin/bash

file_info(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Dateiname angegeben\e[39m" && return 1
    [[ ${1} == "." ]] && files=$(find . -type f) || files="$@"
    local counter=0
    local anzahl=$(echo $files | wc -w)
	for file in $files; do
		((counter++))
		[[ -d $file ]] && echo -e "\e[31m\"$file\" ist ein Ordner\e[39m" && continue
		[[ ! -f $file ]] && echo -e "\e[31mDie Datei \"$file\" exisitiert nicht\e[39m" && continue
    	dateiname=$(basename $file)
        echo -e "\e[1;96mDateiname:\t$dateiname\e[0m"
        kompletter_pfad=$(realpath $file)
        echo -e "Absoluter Pfad:\t$kompletter_pfad"
    	echo -e "Größe:\t\t$(du -h $file | cut -f1)"
    	echo -e "Anzahl Zeilen:\t$(cat $file | wc -l | sed ':a;s/\B[0-9]\{3\}\>/.&/;ta')" #sed baut Tausender-Punkte ein
    	echo -e "Modifiziert:\t$(find $file -printf "%CH:%CM:%.2CS Uhr, %Cd.%Cm.%CY (%CA)")"
    	echo -e "Besitzer:\t$(find $file -printf "%u")"
    	echo -e "Gruppe:\t\t$(find $file -printf "%g")"
    	echo -e "Rechte:\t\t$(find $file -printf "%M (%m)" | cut -c 2-)"
    	[[ "$dateiname" =~ ^\..{1,} ]] && versteckt="Ja" ||  versteckt="Nein"
        echo -e "Versteckt:\t$versteckt"
        if [[ $(file $file) == *"CRLF"* ]]; then
            [[ "${kompletter_pfad##*.}" == "sh" ]] && zeilenenden="\e[31mCRLF\e[0m" || zeilenenden="CRLF"
        else
            zeilenenden="LF"
        fi
    	echo -e "Zeilenenden:\t$zeilenenden"
        [ "$anzahl" -gt "$counter" ] && echo -e "\n\n"
    done
    return 0
}

git_url(){
    if [[ "$(git status 2>&1)" =~ (Kein Git-Repo|not a git repository) ]]; then
        echo -e "\e[31mEs wurde kein GIT Repository gefunden\e[0m"
        return 1
    fi
    echo -ne "Repository URL: \e[96m"
    git config --get remote.origin.url | sed 's/\.git//' | sed 's/git@github.com:/https:\/\/www.github.com\//'
    echo -ne "\e[0m"
}

search_string(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return 1
    if [[ $# == 1 ]]; then
        grep -inrs --color=auto "${1}" ./* || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
    else
        grep -inrs --color=auto "${1}" "${2}" || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
    fi
}

search_file(){
    [[ -z ${1} ]] && echo -e "\e[31mEs wurde kein Suchbegriff angegeben\e[39m" && return 1
    #Grep, um eine Fehlermeldung bei keinen Suchergebnissen anzeigen zu können und die Fundorte farbig zu markieren
    find . -iname "*${1}*" | grep -i "${1}" --color=always || echo -e "\e[33mEs wurden keine Sucherergbnisse gefunden\e[39m"
}

search_help(){
    echo -e "\e[96mFunktion\t\tBeschreibung\e[39m\n"
    echo -e "search_string\t\tSucht rekursiv nach einem gegebenen String im aktuellen Verzeichnis\n\t\t\t    oder in einem als zweites Argument übergebenen gegeben Verzeichnis"
    echo -e "search_file\t\tSucht rekursiv nach einer Datei mit dem gegebenen Namen im aktuellen Verzeichnis"
    [[ $(hostname) == "openhab" ]] && echo -e "search_log\t\tSucht nach einem gegebenen String in den Logs"
    echo -e "search_help\t\tZeigt diese Hilfe an"
}

to_lf(){
    for file in $@; do
        if [[ $(file $file) == *"CRLF"* ]]; then
            zeilenenden="\e[31mCRLF"
        else
            zeilenenden="\e[32mLF"
        fi
        echo -e "Ändere die Zeilenenden zu LF von \e[96;1m$file\e[0m\n    War davor: $zeilenenden\e[0m"
        tr -d '\015' <$file >"$file""_new"
        mv "$file""_new" $file
    done
}

repeat(){
    [[ -z ${2} ]] && sleeptime="1.0" || sleeptime=$(echo ${2} | sed 's/,/./')
    local counter=0
    while (true); do
        ((counter ++))

        heading="   $(date +%T)   |   Durchlauf: $counter   |   Alle $(echo $sleeptime | sed 's/\./,/')s   |   Kommando: ${1}   "
        [ "${#heading}" -gt "$(tput cols)" ] && heading="   $(date +%T)   |   Durchlauf: $counter   |   Alle $(echo $sleeptime | sed 's/\./,/')s   "
        echo -e "\n\e[96;1m"; center "$heading"; echo -e "\e[0m"

        bash -c "${1}"
        read -t $sleeptime
    done
}
