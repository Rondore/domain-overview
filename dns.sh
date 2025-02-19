#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//");

cname=$(dig cname $domain @8.8.8.8 +short);
a=$(dig $domain @8.8.8.8 +short);
txt=$(dig txt $domain @8.8.8.8 +short);
aaaa=$(dig aaaa $domain @8.8.8.8 +short);
ns=$(dig ns $domain @8.8.8.8 +short);
soa=$(dig soa $domain @8.8.8.8 +short);

if  [[ -n $cname ]]; then
    printf "CNAME:\n$cname\n\n";
fi;

printf "A:\n$a\n\n";
printf "NS:\n$ns\n\n";
printf "TXT:\n$txt\n\n";
printf "AAAA:\n$aaaa\n\n";

if [[ -n $a ]]; then
#    ptr=$(echo "$a" | while read in; do dig -x $in @8.8.8.8 +short | rev | cut -d ' ' -f1 | cut -c2- | rev; done;);
    ptr=$(echo "$a" | while read in; do ./ptr.sh $in; done;);
    printf "PTR:\n$ptr\n\n";
fi;

if [[ -n $aaaa ]]; then
#    ptr=$(echo "$aaaa" | while read in; do dig -x $in @8.8.8.8 +short | rev | cut -d ' ' -f1 | cut -c2- | rev; done;);
    ptr=$(echo "$aaaa" | while read in; do ./ptr.sh $in; done;);
    printf "IPv6-PTR:\n$ptr\n\n";
fi;

printf "SOA:\n$soa\n\n";
