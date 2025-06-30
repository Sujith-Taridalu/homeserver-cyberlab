# 🔐 Linux Privilege Escalation – Writable Script & Cron Job
> ⚠️ Disclaimer: This project is for **educational & documentation purposes**.I have created a vulnerability on VM which allows me to escalate Privileges. Do not use these techniques on systems you do not own or have explicit permission to test.

---

## 👤 Initial Setup – Create a Low-Privilege User

Start by creating a non-privileged user to simulate a real-world scenario where an attacker does not have root access.

```bash
sudo adduser student
```

Switch to the user when needed:

```bash
su - student
```

---

## 🧭 Step 1 – Downloading & Understanding `linPEAS`

[`linPEAS`](https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS) is a powerful script for **privilege escalation enumeration** on Linux systems. It automates checks for common misconfigurations, SUID binaries, writable files, PATH issues, and more.

linPEAS is part of the PEASS-ng (Privilege Escalation Awesome Scripts Suite) project. It's a privilege escalation enumeration script designed specifically for Linux systems.

When you're on a machine with limited privileges (like a CTF or pentest scenario), your goal is often to find misconfigurations or overlooked settings that let you become root. linPEAS automates this process.

📥 Clone the repo or download the standalone script:

```bash
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh
```

---

## 🚀 Step 2 – Running `linPEAS`

After switching to a **low-privileged user**, run the script:

```bash
./linpeas.sh
```

![linPEAS working](../../Screenshots/Privilege-Escalations/linPEAS.png)

*Figure 1: linpeas working*

This will output a comprehensive scan of the system. Look for:

- Writable scripts executed by root
- Scheduled cron jobs
- Misconfigured SUID binaries
- PATH hijack opportunities
- World-writable system files

---

## 🔍 Step 3 – linPEAS Identifies Writable Root Script

In this example, `linPEAS` flagged a **world-writable script** located at:

```
/usr/local/bin/vuln_script.sh
```

![linPEAS working](../../Screenshots/Privilege-Escalations/vuln.png)

*Figure 2: Vulnerability Detected*

This script is executed by root via cron every minute.

---

## ⚠️ General Exploitation Idea

If a **low-privileged user can modify a script that runs as root**, they can insert commands to:

- Add themselves to the `sudoers` file
- Give SUID permissions to `/bin/bash`
- Replace sensitive binaries with reverse shells
- Read/write protected files

---

## 🎯 Final Exploit

Once the cron job executed the modified script, we verified the change:

```bash
ls -l /bin/bash
# -rwsr-sr-x 1 root root ... /bin/bash
```

Now, from the `student` user, we ran:

```bash
/bin/bash -p
whoami
# root
```

![PE to root](../../Screenshots/Privilege-Escalations/Output.png)

*Figure 3: Successful escalation to Root*

---

## ✅ Summary

- `linPEAS` helped identify a **writable root-owned cron script**
- We exploited it by adding a **setuid bit to bash**
- This enabled us to spawn a root shell with `/bin/bash -p`

---

## 📁 Repo Contents

| File | Description |
|------|-------------|
| `linpeas.sh` | Enumeration script |
| `images/` | Screenshots from exploit process |
| `README.md` | This documentation |