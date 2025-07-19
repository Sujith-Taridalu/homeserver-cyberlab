#!/bin/bash

LOGFILE="/var/log/ufw-alerts.log"
touch $LOGFILE
chmod 666 $LOGFILE

echo "Monitoring UFW logs for blocked ICMP traffic..."

tail -Fn0 /var/log/ufw.log | \
while read line; do
    echo "$line" | grep -q "PROTO=ICMP TYPE=8 CODE=0"
    if [ $? = 0 ]; then
        echo "[Alert] Blocked ICMP Ping detected at $(date)" | tee -a $LOGFILE
    fi
done
