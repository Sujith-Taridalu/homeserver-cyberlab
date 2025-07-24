# 🏗️ VM Architecture – Cybersecurity Home Lab

This document outlines the virtual machines deployed inside Proxmox for my home lab environment. Each VM serves a specific purpose — from offensive testing to defensive detection and vulnerable service hosting.

---

## 🔐 1. Windows Server 2022 (Domain Controller)

- **Purpose:** Domain Controller for Active Directory, DNS, GPOs
- **OS:** Windows Server 2022 (Datacenter Evaluation)
- **Specs:**
  - 4 GB RAM
  - 2 vCPU
  - 60 GB disk
- **Roles Installed:** Active Directory Domain Services (AD DS), DNS Server
- **Domain Name:** win-server.local
- **Network:** Bridged (`vmbr0`)
- **IP:** 192.168.1.251

📌 *This server manages centralized authentication and policy control across the lab.*

---

## 🔴 2. Kali Linux (Attacker Machine)

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

## 🔵 3. Windows 10 (Blue Team / Detection)

- **Purpose:** Logging and defensive analysis
- **OS:** Windows 10 
- **Specs:**
  - 8 GB RAM
  - 2 vCPU
  - 32 GB disk
- **Tools:** Sysmon, Event Viewer, PowerShell logging, firewall rules
- **Network:** Bridged (`vmbr0`)
- **IP:** 192.168.1.109
- **Additional Note:** Joined to the domain `win-server.local`, enabling domain authentication and policy enforcement.

---

## ⚙️ 4. Ubuntu Server (Web Services & DVWA)

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

## 🎯 5. Metasploitable2 (Vulnerable Target)

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

| Machine            | IP Address       | Role                          |
|---------------------|-------------------|-------------------------------|
| Windows Server 2022| 192.168.1.251     | Domain Controller (AD, DNS)   |
| Kali Linux         | 192.168.1.30      | Attacker                      |
| Windows 10         | 192.168.1.109     | Blue team (Domain-joined)     |
| Ubuntu Server      | 192.168.1.188     | DVWA host                     |
| Metasploitable2    | 192.168.1.154     | Vulnerable target             |

---

## 🧠 Notes

- VMs are powered on/off based on lab scenarios.
- Kali, Windows, and Ubuntu were installed manually via ISO files.
- Metasploitable2 was imported as a pre-built VM image (converted from VMDK to qcow2 for Proxmox, and then manually changing the configuration files).
- Windows Server 2022 was installed from ISO, promoted to a Domain Controller, and configured for centralized authentication and DNS.
- Windows 10 was successfully joined to the `win-server.local` domain, enabling GPO testing and domain-level authentication.