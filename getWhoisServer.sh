#! /bin/sh

if [ -n $1 ]; then
    read -p "TLD: " tld;
else
    tld="$1"
fi

tldInfo=$(curl https://raw.githubusercontent.com/weppos/whois/master/data/tld.json 2>/dev/null | grep -A 8 "\"$tld\": {");

echo "$tldInfo" | sed '/},/q' | grep '"host"' | head -1 | sed -r 's/.*: "([a-zA-Z0-9\.\-]*)".*/\1/'