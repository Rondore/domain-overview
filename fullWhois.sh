#! /bin/bash 

ulimit -t 30
whoisServer=$(whois $1 | grep -i "Registrar WHOIS Server" | awk '{print $4}');whois -h $whoisServer $1
