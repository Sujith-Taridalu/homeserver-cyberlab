## 🧨 Attack Simulation 9: Linux Privilege Escalation via Sudo Misconfiguration
> 💡 **Skill Demonstrated:** Post-exploitation, privilege escalation, sudo enumeration, root compromise

In this simulation, I performed **local privilege escalation** on a compromised Linux system (Metasploitable2). The purpose was to demonstrate how attackers, after gaining access to a **low-privileged user**, can elevate themselves to **root** — the most powerful user on a Linux machine — due to misconfigured sudo privileges.

---

### 🧠 What is Privilege Escalation?

**Privilege escalation** refers to the act of **gaining higher permissions** on a system than originally granted. It usually occurs after an attacker gains a foothold on the system (e.g., a normal user or guest account) and wants to escalate to `root` (administrator).

There are two types:

- **Horizontal escalation**: Accessing other user accounts at the same privilege level.
- **Vertical escalation**: Gaining higher-level permissions — e.g., from user → root (administrator).

In this attack, we focused on **vertical privilege escalation.**

---

### 💻 Environment

- **Attacker:** Kali Linux (`192.168.1.30`)
- **Victim:** Metasploitable2 (`192.168.1.155`)
- Precondition: I already had **valid SSH credentials** (`msfadmin:msfadmin`) — which could have been obtained via brute-force or phishing in a real-world scenario.

---

### 📡 Step 1: SSH into the Target

```bash
ssh msfadmin@192.168.1.155
```

🔍 **Explanation:**
- `ssh`: Secure shell, allows remote login
- `msfadmin`: Valid username on the victim
- `192.168.1.155`: IP address of the Metasploitable2 machine

✅ Login was successful, placing me in a low-privileged shell.

---

### 🔎 Step 2: Check Who I Am

```bash
whoami
```

Returns:
```
msfadmin
```

🧠 This confirms I am logged in as the unprivileged user `msfadmin`.

---

### 🔍 Step 3: Check User Permissions and Groups

```bash
id
```

Returns:
```
uid=1000(msfadmin) gid=1000(msfadmin) groups=4(adm),20(dialout), ...
```

🧠 `id` shows:
- My user ID (uid) and group ID (gid)
- I'm part of several groups (`adm`, `lpadmin`, etc.), which might offer some extra permissions
- Still, not `root`

---

### 🔍 Step 4: Check Sudo Permissions (Explained in Depth)

To understand whether the current user (`msfadmin`) had elevated access, I ran the following command:

```bash
sudo -l
```

The `sudo -l` command **lists all commands** the current user is allowed to run **with elevated privileges** using `sudo`.

- If the user has no sudo rights, it will say so.
- If the user has limited rights, it will list only those specific commands.
- If the user has **full sudo access**, it will show a powerful and potentially dangerous configuration like:

```
User msfadmin may run the following commands on this host:
    (ALL) ALL
```

---

#### 🔍 What Does `(ALL) ALL` Mean?

This line has a very specific meaning in **sudoers syntax** (from `/etc/sudoers`):

```
(user)  host = (run-as user)  command
```

So:

```
(ALL) ALL
```

Breaks down as:

| Part      | Meaning                                                                 |
|-----------|-------------------------------------------------------------------------|
| `(ALL)`   | The user can **run commands as ANY other user** (usually root)          |
| `ALL`     | The user can **run ANY command** on the system                          |

✅ In simpler terms: this means the user can run **anything, as anyone, with no restrictions**.

This is effectively **root access** — and it **bypasses all permission checks** on the system.

---

#### 🚨 Why This Is Dangerous

Granting `(ALL) ALL` to a regular user is an **extremely insecure configuration** unless very carefully monitored or intended for admin use.

- An attacker can run `sudo su` to spawn a root shell
- They can edit system files, delete logs, disable security software
- They can install malware or create **persistence mechanisms** like cron jobs or new root accounts
- They can dump passwords, SSH keys, tokens, etc.

It's functionally the same as giving that user the **root password** — but possibly without audit trails if logging is weak.

---

#### 🛡️ Real-World Best Practices

- Avoid giving `(ALL) ALL` to regular users
- Use `sudo` **only for necessary commands**, like:
  ```
  msfadmin ALL=(ALL) NOPASSWD: /usr/bin/apt update
  ```
- Use `sudo` **logging tools** (e.g., `auditd`) to monitor elevated command usage
- Use **multi-factor authentication (MFA)** on sudo-capable accounts
- Regularly audit `/etc/sudoers` or use tools like **`sudo -ll`** or **`sudoers-linter`**

---

### ✅ Final Interpretation

The presence of `(ALL) ALL` meant that although I started as an unprivileged user (`msfadmin`), I had the ability to **elevate to root at any time**, with:

```bash
sudo su
```

This is a textbook case of a **vertical privilege escalation** due to poor sudoer configuration.

---

### ⚡ Step 5: Privilege Escalation to Root

Once I confirmed that the user `msfadmin` had unrestricted `sudo` access (`(ALL) ALL`), I escalated privileges using:

```bash
sudo su
```

---

#### 🧠 What Does `sudo su` Mean?

Let’s break it down:

- `sudo` = Run a command **as another user** (default: `root`)
- `su` = "Switch User" — typically used to switch to the `root` account

So, `sudo su` literally means:
> "Run the `su` command as root"  
Which results in:  
> "Switch to the root user as root" ✅

Since `msfadmin` was allowed to run any command (`(ALL) ALL`), this command **worked without any restrictions**.

---

### 🔍 Verifying Root Access

After running `sudo su`, I validated root access using the following commands:

```bash
whoami
```

Output:
```
root
```

```bash
id
```

Output:
```
uid=0(root) gid=0(root) groups=0(root)
```

---

#### 🔐 What Does `uid=0(root)` Mean?

In Linux:

- `uid=0` is the **unique user ID of the root user**
- `gid=0` is the **group ID of the root group**
- Being in `groups=0(root)` means the user has **full access to all resources** on the system

✅ This confirms I now had a **fully privileged root shell**.

---

### 🧠 What Is Privilege Escalation?

**Privilege Escalation** is the process by which a low-privilege user gains **higher privileges**, usually up to **root** or **administrator** level.

There are two types:

| Type                     | Description                                      |
|--------------------------|--------------------------------------------------|
| **Vertical Escalation**  | Moving from a lower privilege to higher (e.g., user → root) |
| **Horizontal Escalation**| Gaining access to other users with the same level |

In this simulation, I performed **vertical privilege escalation** using an insecure sudo policy.

---

### 🛠️ What Could I Do Now as Root?

Once root, an attacker (or red teamer) can:

- Create persistent access (`cron`, startup scripts, `rc.local`)
- Install backdoors or reverse shells
- Dump credentials (SSH keys, `/etc/shadow`)
- Disable system defenses (firewall, antivirus)
- Exfiltrate sensitive data or destroy logs
- Pivot to other systems in the network

This level of access is **complete system compromise**.

---

### ✅ Summary

| Check | Command       | Result           |
|-------|---------------|------------------|
| Priv escalation | `sudo su`     | Opened root shell |
| Proof of root   | `whoami`       | `root`             |
| Proof of UID    | `id`           | `uid=0(root)`      |

This completes the privilege escalation portion of the simulation.

---

### 📌 Why This Is Dangerous

This is **not a software vulnerability** — this is a **misconfiguration**.

If an attacker ever gets access to a user account like this and `sudo` is unrestricted, they win.

---

### 🔐 Real-World Mitigation

- Never allow unrestricted `sudo` access (`(ALL) ALL`) to standard users.
- Require strong passwords and MFA for privileged accounts.
- Monitor usage of `sudo` via logging tools like auditd.
- Regularly review `/etc/sudoers` entries.

---

### ✅ Summary Table

| Step | Command | Purpose | Result |
|------|---------|---------|--------|
| 1 | `ssh msfadmin@192.168.1.155` | Log into the system | User shell |
| 2 | `whoami` | Confirm identity | `msfadmin` |
| 3 | `id` | Check groups and privileges | Not root |
| 4 | `sudo -l` | Check sudo rights | Full sudo access |
| 5 | `sudo su` | Switch to root | Full system control |

---

### 🧠 Final Thoughts

This simulation represents a **classic vertical privilege escalation** that red teams, pentesters, and malicious actors frequently exploit after an initial compromise.

Gaining a foothold in a system is only the first step — **escalating to root turns a foothold into full control**.

🔴 **Always audit sudo permissions. One misconfigured line can compromise an entire infrastructure.**