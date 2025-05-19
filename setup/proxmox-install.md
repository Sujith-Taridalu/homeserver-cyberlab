# Proxmox Installation – Sujith's Home Cybersecurity Lab

This document outlines the installation of **Proxmox VE** on my dedicated home server. It serves as the base hypervisor for my virtualized cybersecurity lab, used for red/blue team simulation and hands-on learning.

---

## 💻 Host Machine Specifications

- **Model:** Dell Precision Tower 3620
- **CPU:** 8 x Intel(R) Core(TM) i7-6700 @ 3.40GHz (1 Socket)
- **RAM:** 32 GB DDR4
- **Storage:**
  - 512 GB SSD (OS + VMs)
  - 2 TB HDD (Storage, logs, media)
- **Network:** Ethernet (connected via router)

---

## 📥 ISO & Flashing

1. Downloaded the latest ISO from [Proxmox VE Downloads](https://www.proxmox.com/en/downloads)
   - Filename used: `proxmox-ve_8.x.iso`

2. Used [balenaEtcher](https://www.balena.io/etcher/) on macOS to flash the ISO to a USB drive.

---

## ⚙️ Installation Steps

1. Booted the Dell server via USB
2. Selected **Install Proxmox VE**
3. Chose 512 GB SSD as the primary disk
4. Network:
   - Assigned static IP: `192.168.1.200/24`
   - Gateway: `192.168.1.1`
   - DNS: `8.8.8.8`
5. Hostname: `sujith-homelab`
6. Completed installation and removed the USB
7. Accessed the web interface from my laptop at:  
   [https://192.168.1.200:8006](https://192.168.1.200:8006)

---

## 🔐 Proxmox Admin Details

- Web UI: [https://192.168.1.200:8006](https://192.168.1.200:8006)
- Admin user: `root`
- CLI access via SSH:
  ```bash
  ssh root@192.168.1.200
