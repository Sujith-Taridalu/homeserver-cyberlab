# Splunk ⇄ Active Directory (Windows Server) – Ingestion Setup (UF → Indexer)

This document captures exactly what I did to connect a **Windows Server 2022 AD Domain Controller** to a **Splunk Enterprise** server using the **Splunk Universal Forwarder (UF)**.  
**Result:** Windows event logs (Security, System, Application, Directory Service, DNS Server) are flowing into Splunk.

> ✅ **Scope:** Only the connection between AD and Splunk (install UF, point to indexer, enable WinEventLog inputs, verify).  

---

## Lab Topology (example values)

- **Splunk Enterprise (Indexer/Search Head)**
  - OS: Ubuntu 22.04 LTS
  - Hostname: `splunk-ubuntu`
  - IP: `192.168.1.243`
  - Web: `http://splunk-ubuntu:8000/`
  - Receiving (from UFs): **TCP 9997**

- **AD Domain Controller (Windows Server 2022)**
  - Hostname: `AD-DC1`
  - IP: `192.168.1.251`
  - Role: AD DS, DNS
  - Will run **Splunk Universal Forwarder 10.x**

## 1) Configure Splunk Enterprise to receive data (TCP 9997)

### Option A — Splunk Web
1. Go to **Settings → Forwarding and receiving → Receive data → New receiving port**.
2. **Port:** `9997` → **Save**.

### Option B — Splunk CLI (Ubuntu)

```bash
# open TCP 9997 for forwarders
sudo /opt/splunk/bin/splunk enable listen 9997 -auth <admin_username>:<admin_password>

# confirm it's listening
sudo ss -ltnp | grep 9997
# Expect: LISTEN ... 0.0.0.0:9997 ... users:("splunkd",pid=...,fd=...)
```

## 2) Install Splunk Universal Forwarder on the Domain Controller

1. Download **Splunk Universal Forwarder for Windows (64-bit, v10.x)** from Splunk’s downloads page.
2. Run the installer:
   - Accept license.
   - Run as **Local System** (default is fine for a lab).
   - Choose **On-premises Splunk Enterprise**.
   - When prompted for **Receiving Indexer**, use your Splunk server IP and port **9997**.
   - Set a Splunk **username & password** for the UF (you’ll use this on the UF CLI).

## 3) Point the UF at the Indexer (if needed) & verify

Open **PowerShell as Administrator** on the DC:

```powershell
# (Optional) If you didn’t set the indexer during install, add it now:
& "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" add forward-server 192.168.1.243:9997

# Verify it’s configured and ACTIVE:
& "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" list forward-server
# You will be prompted for the UF credentials you created during UF install.
# Expect to see:
# Active forwards:
#   192.168.1.243:9997
```

Also confirm the Windows service is running:

```powershell
Get-Service SplunkForwarder
# Status should be: Running
```

## 4) Enable Windows Event Log inputs on the UF

We enabled the following channels:

- Security  
- System  
- Application  
- Directory Service (AD DS)  
- DNS Server (DNS role)

Create or edit this file on the DC:

`C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf`

> ⚠️ Important: Make sure the file name is exactly **inputs.conf** (not `inputs.conf.txt`). In Notepad’s **Save as type**, choose **All Files**.

**inputs.conf**

```ini
[WinEventLog://Security]
disabled = 0
index = main

[WinEventLog://System]
disabled = 0
index = main

[WinEventLog://Application]
disabled = 0
index = main

[WinEventLog://Directory Service]
disabled = 0
index = main

[WinEventLog://DNS Server]
disabled = 0
index = main
```

Restart the UF to pick up changes:

```powershell
& "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" restart
```

> I used the built-in **main** index for simplicity. If you prefer a custom index (e.g., `win`), create it in Splunk first and replace `index = main` accordingly.

## 5) Verify data is arriving in Splunk

Open Splunk Web (`http://splunk-ubuntu:8000`), go to **Search & Reporting**, set **Time range** to “Last 15 minutes,” and run these searches:

**A) UF → Indexer connection accepted (health check)**

```spl
index=_internal sourcetype=splunkd component=TcpInputProc "connection accepted" earliest=-60m
```
You should see entries showing your DC’s IP connecting on port 9997.

**B) Network stats by host (is data flowing?)**

```spl
index=_internal source=*metrics.log group=tcpin_connections earliest=-60m
| stats latest(kbps) AS kbps by sourceIp, hostname
```
Expect to see your DC (e.g., `sourceIp=192.168.1.251`, `hostname=AD-DC1`).

**C) Actual Windows Event Logs**

```spl
index=main host=AD-DC1 sourcetype=WinEventLog:* earliest=-15m
```

You should see recent events (e.g., Security `EventCode=4624/4634`, etc.).

## 6) Quick Troubleshooting

- **No events in Splunk?**
  - Check UF service: `Get-Service SplunkForwarder` (should be *Running*).
  - Confirm forward-server:
    ```powershell
    & "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" list forward-server
    ```
    It must show your indexer as **Active**.
  - Confirm Splunk is listening on 9997 (Ubuntu):
    ```bash
    sudo ss -ltnp | grep 9997
    ```
  - Verify the inputs file name is `inputs.conf` (no `.txt`).
  - Ensure your Time range in the Splunk search is wide enough (try **Last 24 hours**).
  - Check Windows Security log actually has entries (use Event Viewer or: `wevtutil qe Security /c:1 /rd:true /f:text`).

- **Firewall**
  - If you run a host firewall, allow **TCP 9997** on Splunk Enterprise and ensure the DC can reach it.

- **Indexing to a custom index**
  - If you changed `index = main` to something else, make sure that index exists in Splunk and your user role can search it.

## 7) One-glance Command Reference

**Splunk Enterprise (Ubuntu)**

```bash
# enable receiving on 9997
sudo /opt/splunk/bin/splunk enable listen 9997 -auth <admin_username>:<admin_password>

# verify listener
sudo ss -ltnp | grep 9997
```

**Windows DC (UF)**

```powershell
# point UF at indexer (if not done in installer)
& "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" add forward-server 192.168.1.243:9997

# verify forward-server status (expects UF credentials)
& "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" list forward-server

# restart UF
& "C:\Program Files\SplunkUniversalForwarderin\splunk.exe" restart

# service state
Get-Service SplunkForwarder
```

**inputs.conf** (place in `C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf`)

```ini
[WinEventLog://Security]
disabled = 0
index = main

[WinEventLog://System]
disabled = 0
index = main

[WinEventLog://Application]
disabled = 0
index = main

[WinEventLog://Directory Service]
disabled = 0
index = main

[WinEventLog://DNS Server]
disabled = 0
index = main
```

**Verification SPL**

```spl
index=_internal sourcetype=splunkd component=TcpInputProc "connection accepted" earliest=-60m
```

```spl
index=_internal source=*metrics.log group=tcpin_connections earliest=-60m
| stats latest(kbps) AS kbps by sourceIp, hostname
```

```spl
index=main host=AD-DC1 sourcetype=WinEventLog:* earliest=-15m
```

## Done