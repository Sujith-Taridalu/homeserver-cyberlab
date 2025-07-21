
# Windows Privilege Escalation Detection with Sysmon & PowerShell

Thisis to explain how I implemented **automated privilege escalation detection** on Windows 10 using **Sysmon** and a **PowerShell script (`sysmon-watch.ps1`)**.  
The setup detects **post-exploit shell spawns (cmd.exe, powershell.exe, whoami.exe)** and processes running from sensitive locations (like `system32`) — a common signature of privilege escalation (PE) events.

---

## Step 1: Install Sysmon

1. Download Sysmon from Microsoft Sysinternals:
   - [Sysmon Download](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
   - Place the files (Sysmon64.exe, etc.) in `C:\Sysmon` or `C:\Downloads\Sysmon`.

2. Install Sysmon with a default configuration:
```powershell
.\Sysmon64.exe -accepteula -i
```

3. Verify Sysmon is logging events:
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" | Select -First 5
```
I saw **Event ID 1** entries for process creation.

---

## Step 2: Create the Detection Script (`sysmon-watch.ps1`)

I wrote a code in PowerShell script to `C:\Scripts\sysmon-watch.ps1`:

![Sysmon Code](../screenshots/PE%20Detction/sysmon-watch.png)

*Figure 1: sysmon-watch.ps1 code*

Run it in an elevated PowerShell session:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
C:\Scripts\sysmon-watch.ps1
```

---

## Why This Detects Privilege Escalation

- **Sysmon (Event ID 1)** logs *all process creations*, including those triggered by exploits or elevated users.
- Privilege escalation techniques (token theft, SUID-like attacks, exploit payloads) typically spawn a **shell or utility as SYSTEM or Administrator** (like `cmd.exe`, `powershell.exe`, `whoami.exe`).
- Our script **filters these high-risk processes** and writes alerts in near real time (checked every 5 seconds).

By default, this setup detects:
- **Post-exploit shells (cmd, PowerShell).**
- **Processes spawned from sensitive paths (`system32`).**
- Can be extended to monitor more suspicious binaries (`net.exe`, `taskmgr.exe`, `regsvr32.exe`).

---

## Final Workflow

1. Attacker triggers privilege escalation.
2. Sysmon logs the new elevated process (Event ID 1).
3. `sysmon-watch.ps1` reads these logs, filters for suspicious commands, and writes alerts to `C:\Logs\sysmon-alerts.log`.
4. Security analyst can review the log or forward it to a SIEM.

---

## Benefits

- **Real-time detection (polling every 5 seconds).**
- **Catches post-exploit activity, not just exploits.**
- **Simple to extend with new detection patterns.**
- **Lightweight (uses Sysmon and native PowerShell).**

---

**File Locations:**
- Script: `C:\Scripts\sysmon-watch.ps1`
- Alert log: `C:\Logs\sysmon-alerts.log`

This forms a lightweight, automated detection mechanism for **privilege escalation on Windows**.