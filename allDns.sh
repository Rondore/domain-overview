#!/bin/bash

ulimit -t 30
domain=$(echo "$1" | sed "s/^[a-zA-Z]*:\/\///" | sed "s/\/$//");
padding=$(echo "$domain" | tr "[\.A-Za-z0-9]" "\*");

echo "";
echo "************************$padding";
echo "******* DNS FOR $domain *******";
echo "************************$padding";

echo "";
echo "**************************";
echo "*****   GOOGLE DNS   *****";
echo "**************************";
echo "";

./dns.sh $domain;

echo "";
echo "**************************";
echo "*****  INSTANT DNS   *****";
echo "**************************";
echo "";

./instantDns.sh $domain;

echo "";
echo "**************************";
echo "*****  REGISTRATION  *****";
echo "**************************";
echo "";

./registration.sh $domain;

echo "";
echo "**************************";
echo "*****      MAIL      *****";
echo "**************************";
echo "";

./mail.sh $domain;

echo "";
echo "**************************";
echo "*****  PROPAGATION   *****";
echo "**************************";
echo "";

./prop.sh $domain;

echo "";
