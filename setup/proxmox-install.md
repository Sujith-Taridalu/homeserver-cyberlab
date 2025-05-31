# 🏗️ Proxmox VE Installation – Sujith's Home Cybersecurity Lab

This document outlines the installation of **Proxmox Virtual Environment (VE)** on my dedicated home server. Proxmox serves as the base hypervisor for my evolving **cybersecurity lab**, enabling virtualized red/blue team simulations, Active Directory testing, and hands-on security learning.

---

## 💻 Host Machine Specifications

| Component       | Details                                  |
|------------------|------------------------------------------|
| **Model**       | Dell Precision Tower 3620                |
| **CPU**         | 8 x Intel(R) Core(TM) i7-6700 @ 3.40GHz |
| **RAM**         | 32 GB DDR4                               |
| **Storage**     | 512 GB SSD (OS + VMs) <br> 2 TB HDD (Storage, logs, media) |
| **Network**     | Ethernet (via router, static IP)         |

---

## 📥 ISO Download & Flashing

1. **Downloaded ISO** from [Proxmox VE Official Site](https://www.proxmox.com/en/downloads)  
   - Filename: `proxmox-ve_8.x.iso`  
2. **Flashed ISO** to USB using [balenaEtcher](https://www.balena.io/etcher/) (macOS)  
   - Verified integrity of the flashed drive.

---

## ⚙️ Proxmox Installation Steps

1. **Booted the server** from the Proxmox USB.
2. Selected **"Install Proxmox VE"** at boot menu.
3. Chose the **512 GB SSD** as the primary installation disk.
4. Configured **network settings**:
   - Static IP: `192.168.1.200/24`
   - Gateway: `192.168.1.1`
   - DNS Server: `8.8.8.8`
5. Set **Hostname**: `sujith-homelab`
6. Completed installation, removed USB, and rebooted.
7. Accessed **Proxmox Web Interface** from laptop:  
   [https://192.168.1.200:8006](https://192.168.1.200:8006)

---

## 🔐 Proxmox Admin Details

- **Web UI Access**: [https://192.168.1.200:8006](https://192.168.1.200:8006)  
- **Default Admin User**: `root`  
- **Initial CLI Access via SSH**:
    ```bash
    ssh root@192.168.1.200
    ```

---

## 🌐 Network Context

- Proxmox server connects to the **same LAN** as my virtual lab machines via `vmbr0`.  
- This setup enables seamless communication between VMs and external systems for lab purposes.

---

## 🔧 Why Proxmox?

- **Open-source and powerful**: Supports KVM virtualization, LXC containers, and clustering.
- **Web-based management**: Easy-to-use web GUI for managing VMs and resources.
- **Perfect for home labs**: Scales well with available hardware, supports snapshots, backups, and bridged networking.

---

