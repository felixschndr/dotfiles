#!/bin/bash

alias ..="cd .."; alias ...="cd ../.."; alias ....="cd ../../.."; alias .....="cd ../../../.."
alias dc='cd'
alias ls="ls -lh --color=always --time-style='+%H:%M %d.%m.%Y'"; alias l='ls'; alias ll='ls'; alias lll='ls'; alias sl='ls'; alias la="ls -A"
alias rm='rm -R'
alias status='git status'
alias update='sudo apt update && sudo apt list --upgradable'
alias upgradable='sudo apt list --upgradable'
alias upgrade='sudo apt upgrade'
alias mygrep='grep -ins --color=always'
alias nano='nano -li -T 4'
alias less='less -IN'
alias cp='rsync -arh --info=progress2'
alias b='exec $SHELL'
alias which='type'
alias pwd='pwd -P' #Den absoluten Pfad angeben und keine Symnlinks verwenden
