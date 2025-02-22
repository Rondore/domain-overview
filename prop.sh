#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//");

google=$(dig soa $domain @8.8.8.8 +short);
cloudflare=$(dig soa $domain @1.1.1.1 +short);
opendns=$(dig soa $domain @208.67.222.222 +short);
norton=$(dig soa $domain @199.85.126.10 +short);
nortonstrict=$(dig soa $domain @199.85.126.30 +short);
comodo=$(dig soa $domain @8.26.56.26 +short);
verizon=$(dig soa $domain @4.2.2.1 +short);
quest=$(dig soa $domain @205.171.3.26 +short);

printf "Google (8.8.8.8):\n$google\n\n";
printf "Cloudflare (1.1.1.1):\n$cloudflare\n\n";
printf "OpenDNS (208.67.222.222):\n$opendns\n\n";
printf "Norton Secure (199.85.126.10):\n$norton\n\n";
printf "Norton Strong Filter (199.85.126.30):\n$nortonstrict\n\n";
printf "Comodo (8.26.56.26):\n$comodo\n\n";
printf "Verizon (4.2.2.1):\n$verizon\n\n";
printf "Century Link (205.171.3.26):\n$quest\n\n";
printf "Note that OpenDNS and Norton block security threats. Norton strong filter also blocks mature content, drugs, gambling, hate, sexual orientation, suicide, tobacco, and violence.\n\n"
