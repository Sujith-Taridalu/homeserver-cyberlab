# Privilege Escalation Detection on Linux (Auditd + UFW + Automation)

## Overview
This setup detects **privilege escalation (PE) attempts** on a Linux server by:
1. **Monitoring system calls** with `auditd`.
2. **Detecting PE events** (e.g., spawning `/bin/bash` via exploits).
3. **Logging suspicious activity**.
4. **Generating real-time alerts** using an automation script.
5. **Enhancing visibility** with `UFW` (firewall logging).

This solution helps detect attacks like **abusing SUID binaries or `find` exploits** to gain root access.

---

## Components Used
1. **Auditd** – Linux auditing framework for logging system calls (e.g., `execve`).
2. **UFW (Uncomplicated Firewall)** – To monitor and log network traffic.
3. **Custom Watch Script (`auditd-watch.sh`)** – Automates detection by tailing logs and alerting.

---

## Step 1: Install and Enable Auditd & UFW

```bash
sudo apt update && sudo apt install auditd ufw -y
sudo systemctl enable --now auditd
sudo ufw enable
sudo ufw logging on
```
Confirm services:
```bash
sudo service auditd status
sudo ufw status verbose
```

### What This Step Does

1. **Install Auditd and UFW**  
   - `auditd`: The Linux Audit Daemon, which tracks important system calls (like process executions).  
   - `ufw`: The Uncomplicated Firewall, used for monitoring and logging network traffic.

2. **Enable and Start Auditd**  
   - `systemctl enable --now auditd`: Makes sure the audit daemon starts immediately and automatically on every boot.  
   - This ensures all process executions (like privilege escalations) get logged.

3. **Enable UFW with Logging**  
   - `ufw enable`: Turns on the firewall with default policies (deny incoming, allow outgoing).  
   - `ufw logging on`: Enables logging so any blocked or suspicious connections are recorded in `/var/log/ufw.log`.

4. **Verify Services**  
   - `service auditd status`: Confirms the audit daemon is running.  
   - `ufw status verbose`: Confirms the firewall is active and logging.

This prepares the system to **record both process activity (via auditd) and network activity (via UFW)**, which together give us visibility into privilege escalation and potential attacker behavior after gaining root.

---

## Step 2: Add Auditd Rule for Privilege Escalation

We monitor all executions of `/bin/bash` by a specific user (`student` - low priviled user I created) to detect root shells:

```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -F auid=1002 -F key=student_pe
```

breaks down as:
     - `-a always,exit`: Log every matching system call as the process exits.
     - `-F arch=b64`: Target 64-bit system calls (most modern Linux systems).
     - `-S execve`: Specifically track `execve` calls (process executions).
     - `-F auid=1002`: Only monitor actions performed by the user with audit UID `1002` (our low-privilege `student` account).
     - `-F key=student_pe`: Tag these events with the key `student_pe` for easy searching later.

   This ensures we **log every time the `student` user executes a binary**, specifically so we can detect when they spawn a privileged shell like `/bin/bash`.

Verify:
```bash
sudo auditctl -l
```
Expected rule:
```
-a always,exit -F arch=b64 -S execve -F auid=1002 -F key=student_pe
```

By setting this rule, we create a way to **track privilege escalation** — any time the `student` account executes `/bin/bash` (for example, through an SUID exploit like `find`), auditd will generate a log entry tagged with `student_pe`, which we can later detect automatically.

---

## Step 3: Exploit Simulation (Privilege Escalation)

To simulate a privilege escalation (as a tester, not attacker), use a known SUID-based exploit:
```bash
find . -exec /bin/bash -p \; -quit
whoami  # should return root
```

---

## Step 4: Detecting PE Events Manually

Auditd logs can be checked with:
```bash
sudo ausearch -k student_pe | grep "/bin/bash"
```
This shows `execve` system calls where a shell was spawned.

---

## Step 5: Automating Alerts with `auditd-watch.sh`

We created `/usr/local/bin/auditd-watch.sh`:

![.sh script](../screenshots/PE%20Detction/auditd-watch.png)

*Figure 1: auditd-watch.sh*

Make it executable and run in the background:
```bash
sudo chmod +x /usr/local/bin/auditd-watch.sh
nohup /usr/local/bin/auditd-watch.sh &
```
Confirm it’s running:
```bash
ps aux | grep auditd-watch.sh
```

---

## Step 6: Monitoring Alerts

Check real-time alerts:
```bash
tail -f /var/log/auditd-alerts.log
```
On privilege escalation, you’ll see:
```
[Alert] Privilege Escalation detected at Sat Jul 19 04:10:54 PM CDT 2025
```

![PE Detection](../screenshots/PE%20Detction/automated%20result.png)

*Figure 2: Automates the process and the result can be seen in auditd-alerts.log*

---

## Step 7: UFW Log Monitoring (Firewall Alerts)

The **Uncomplicated Firewall (UFW)** is configured to block all **incoming traffic by default** and deny certain protocols like ICMP (ping).  
We use a watcher script (`ufw-watch.sh`) to generate alerts whenever ICMP or other blocked events appear in the UFW logs.

### Check raw firewall logs:
```bash
sudo tail -f /var/log/ufw.log
```
You’ll see entries like:
```
Jul 19 17:12:37 ubuntu kernel: [UFW BLOCK] IN=enp6s18 OUT= MAC=01:00:5e:00:00:01 SRC=192.168.1.188 DST=173.194.208.100 LEN=84 PROTO=ICMP TYPE=8 CODE=0 ID=58200 SEQ=6
```

### Automate alerting with `ufw-watch.sh`
Create the script:
```bash
sudo nano /usr/local/bin/ufw-watch.sh
```

![UFW Script](../screenshots/PE%20Detction/ufw-watch.png)

*Figure 3: Automates the process and the result can be seen in auditd-alerts.log*

Make it executable and run in the background:
```bash
sudo chmod +x /usr/local/bin/ufw-watch.sh
nohup /usr/local/bin/ufw-watch.sh &
```

Verify it’s running:
```bash
ps aux | grep ufw-watch.sh
```

Test by generating a blocked ping (from a restricted user like `student`):
```bash
ping -c 1 google.com
```

Check alerts:
```bash
tail -f /var/log/ufw-alerts.log
```
And I see timestamps for every blocked ping event.

![UFW Alert](../screenshots/PE%20Detction/ufw%20alert.png)

*Figure 4: Automates the process and the result can be seen in ufw-alerts.log*

---

## Final Workflow
1. **Attacker triggers actions:**
   - Privilege escalation (`/bin/bash` as root) OR  
   - Network probe (ICMP ping or other blocked traffic).
2. **auditd** logs privilege escalations (`execve` calls).  
3. **auditd-watch.sh** detects PE events and writes to `/var/log/auditd-alerts.log`.  
4. **UFW** blocks restricted network traffic and logs it to `/var/log/ufw.log`.  
5. **ufw-watch.sh** converts UFW blocks (like ICMP) into readable alerts at `/var/log/ufw-alerts.log`.  
6. I can monitor these logs directly or integrate with a SIEM.

---

## Benefits
- **Dual monitoring:** Tracks both **privilege escalation** and **network-level probes.**
- **Real-time detection** with minimal overhead.
- Uses **native Linux tools** (`auditd`, `ufw`, `grep`, `tail`) without heavy dependencies.
- **Modular design:** Each script (`auditd-watch.sh`, `ufw-watch.sh`) can run independently.