#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//");
selector="default"
if [ "$#" -gt 1 ]; then
    selector=$(echo "$2");
fi

mx=$(
    dig mx $domain @8.8.8.8 +short | sort -n | while read in; do
        domayn=$(echo "$in" | cut -d ' ' -f2);
        echo "$in";
        echo "$(dig $domayn @8.8.8.8 +short | sed 's/^/   ^ /')";
        echo "$(dig aaaa $domayn @8.8.8.8 +short | sed 's/^/   ^ /')";
    done;
);
printf "MX:\n$mx\n\n";

spf=$(dig txt $domain @8.8.8.8 +short | grep -i v=spf | cut -d '"' -f $(seq -s, 2 2 100) --output-delimiter='');

echo "SPF:";
echo "$spf" | while read in; do
    spflist=$(echo "$in" | sed "s/[[:blank:]]\+/\n/g" | while read segment; do
        entry=$(echo "$segment" | grep -iv v=spf);
        if [[ -n $entry ]]; then
            if [[ -n $(echo "$entry" | grep "^+\?~\?ip4\:") ]]; then
                echo ">>$(echo "$entry" | sed 's/^+\?~\?-\?ip4://') +ip4";
            elif [[ -n $(echo "$entry" | grep "^+\?~\?ip6\:") ]]; then
                echo ">>$(echo "$entry" | sed 's/^+\?~\?-\?ip6://') +ip6";
            elif [[ -n $(echo "$entry" | grep "^+\?~\?a$") ]]; then
                dig a $domain @8.8.8.8 +short | sed 's/.*/>>& +a/';
                dig aaaa $domain @8.8.8.8 +short | sed 's/.*/>>& +a/';
            elif [[ -n $(echo "$entry" | grep "^+\?~\?mx$") ]]; then
                dig a $(dig mx $domain @8.8.8.8 +short) @8.8.8.8 +short | sed 's/.*/>>& +mx/';
                dig aaaa $(dig mx $domain @8.8.8.8 +short) @8.8.8.8 +short | sed 's/.*/>>& +mx/';
            else
                echo "$entry";
                if [ "$entry" = "~all" ]; then
                    echo 'Warning: soft fail all: consider changing this to "-all"'
                elif [ "$entry" = "+all" ]; then
                    echo '!!! Warning: allow all: change this to "-all" or at least "~all" !!!'
                fi
            fi
        fi
    done;)
    echo "$spflist" | grep '^>>' | sed 's/^>>//' | awk '{ip[$1] = ip[$1] " " $2} END{for(var in ip){print var " (" ip[var] " )"}}'
    echo "$spflist" | grep -v '^>>'
done;

printf "\nRAW SPF:\n$spf\n\n";

dmarc=$(dig txt _dmarc.$domain @8.8.8.8 +short | grep -i v=DMARC | cut -d '"' -f $(seq -s, 2 2 100) --output-delimiter='');

echo "DMARC:";
echo "$dmarc" | while read in; do
    echo "$in" | sed "s/[[:blank:]]\+/\n/g" | while read segment; do
        entry=$(echo "$segment" | grep -iv v=dmarc);
        
        if [[ -n $entry ]]; then
        
            key=$(echo "$entry" | sed "s/=.*//" | tr '[:upper:]' '[:lower:]');
            value=$(echo "$entry" | sed "s/[a-z]*=//" | sed "s/;$//");
            
            if [[ $key = "p" ]]; then
                echo "Policy: $value";
            elif [[ $key = "sp" ]]; then
                echo "Subdomain Policy: $value";
            elif [[ $key = "pct" ]]; then
                echo "Percent: $value";
            elif [[ $key = "rua" ]]; then
                echo "Report Daily To: $value";
            elif [[ $key = "ruf" ]]; then
                echo "Report Immediately To: $value";
            else
                echo "$entry";
            fi
            
        fi
        
    done;
done;

printf "\nRAW DMARC:\n$dmarc\n\n";

dkim=$(dig txt $selector._domainkey.$domain @8.8.8.8 +short | grep -i v=DKIM | cut -d '"' -f $(seq -s, 2 2 100) --output-delimiter='');
printf "DKIM:\n$dkim\n\n";
