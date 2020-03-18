#!/bin/bash
#write snort rules from arrays of IP's and domains


# write snort rules from array of IP's
mapfile -t IP_array < /ip_list.txt
x=1100000
for IP in "${IP_array[@]}"
do
echo "alert ip any any <> $IP any (msg:\"Known Bad IP\"; sid:$x;)" >> /etc/nsm/rules/local.rules
x=$((x+1))
done

# write snort rules from array of domains
mapfile -t domain_array < /domain_list.txt
x=1200000
for domain in "${domain_array[@]}"
do
echo "alert udp any any -> any any (msg:\"Known Bad domain\"; content:\"$domain\"; sid:$x;)" >> /etc/nsm/rules/local.rules
x=$((x+1))
done

#fin
