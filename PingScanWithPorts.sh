# simple ping scan
for i in {1..254} ;do (ping 192.168.13.$i -c 1 -w 5  >/dev/null && echo "192.168.13.$i" &) ;done

# port scan
for i in {10..15} ;do (nc -nvz 192.168.13.$i 443) ;done

# dns scan
for i in {10..15} ;do (nc -nvz -u -w 1 192.168.13.$i 53) ;done

# kerberos scan
for i in {10..15} ;do (nc -nvz -u -w 1 192.168.13.$i 88) ;done
