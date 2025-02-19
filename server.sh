#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//");

headers=$(curl -IL -A '' $1)

server=$(echo "$headers" | sed -nr 's/Server: //p' | head -1)
software=$(echo "$headers" | sed -nr 's/X-Powered-By: //p' | head -1)
hsts=$(echo "$headers" | sed -nr 's/Strict-Transport-Security: //p' | head -1)

echo "Server: $server"
echo "Powered by: $software"
echo "HSTS: $hsts"
echo
