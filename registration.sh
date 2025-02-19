#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//");

isdata=$(whois $domain | grep -v '^%');
echo "$isdata" | grep -i "No match for domain";
echo "$isdata" | grep -i "registrar" | grep -viE "(for information|For more information|informational purposes only|Abuse|IANA|expir.*\:)";
echo "$isdata" | grep -i "expir.*:" | grep -vi "For more information";
echo "$isdata" | grep -i "status.*\:" | grep -viE "(Abuse|IANA|expir.*\:)" | grep -v "For more information";
echo "$isdata" | grep -i "nameserver\:\|name\sserver\:\|nserver\:";

# glue records
TLD=${domain##*.}
NS=$(dig +short NS $TLD | head -1)
glue=$(dig +noall +additional NS @$NS "$domain")

if [ ! -z "$glue" ]; then
    echo
    echo "Glue Records:"
    echo "$glue" | while read record; do 
        name=$(echo "${record,,*}" | sed -r 's/\.?(\s).*//g')
        ip=$(echo "$record" | awk '{print $5}')
        doublecheck=$(dig $name @$ip +short)
        if [[ "$ip" == "$doublecheck" ]]; then
            echo "$name - $ip"
        else
            echo "$name - $ip (but DNS gives $doublecheck for this record)"
        fi
        #echo "$name - $ip"
    done
fi

echo # without this, the last line is repeated for some reason
