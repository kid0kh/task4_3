#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

if [ "$#" -ne 2 ];
	then
        echo "WRONG numbers of arguments!" 1>&2
        exit 1
	fi

if ! [[ "$2" =~ ^[0-9]*$ ]];
	then
        echo "$2 is not a number" 1>&2
	fi

if [ ! -d "$1" ];
	then
        echo "The $1 directory does not exist!" 1>&2
        exit 1
	fi

if [ ! -d "/tmp/backups" ];
	then
	mkdir /tmp/backups
	fi

name=$(echo "$1" | sed 's/\//-/g' | sed 's/\-$//g' | sed 's/^.//g')

N=$(find /tmp/backups/ -name "$name*" | wc -l)

find /tmp/backups/ -name "$name*" 2> /dev/null | sort | head -$(($N - $2 + 1 )) 2> /dev/null | sed 's/\ /\\\ /g' |xargs rm -f

tar -czf /tmp/backups/"$name"\_$(date +%Y-%m-%d_%H:%M:%S).tar.gz $1 2> /dev/null
