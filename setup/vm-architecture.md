# VM Architecture – Cybersecurity Home Lab

This document outlines the virtual machines deployed inside Proxmox for my home lab environment. Each VM serves a specific purpose — from offensive testing to defensive detection and vulnerable service hosting.

---

## 🔴 1. Kali Linux (Attacker Machine)

- **Purpose:** Primary attack machine
- **OS:** Kali Linux (2024.1)
- **Specs:**
  - 8 GB RAM
  - 2 vCPU
  - 80 GB disk
- **Tools:** Nmap, Metasploit, Hydra, Burp Suite, Wireshark, Nikto
- **Network:** Bridged (`vmbr0`)
- **IP:** 192.168.1.30

---

## 🔵 2. Windows 10 (Blue Team / Detection)

- **Purpose:** Logging and defensive analysis
- **OS:** Windows 10 
- **Specs:**
  - 8 GB RAM
  - 2 vCPU
  - 32 GB disk
- **Tools:** Sysmon, Event Viewer, PowerShell logging, firewall rules
- **Network:** Bridged (`vmbr0`)
- **IP:** 192.168.1.109

---

## ⚙️ 3. Ubuntu Server (Web Services & DVWA)

- **Purpose:** Host vulnerable web apps (DVWA, PHPMyAdmin)
- **OS:** Ubuntu Server 22.04
- **Specs:**
  - 4 GB RAM
  - 2 vCPU
  - 32 GB disk
- **Apps:** Apache2, MySQL, PHP, DVWA
- **Network:** Bridged (`vmbr0`)
- **IP:** 192.168.1.188

---

## 🎯 4. Metasploitable2 (Vulnerable Target)

- **Purpose:** Intentionally vulnerable Linux system
- **OS:** Ubuntu 8.04 (Metasploitable2)
- **Specs:**
  - 2 GB RAM
  - 1 vCPU
  - 32 GB disk
- **Vulnerabilities:** FTP, Telnet, Samba, RMI, vulnerable web apps
- **Network:** Bridged (`vmbr0`)
- **IP:** 192.168.1.154

---

## 🌐 Network Overview

All VMs share the same Proxmox virtual bridge: `vmbr0`, simulating a LAN.

| Machine         | IP Address       | Role            |
|------------------|-------------------|------------------|
| Kali Linux       | 192.168.1.30      | Attacker         |
| Metasploitable2  | 192.168.1.154     | Vulnerable target|
| Windows 10       | 192.168.1.109     | Blue team        |
| Ubuntu Server    | 192.168.1.188     | DVWA host        |

---

## 🧠 Notes

- VMs are powered on/off based on lab scenarios
- Kali, Windows, and Ubuntu were installed manually via ISO files  
- Metasploitable2 was imported as a pre-built VM image (converted from VMDK to qcow2 for Proxmox, and then manually changing the configuration files)