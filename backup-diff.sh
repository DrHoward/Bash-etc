#!/bin/bash
# Backup diff - Compares a user's current webroot with the most recent backup
#   to see if any changes have been made to any PHP scripts. Download this script and modify it if you would like the search 
#   criteria to include html, css, js, etc. 

read -p "Enter a user: " usr; 
base="/home/$usr/public_html"; 
newest=$(ls -t /backup/cpbackup/|cut -d/ -f1|head -1); ## last modified backup
# newest="monthly"; ## remove the first '#' to force a check on a specific backup

echo "Searching..."; 
for i in $(find $base -type f -name *.php); do
	rel=$(echo $i | sed -e "s|$base||");
	if [[ -e /backup/cpbackup/$newest/$usr/homedir/public_html$rel ]]; then
		out=$(diff $i /backup/cpbackup/$newest/$usr/homedir/public_html$rel);
		if [[ $? -ne 0 ]]; then
			echo "$(echo $out|egrep -o " > | < "|wc -l) difference(s) found in "$i;
		fi;
	else
		echo "Could not find /backup/cpbackup/$newest/$usr/homedir/public_html$rel";
	fi; 
done;
echo "Search complete."
