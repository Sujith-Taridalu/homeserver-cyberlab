# Red Team Terminology

- **Passive Reconnaissance:**
The process of gathering information about a target without directly engaging with the systems. This can involve activities like searching public records, WHOIS information, social media, or job listings. It helps attackers build a profile of the target while remaining undetected.

- **Active Reconnaissance:**
Involves directly interacting with the target environment to gather data. Techniques include port scanning, ping sweeps, and banner grabbing. This step is noisier and more likely to be detected.

- **Footprinting:**
A detailed and methodical information-gathering process focused on understanding the organization’s network. It includes identifying IP ranges, domain names, and network blocks. Footprinting is often the precursor to more targeted probing.

- **Scanning:**
A technique used to identify live hosts, open ports, and services running on servers. It helps an attacker understand the potential attack surface and is often automated using tools like Nmap.

- **Enumeration:**
The act of extracting detailed information about a target system, such as user names, group names, shares, and services. Enumeration follows scanning and helps in identifying potential entry points.

- **Exploitation:**
The phase where vulnerabilities discovered during scanning and enumeration are used to gain unauthorized access. This could involve buffer overflow attacks, credential theft, or exploiting misconfigurations.

- **Privilege Escalation:**
Once access is obtained, attackers often attempt to elevate their privileges from a regular user to an administrator or root level. This allows deeper access and control over the system.

- **Persistence:**
Mechanisms used to maintain access to the compromised system over time. Techniques include creating new user accounts, adding backdoors, or modifying startup scripts.

- **Command and Control (C2):**
Establishing a channel for remote communication between the compromised system and the attacker. This enables data exfiltration and remote execution of commands.

- **Lateral Movement:**
The technique of moving through a network after initial compromise to access additional systems or data. It often involves credential harvesting and exploiting trust relationships.

- **Data Exfiltration:**
The unauthorized transfer of data from a compromised system to the attacker’s environment. This could involve sending sensitive data over encrypted channels or hiding it in other traffic.

- **Social Engineering:**
Manipulating individuals into divulging confidential information. Techniques include phishing, pretexting, baiting, and tailgating. Social engineering targets the human element of security.

- **Watering Hole Attack:**
Involves compromising a website commonly visited by the target group, in hopes that members will visit the infected site and be exploited.

- **Tactics, Techniques, and Procedures (TTPs):**
The behavior and methods used by attackers. Understanding TTPs helps defenders anticipate and recognize potential threats.

- **Payload:**
The component of a cyberattack that executes malicious actions on the victim system. Payloads can range from backdoors to ransomware.

- **Beaconing:**
A technique where the malware sends periodic signals back to the attacker's server, helping maintain control or receive instructions.

- **Post-Exploitation:**
Refers to the steps taken after initial access has been gained. This includes data gathering, lateral movement, and setting up persistence mechanisms.

- **OPSEC (Operational Security):**
Practices that protect information and activities from being detected by defenders. Red teamers employ OPSEC to avoid revealing their presence.

- **Kill Chain:**
A model that describes the stages of a cyberattack: Reconnaissance, Weaponization, Delivery, Exploitation, Installation, Command and Control, and Actions on Objectives.

- **Indicators of Compromise (IOCs):**
Artifacts observed on a network or in an operating system that indicate a potential intrusion. Examples include unusual network traffic, file hashes, or registry changes.

- **Pivoting:**
Using a compromised system as a springboard to access other systems on the network. This is crucial during lateral movement.

- **Evasion:**
Techniques used to avoid detection by antivirus, firewalls, or intrusion detection/prevention systems (IDS/IPS). Examples include encoding payloads, using custom malware, or manipulating process injection.

- **Brute Forcing:**
Systematically attempting all possible passwords or keys until the correct one is found. Often used during password attacks.

- **DLL Injection:**
A technique for executing code within the address space of another process by forcing it to load a dynamic-link library (DLL).

- **Rootkit:**
A stealthy type of malware designed to hide its presence and allow continued privileged access.

- **Dropper:**
A type of malware designed to install other malicious payloads on the victim system.

- **Staging:**
A technique of delivering a lightweight initial payload that later downloads a more feature-rich secondary payload.

- **Callback:**
The action of a compromised system reaching out to the attacker's server, usually as part of a C2 channel.
