# sysmon-watch.ps1
$LogPath = "C:\Logs\sysmon-alerts.log"

# Ensure the log file exists
if (!(Test-Path $LogPath)) {
    New-Item -ItemType File -Path $LogPath -Force
}

Write-Host "Monitoring Sysmon (Event ID 1: Process Creation) for Privilege Escalation..."

# Filter for Event ID 1 (Process Creation) in Sysmon log
$Filter = @{
    LogName = "Microsoft-Windows-Sysmon/Operational"
    Id = 1
}

while ($true) {
    $Events = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 20 |
        Where-Object { $_.TimeCreated -gt $LastTime }

    foreach ($Event in $Events) {
        $Time = $Event.TimeCreated
        $Message = $Event | Format-List -Property * | Out-String

        # Only process new events
        if ($Time -gt $LastTime -and $Message -match "cmd.exe|powershell.exe|whoami.exe|system32") {
            Add-Content $LogPath "[${Time}] [Alert] Potential Privilege Escalation Detected:`n$Message"
            Write-Host "Alert logged at $Time"
        }

        # Update last processed time
        if ($Time -gt $LastTime) {
            $LastTime = $Time
        }
    }

    Start-Sleep -Seconds 5
}
