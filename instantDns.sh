#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//")

#tld=$(echo "$domain" | tr '[:upper:]' '[:lower:]' | sed -r 's/.*\.([a-z]*)/\1/')

whois=$(whois $domain | tr '[:upper:]' '[:lower:]')

# look for:
# Nameserver: ns1.example.com
source=$(
    echo "$whois" |
        grep "nameserver\:\|name\sserver\:\|nserver\:" | # reduce whois to nameserver lines
        head -1 | # just use the first line
        sed -r -e 's/(\.?)([ ]*?)$//' -e 's/^([a-z0-9 \-\.]*?)(:)([ ]*?)//' | # remove any trailing spaces and any end period - remove line header
        tr -cd '\40-\176' # remove irregular characters
)

# look for:
# Nameserver:
#     ns1.example.com
if [ -z "$source" ]; then
    source=$(
        echo "$whois" |
            grep -A 1 'name servers:[^a-z]*$' |
            grep -v 'name servers:[^a-z]*$' |
            sed -r 's/^\s*(dns:\s*)?//'
    )
fi

#ns=$(dig $source @8.8.8.8 +short | head -1 | rev | cut -d ' ' -f1 | rev)

cname=$(dig cname $domain @$source +short)
a=$(dig a $domain @$source +short)
txt=$(dig txt $domain @$source +short)
aaaa=$(dig aaaa $domain @$source +short)
ns=$(dig ns $domain @$source +short)
soa=$(dig soa $domain @$source +short)

if  [[ -n $cname ]]; then
    printf "CNAME:\n$cname\n\n"
fi;

printf "A:\n$a\n\n"
printf "NS:\n$ns\n\n"
printf "TXT:\n$txt\n\n"
printf "AAAA:\n$aaaa\n\n"

if [[ -n $a ]]; then
#    ptr=$(echo "$a" | while read in; do dig -x $in @$source +short | rev | cut -d ' ' -f1 | cut -c2- | rev; done;)
    ptr=$(echo "$a" | while read in; do ./ptr.sh $in; done;);
    printf "PTR:\n$ptr\n\n"
fi

if [[ -n $aaaa ]]; then
#    ptr=$(echo "$aaaa" | while read in; do dig -x $in @$source +short | rev | cut -d ' ' -f1 | cut -c2- | rev; done;)
    ptr=$(echo "$aaaa" | while read in; do ./ptr.sh $in; done;);
    printf "IPv6-PTR:\n$ptr\n\n"
fi

printf "SOA:\n$soa\n\n"

printf "SOURCE:\n$source\n\n"
