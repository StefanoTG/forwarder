#!/bin/bash

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Port 26 → 85.9.204.241:23
iptables -t nat -A PREROUTING -p tcp --dport 26 -j DNAT --to-destination 85.9.204.241:23
iptables -t nat -A PREROUTING -p udp --dport 26 -j DNAT --to-destination 85.9.204.241:23

# Port 27 → 85.9.223.204:23
iptables -t nat -A PREROUTING -p tcp --dport 27 -j DNAT --to-destination 85.9.223.204:23
iptables -t nat -A PREROUTING -p udp --dport 27 -j DNAT --to-destination 85.9.223.204:23

# Port 28 → 94.237.121.151:23
iptables -t nat -A PREROUTING -p tcp --dport 28 -j DNAT --to-destination 94.237.121.151:23
iptables -t nat -A PREROUTING -p udp --dport 28 -j DNAT --to-destination 94.237.121.151:23

# Port 29 → 85.9.209.126:23
iptables -t nat -A PREROUTING -p tcp --dport 29 -j DNAT --to-destination 85.9.209.126:23
iptables -t nat -A PREROUTING -p udp --dport 29 -j DNAT --to-destination 85.9.209.126:23

# Allow return traffic
iptables -t nat -A POSTROUTING -j MASQUERADE
