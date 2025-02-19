#!/bin/bash

ulimit -t 60

#openssl="openssl"
openssl="/usr/bin/openssl"

site="$1" #read -p "What site? " site;
site="${site,,*}"
cert=$(echo "^D" | $openssl s_client -showcerts -connect $site:443 -servername $site  2>&1)
echo "$cert" | egrep 'depth=|Verify|Protocol[ ]*\:' | tac;
dates=$(echo "$cert" | $openssl x509 -noout -dates);
start=$(echo "$dates" | grep "notBefore" | sed 's/.*=//');
end=$(echo "$dates" | grep "notAfter" | sed 's/.*=//');
now=$(date +%s)
if [ $(date --date="$start" +%s) -lt $now ]; then
    echo -e "Start: $start"; else echo -e "Start: $start";
fi;
if [ $(date --date="$end" +%s) -gt $now ]; then
    echo -e "End: $end";
else
    echo -e "End: $end";
fi;

echo 'Valid Domains:';
valid=$(echo "$cert" | $openssl x509 -noout -text | grep 'DNS:' | tr ',' "\n" | sed 's/^[ ]*DNS://');
echo "$valid" | awk '{print "    " $0}'

match=$(echo "$valid" | while read in;
    do
        patern=$(echo "$valid" | tr '.' '\.' | tr '*' '.')
        singleMatch=$(echo "$site" | grep "$patern")
        if [ -n "$singleMatch" ]; then
            echo "$in"
        fi
    done;)
if [ ! -n "$match" ]; then
    echo -e "DOMAIN NOT COVERED"
fi

echo
