#!/bin/bash

alias ..="cd .."; alias ...="cd ../.."; alias ....="cd ../../.."; alias .....="cd ../../../.."
alias dc='cd'
alias ls="ls -lAh --color=always"; alias l='ls'; alias la="ls"; alias ll='ls'; alias sl='la'
alias rm='rm -R'
alias status='git status'
alias update='sudo apt update && sudo apt list --upgradable'
alias upgradable='sudo apt list --upgradable'
alias upgrade='sudo apt upgrade'
alias grep='grep -is --color=always' #Darf nicht erweitert werden, da sonst diverse Scripte abstürzen
alias mygrep='grep -inrs --color=always'
alias nano='nano -li -T 4'
alias less='less -IN'
alias cp='rsync -arh --info=progress2'
