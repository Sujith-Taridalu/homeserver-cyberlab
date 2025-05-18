# Sujith's Cybersecurity Home Lab

Welcome to my personal cybersecurity home lab — a virtualized environment built on bare-metal hardware using Proxmox VE. This lab is a long-term, evolving platform where I explore offensive and defensive security, simulate real-world attacks, test detection tools, and continuously sharpen my skills.

---

## 🔧 Lab Infrastructure

- **Host Platform:** Proxmox VE (Type 1 Hypervisor) running on Dell T3620
- **Network Topology:** Flat network with virtual bridge (`vmbr0`)
- **Primary Virtual Machines:**
  - 🔴 **Kali Linux** – attack & exploitation
  - 🎯 **Metasploitable2** – intentionally vulnerable target
  - 🔵 **Windows 10** – blue team/logging analysis
  - ⚙️ **Ubuntu Server** – hosts DVWA, web apps, and services

---

## 🧠 Purpose of the Lab

- Explore cybersecurity beyond certification paths
- Simulate end-to-end attack chains and blue team responses
- Host internal services (ad blockers, media servers, logging tools)
- Build deep system and network-level knowledge

---

## 🎯 Skills Practiced

### 🔴 Red Team Activities
- Reconnaissance with `nmap`, `netdiscover`, and `whois`
- Exploitation using `Metasploit`, `Hydra`, and manual techniques
- Web vulnerability testing with `Burp Suite`, `DVWA`, SQL injection, XSS
- Reverse shells, brute force attacks, and privilege escalation

### 🔵 Blue Team Activities
- Packet inspection with `Wireshark`, `tcpdump`
- Event log analysis on Windows (`Sysmon`, `Event Viewer`)
- Linux monitoring via `auditd`, `ufw`, and `fail2ban`
- Simulated detection and response

---

## 📦 Tools and Technologies

- **Red Team:** Kali Linux, Metasploit, Hydra, Gobuster, SQLmap, Burp Suite
- **Blue Team:** Wireshark, Sysmon, auditd, tcpdump, iptables, Windows Event Viewer
- **Infrastructure:** Proxmox, virtual bridges, static IP networking
- **Web Security:** DVWA, Apache, MySQL, PHP

---

## 🧰 Directory Structure (coming soon)

```
/setup/                # VM configs, IPs, ISO details
/attack-notes/         # Red team command logs, payloads, recon steps
/defense-notes/        # Blue team logs, detections, scripts
/screenshots/          # Screenshots of key attacks/detections
/projects/             # Sub-projects like Pi-hole, Jellyfin, pfSense, etc.
```

---

## 📸 Screenshots

_(To be added soon — Metasploit sessions, Wireshark logs, DVWA tests)_

---

## 📚 Current Focus

- Web app attacks and defense (DVWA, OWASP Top 10)
- Network scanning and enumeration techniques
- Local privilege escalation on Linux & Windows
- Long-term system hardening and detection tools

---

## 🔄 Continuous Lab Growth

This lab is continuously evolving. Future upgrades include:
- VLAN simulation and isolation
- Dockerized service deployments
- SIEM tools like Security Onion or Wazuh
- Automated attack simulations

---

## 👋 About Me

I'm Sujith, a cybersecurity learner building my home lab from the ground up to explore real-world security challenges.

> I break things, fix them, and document everything.

Let’s connect on [LinkedIn](https://www.linkedin.com/) or [GitHub](https://github.com/).

---
