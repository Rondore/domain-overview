#!/bin/bash

ulimit -t 30
ip=$(echo "$1" | head -1 | grep -E '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$')
if [ -z "$ip" ]; then
    #try IPv6
    ip=$(echo "$1" | head -1 | grep -E '^[0-9a-fA-F]+:[0-9a-fA-F:]*:[0-9a-fA-F]+$')
fi

if [ -z "$ip" ]; then
    echo "Argument does not contain a valid IP" >&2
    exit 1
fi

cleanWhois=$(whois "$ip" 2>/dev/null | grep -v "^[#%;\[]");

# taken from https://stackoverflow.com/questions/7359527/removing-trailing-starting-newlines-with-sed-awk-tr-and-friends
# Delete all leading blank lines at top of file (only).
cleanWhois=$(echo "$cleanWhois" | sed '/./,$!d')

# Delete all trailing blank lines at end of file (only).
cleanWhois=$(echo "$cleanWhois" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba')

printf "$cleanWhois\n\n"
