#!/bin/bash
ulimit -t 30

emailHost=$(dig mx $1 +short | sed 's/^[0-9]* //' | head -1)
if [ -z "$emailHost" ]; then
    echo "No mail host found"
    echo
else
    emailIp=$(dig $emailHost +short | head -1)
    emailHostname=$(echo "QUIT" | nc $emailIp 587 2>/dev/null | head -1 | sed -r 's/([0-9]*-)([a-zA-Z0-9\.\-]*)(.*)/\2/' | sed 's/\.$//')
    emailPtr=$(dig -x $emailIp +short | head -1 | sed 's/\.$//')
    
    echo "Email:"
    echo "MX: $emailHost"
    echo "IP: $emailIp"
    echo "PTR: $emailPtr"
    echo "Hostname: $emailHostname"
    if [ "$emailPtr" != "$emailHostname" ]; then
        echo "*** PTR MISMATCH ***"
    fi
    echo
fi


webIp=$(dig $1 +short | head -1)
ptr=$(dig -x $webIp +short | head -1 | sed 's/\.$//')
webHost=$(echo "QUIT" | nc $webIp 587 2>/dev/null | head -1 | sed -r 's/([0-9]*-)([a-zA-Z0-9\.\-]*)(.*)/\2/' | sed 's/\.$//')

echo "Web:"
echo "IP: $webIp"
echo "PTR: $ptr"
echo "Host: $webHost"
echo
