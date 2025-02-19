#!/bin/bash

ulimit -t 30
ip=$(echo "$1" | head -1 | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')
if [ -z "$ip" ]; then
    #try IPv6
    ip=$(echo "$1" | head -1 | grep -E '^[0-9a-fA-F]+:[0-9a-fA-F:]*:[0-9a-fA-F]+$')
fi

if [ -z "$ip" ]; then
    echo "Argument does not contain a valid IP" >&2
    exit 1
fi

ptr=$(dig -x "$ip" +short 2>/dev/null)
cleanPtr=$(echo "$ptr" | rev | cut -d ' ' -f1 | cut -c2- | rev)
printf "$cleanPtr\n\n"
