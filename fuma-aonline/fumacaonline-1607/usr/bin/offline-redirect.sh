#!/bin/sh
# script to check if there is internet connection
# if there isn't, all traffic will be redirected to local server
# fumaça online feature

if ! ip route | grep -q -e default # if there is no route out, then... 
then
#  offline; check if redirect is already there 

   if ! grep -q address=/#/10.7.128.10 /etc/dnsmasq.d/lime-proto-anygw-10-ipv4.conf
   then
      echo "address=/#/10.7.128.10">> /etc/dnsmasq.d/lime-proto-anygw-10-ipv4.conf 
      echo "added line"
      /etc/init.d/dnsmasq restart
   fi
else
#if online, delete that line in case it is there 
   if sed -i '\|address=/#/10.7.128.10|d' /etc/dnsmasq.d/lime-proto-anygw-10-ipv4.conf 
   then 
      /etc/init.d/dnsmasq restart
   fi
   echo "tried to delete line"
fi




