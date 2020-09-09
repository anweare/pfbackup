#!/bin/bash

curl -Lk --cookie-jar cookies.txt https://10.0.41.1/ | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' >csrf.txt
curl -L -k --cookie cookies.txt --cookie-jar cookies.txt --data-urlencode "login=Login" --data-urlencode "usernamefld=admin" --data-urlencode "passwordfld=pfsense" --data-urlencode "__csrf_magic=$(cat csrf.txt)"https://10.0.41.1/ > /dev/null
curl -L -k --cookie cookies.txt --cookie-jar cookies.txt https://10.0.41.1/diag_backup.php | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > csrf.txt
curl -L -k --cookie cookies.txt --cookie-jar cookies.txt --data-urlencode "download=download" --data-urlencode "donotbackuprrd=yes" --data-urlencode "__csrf_magic=$(head -n 1 csrf.txt)" https://10.0.41.1/diag_backup.php > config-router-`date +%Y%m%d%H%M%S`.xml
