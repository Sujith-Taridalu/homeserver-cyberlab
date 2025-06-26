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
  - 🔐 **Windows Server 2022** – Domain Controller (Active Directory, DNS, GPOs)

---

## 🧠 Purpose of the Lab

- Explore cybersecurity beyond certification paths
- Simulate end-to-end attack chains and blue team responses
- Host internal services (ad blockers, media servers, logging tools)
- Build deep system and network-level knowledge
- Centralize authentication and authorization with Active Directory
- Experiment with Windows domain security and policy enforcement

---

## 🎯 Skills Practiced

### 🔴 Red Team Activities
- Reconnaissance with `nmap`, `netdiscover`, and `whois`
- Exploitation using `Metasploit`, `Hydra`, and manual techniques
- Web vulnerability testing with `Burp Suite`, `Damn Vulnerable Web Application (DVWA)`, SQL injection, XSS
- 12 fully documented red team scenarios, including RCE, SQLi, MITM, and privilege escalation, executed against in-lab targets
- Simulated end-to-end attack chains with custom and public exploits
- Remote code execution via Metasploit modules and manual buffer overflows

### 🔵 Blue Team Activities
- Packet inspection with `Wireshark`, `tcpdump`
- Event log analysis on Windows (`Sysmon`, `Event Viewer`)
- Linux monitoring via `auditd`, `ufw`, and `fail2ban`
- Simulated detection and response
- Active Directory configuration and management
- Group Policy creation and enforcement
- DNS troubleshooting and domain join processes

---

## 📦 Tools and Technologies

- **Red Team:** Kali Linux, Metasploit, Hydra, Gobuster, SQLmap, Burp Suite
- **Blue Team:** Wireshark, Sysmon, auditd, tcpdump, iptables, Windows Event Viewer
- **Infrastructure:** Proxmox, virtual bridges, static IP networking, Windows Server 2022 (Active Directory)
- **Web Security:** DVWA, Apache, MySQL, PHP

---

## 🧰 Directory Structure

```
/Setup/                # VM configs, IPs, ISO details
/Attack/               # Red team command logs, payloads, recon steps
/Defense/              # Blue team logs, detections, scripts
/Screenshots/          # Proof of work
/Projects/             # Sub-projects like Pi-hole, Jellyfin, pfSense, etc.
```

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
- Advanced Active Directory configuration (multi-DC, hybrid AD with Azure)
- Integrate Linux clients with Active Directory for authentication

---

## 👋 About Me

I'm Sujith, a cybersecurity learner building my home lab from the ground up to explore real-world security challenges.

> I break things, fix them, and document everything.

Let’s connect on [LinkedIn](https://www.linkedin.com/) or [GitHub](https://github.com/).

---
