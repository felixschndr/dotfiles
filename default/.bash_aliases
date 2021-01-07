#!/bin/bash

alias ..="cd .."; alias ...="cd ../.."; alias ....="cd ../../.."; alias .....="cd ../../../.."
alias dc='cd'
alias ls="ls -lAh --color=always"; alias l='ls'; alias la="ls"; alias ll='ls'; alias sl='la'
alias rm='rm -R'
alias status='git status'
alias update='sudo apt update && sudo apt list --upgradable'
alias upgradable='sudo apt list --upgradable'
alias upgrade='sudo apt upgrade'
alias mygrep='grep -inrs --color=always'
alias nano='nano -li -T 4'
alias less='less -IN'
alias cp='rsync -arh --info=progress2'
alias b='exec $SHELL'
alias which='type'


# PS1='\[\e[01;30m\]\t`\
# if [ $? = 0 ]; then echo "\[\e[00;32m\] ✔ "; else echo "\[\e[00;31m\] ✘ "; fi`\
# \u\[\e[01;37m\]:\[\e[01;36m\]$(pwd)\[\e[00m\]`\
# [[ $(git status 2> /dev/null) =~ (modified|geändert|ahead|vor|behind|hinter|deleted|gelöscht|neu|new) ]] && echo "\[\e[31m\]" || echo "\[\e[32m\]"` \
# $(__git_ps1 "(%s)")\[\e[00m\]\$ '