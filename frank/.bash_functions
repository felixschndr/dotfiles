#!/bin/bash

#----------------------------------------------ABM----------------------------------------------

export SSH_ASKPASS="/usr/bin/ksshaskpass"

function los() {
    target_PWD=$(readlink -f .)
    curDir="${target_PWD##*/}"
    SERVERNAME=`pwd | grep -o -P '(?<=customers\/).*(?=\/AB\+MSoftware)' | awk '{system("grep -C2 "$1 "$ /home/fschneider/repos/abmtools/prod-scansys.yml")}' | grep srvname | awk '{print $2}'`
    kd $SERVERNAME "-L 1521:10.200.30.7:1521 -R 22680:vcs.abm-local.de:80 -L 33306:localhost:3306 -L 16543:localhost:6543 -L 9998:172.19.1.222:9998 -L 33206:172.22.1.15:3306"
}



use () {
    cd ~/repos/customers/$1/AB+MSoftware && cconfig && svn up
}

_use () {
    compfile=$HOME/.useCompletion
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()
    if [ -r "$compfile" ]
    then
        if [[ ${SHELL} == /bin/bash ]] ; then
         COMPREPLY=( $(compgen -W "$(cat $compfile)" -- ${cur}) )
        elif [[ ${SHELL} == /bin/zsh ]] ; then
            compadd $(command cat $compfile)
        fi
    else
        if [[ ${SHELL} == /bin/bash ]] ; then
            find $HOME/repos/customers -name 'AB+MSoftware' \( -type d -or -type l \) | cut -d / -f 6- | sed -e 's/\/AB+MSoftware//' | xargs echo > $compfile && COMPREPLY=( $(compgen -W "$(cat $compfile)" -- ${cur}) )
        elif [[ ${SHELL} == /bin/zsh ]] ; then
            find $HOME/repos/customers -name 'AB+MSoftware' \( -type d -or -type l \) | cut -d / -f 6- | sed -e 's/\/AB+MSoftware//' | xargs echo > $compfile && compadd $(command cat $compfile)
        fi
    fi
}

if [[ ${SHELL} == /bin/bash ]] ; then
    complete -F _use use
elif [[ ${SHELL} == /bin/zsh ]] ; then
    compdef _use use
fi


function cconfig {
    DIR=$(pwd)
    pushd .
    cd ~/
    if [[ $DIR == *"/Prod/"* ]]
    then
        if [ -d "$DIR/.config/$USER/prod" ]
        then
            ln -sf $DIR/.config/$USER/prod/config.abm .
            ln -sf $DIR/.config/$USER/prod/config.abm.local.linux config.abm.local
        else
            ln -sf $DIR/.config/$USER/cnf_prod/config.abm .
            ln -sf $DIR/.config/$USER/cnf_prod/config.abm.local.linux config.abm.local
        fi
    elif [[ $DIR == *"/Test/"* ]]
    then
        if [ -d "$DIR/.config/$USER/test" ]
        then
            ln -sf $DIR/.config/$USER/test/config.abm .
            ln -sf $DIR/.config/$USER/test/config.abm.local.linux config.abm.local
        else
            ln -sf $DIR/.config/$USER/cnf_test/config.abm .
            ln -sf $DIR/.config/$USER/cnf_test/config.abm.local.linux config.abm.local
        fi
    elif [[ $DIR == *"/AES/"* ]]
    then
        echo "Git-Repo, bitte test oder prod eingeben, im Anschluss [ENTER]:"
        read SWITCH
        if [[ $SWITCH == "test" ]]
        then
            ln -sf $DIR/.config/$USER/test/config.abm .
            ln -sf $DIR/.config/$USER/test/config.abm.local.linux config.abm.local
        elif [[ $SWITCH == "prod" ]]
        then
            ln -sf $DIR/.config/$USER/prod/config.abm .
            ln -sf $DIR/.config/$USER/prod/config.abm.local.linux config.abm.local
        else
            echo "Falsche Eingabe, Verlinkung hat nicht geklappt."
        fi
    else
        ln -sf $DIR/.config/$USER/config.abm .
        ln -sf $DIR/.config/$USER/config.abm.local.linux config.abm.local
    fi
    ln -sf $DIR/scan .
    popd
}

stable()
{
    TOOL="$1"
    shift
    LD_LIBRARY_PATH="$HOME/repos/deliveries/stable/libraries64/extern/libs/linux:$HOME/repos/deliveries/stable/libraries64/rec1/libs/linux:$LD_LIBRARY_PATH" "$HOME/repos/deliveries/stable/tools64/rec1/linux/${TOOL}" "$@"
}

staging()
{
    TOOL="$1"
    shift
    LD_LIBRARY_PATH="$HOME/repos/deliveries/staging/libraries/extern/libs/linux:$HOME/repos/deliveries/staging/libraries/rec1/libs/linux:$LD_LIBRARY_PATH" "${HOME}/repos/deliveries/staging/tools/rec1/linux/${TOOL}" "$@"
}


#---------------------------------------------Custom---------------------------------------------

build()
{
    dpkg-buildpackage -us -uc || return 1
    mv ../abm-*.deb .
    find ../abm-* -maxdepth 1 -type f -exec rm {} \;
    debian/rules clean
    sudo dpkg -i $(ls -1t *.deb | head -1 | egrep -o "abm.{1,}deb")
}

