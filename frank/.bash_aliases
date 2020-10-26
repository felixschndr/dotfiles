#!/bin/bash

[[ $(date +%d) > 15 ]] && m=$(date +%m) || m=$(date --date='-1 month' +'%m')
[[ $(date +%d) > 15 ]] && m1=$(( $(date +%m) + 1)) || m1=$(date +%m)
pfad="/Store/data/Zeiterfassung/Schneider/$(date +%Y)/$m""_""$m1"".ods"
alias zeit="libreoffice6.4 $pfad"
alias tabelle='libreoffice6.4 /Store/data/Service_Support_1st-Lvl/2020\ Übersicht.ods'
alias repoupdate='update-customers-git'
alias OH='ssh -p 8080 openhabian@richard-schneider.spdns.org'
alias OH_Connect='sshfs -p 8080 openhabian@richard-schneider.spdns.org:/etc/openhab2 /home/fschneider/openhab/ && cd /home/fschneider/openhab/ && code .'
alias formreader="stable formreader"
