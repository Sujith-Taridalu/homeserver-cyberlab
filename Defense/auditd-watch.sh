#!/bin/bash
LOGFILE="/var/log/auditd-alerts.log"
touch $LOGFILE
chmod 666 $LOGFILE

echo "Monitoring auditd for privilege escalation"
while true; do
    if /usr/sbin/ausearch -k student_pe | grep -q "/bin/bash"; then
        echo "[Alert] Privilege Escalation detected at $(date)" | tee -a $LOGFILE
        sleep 5
    fi
    sleep 1
done