#!/bin/bash
## Using Android's Google Auth SQLite structure as pipe-delimited entries
# <num>|<title>|<hashkey>|?|?|?|<Location>|<Original title>
IFS=$'\n'
configfile=~/.totpaccounts
which oathtool > /dev/null
if [[ $? -ne 0 ]]; then
	sudo apt-get install oathtool
fi
if [ -s ${configfile} ]; then
	entries=$(cat ${configfile})
	for entry in ${entries[@]}; do
		location=$(echo ${entry} | cut -d'|' -f7)
		title=$(echo ${entry} | cut -d'|' -f2)
		hashkey=$(echo ${entry} | cut -d'|' -f3)
		if [[ "${location}" == "" ]]; then
			echo "$(oathtool --base32 --totp "${hashkey}" ) | ${title}"
		else
			echo "$(oathtool --base32 --totp "${hashkey}" ) | ${title} (${location})"
		fi
	done
else
	echo "No totpaccounts file ${configfile}"
fi
