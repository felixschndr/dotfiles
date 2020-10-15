diff_function(){
    files=$(git status | grep "geändert" | cut -d ":" -f2-)
    [[ $(echo $files | wc -w ) == 0 ]] && echo -e "\e[32mEs wurden keine Dateien modifiziert\e[39m" && return
    printf '\n%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
    for file in $files; do
        echo -e "\e[96mDatei: $file\e[0m\n"
        git diff --color-words $file
        printf '\n%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
    done
}