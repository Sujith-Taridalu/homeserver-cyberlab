# 🕵️ Honeypot Setup Guide (Cowrie on Ubuntu)

This guide walks through setting up a low-interaction SSH honeypot using [Cowrie](https://github.com/cowrie/cowrie). The goal is to simulate a vulnerable system and log attacker activity in a controlled, safe environment.

---

## 📦 Prerequisites

- A Linux VM
- Python 3 installed
- Internet access to install dependencies
- Another machine (e.g., Kali Linux) to simulate attacks

---

## ⚙️ Step-by-Step Setup

### 1. Create a dedicated user

```bash
sudo adduser --disabled-password --gecos "" cowrie
```

### 2. Switch to that user

```bash
sudo -u cowrie -H bash
cd ~
```

### 3. Clone Cowrie and enter the directory

```bash
git clone https://github.com/cowrie/cowrie.git
cd cowrie
```

### 4. Create a virtual environment and install dependencies

```bash
python3 -m venv cowrie-env
source cowrie-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### 5. Configure Cowrie

```bash
cp etc/cowrie.cfg.dist etc/cowrie.cfg
nano etc/cowrie.cfg
```

Look for this line and make sure it says:
```ini
listen_endpoints = tcp:2222:interface=0.0.0.0
```

> **Why port 2222?**  
> Port 22 is used by *real* SSH servers. We use 2222 to avoid conflicts and keep Cowrie isolated.  
> ⚠️ Most attackers scan a **wide range of ports**, including 2222, 222, 8022, etc. So using 2222 still attracts opportunistic bots and scans. It’s commonly used in honeypots — and logs still flood in even on this port.

Save and exit.

---

### 6. Start Cowrie

Make sure you're in the Cowrie folder:
```bash
bin/cowrie start
```

Check if it's running:
```bash
bin/cowrie status
```

![Cowrie bin Start and Status](../Screenshots/Honey%20pot/cowrie%20start%20&%20status.png)

*Figure 1: Cowrie bin Start and Status*

Output:
```
Cowrie is running with PID 6760
```

---

### 7. Connect from another machine

From your Kali or any other box in the same network:

```bash
ssh root@192.168.1.188 -p 2222
```

Try random usernames and passwords — Cowrie logs them all and all commands will be recorded in the log file.

---

## 🔍 Where to Find Logs

Cowrie logs to:
```
/home/cowrie/cowrie/var/log/cowrie/cowrie.json
```

To monitor logs in real time:
```bash
tail -f /home/cowrie/cowrie/var/log/cowrie/cowrie.json
```

![Cowrie Logs](../Screenshots/Honey%20pot/log.png)

*Figure 2: Log*

Log events include:
- Login attempts (successful/fake or failed)
- Commands entered in the fake shell
- Session start/end
- Connection IPs, ports, timestamps

---

## 🧼 To Stop Cowrie

```bash
bin/cowrie stop
```

---
