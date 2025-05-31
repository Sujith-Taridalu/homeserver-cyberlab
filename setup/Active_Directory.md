
# 🏛️ **Active Directory Home Lab (May 2025)**

---

## 📚 **Table of Contents**
1. Introduction
2. Installing Windows Server 2022 (ISO Download and Setup)
3. Initial Configuration and Network Setup
4. Installing Active Directory Domain Services (AD DS)
5. Promoting to Domain Controller (Detailed Walkthrough)
6. Configuring DNS (Key Step for AD Functionality)
7. Creating Organizational Units (OUs) and User Accounts
8. Joining Windows 10 Client to the Domain
9. Applying Group Policies (GPOs)
10. Key Learnings and Concepts
11. Future Plans and Expansions

---

## 🏛 **1. Introduction**
This documentation focuses on building an **Active Directory (AD)** lab environment using **Windows Server 2022**. The aim is to create a functional **domain** with centralized authentication, DNS, and Group Policy management, serving as a platform for both learning and future cybersecurity exercises.

## 🏛 **What is Active Directory?**  
**Active Directory (AD)** is a directory service developed by Microsoft for Windows domain networks. It stores information about **users, computers, groups, and resources**, and provides a central point for **authentication, authorization, and management**.  

🔸 **In simple terms**, Active Directory is like a **giant contact list** and **rulebook** that controls who can access what in a network, and under what conditions.  

🔸 It uses protocols like **LDAP (Lightweight Directory Access Protocol)** and **Kerberos** for secure communication and authentication.  

---

## 🔍 **Why is Setting Up Active Directory Useful?**  
✅ **Centralized Authentication**: Instead of each computer managing its own users, AD allows all systems in the network to trust a **central authority** (the Domain Controller).  
✅ **Easier Management**: You can create **Group Policies (GPOs)** to apply settings to groups of users or machines automatically.  
✅ **Enhanced Security**: Centralized control reduces the risk of inconsistent security settings and unauthorized access.  
✅ **Real-World Skills**: AD is used in nearly every enterprise network. Knowing how to set it up, manage it, and troubleshoot it is essential for system administrators and cybersecurity professionals.  
✅ **Supports Learning**: Building an AD lab lets you experiment with user/group management, policies, network behavior, and red/blue team simulations.  

---

## 🔥 **Key Takeaways**  
- **Active Directory is the backbone of enterprise networks**, providing a scalable and secure way to manage resources.  
- **Setting it up teaches you real-world skills** applicable in IT, cybersecurity, and network administration.  
- Your lab mimics a **professional environment**, giving you hands-on experience and a standout project for your resume.  


---

## 💻 **2. Installing Windows Server 2022 (ISO Download and Setup)**
🔸 **Why Windows Server 2022?**  
Windows Server provides the environment to run **Active Directory Domain Services (AD DS)**, which forms the backbone of centralized user and machine management.

🔸 **What I Did:**  
- Downloaded **Windows Server 2022 ISO** from Microsoft's official site.
- Created a VM (or used physical hardware).
- Booted from the ISO and chose **Windows Server 2022 Datacenter Evaluation (Desktop Experience)** for GUI access.
- Set the local Administrator password.

🔸 **What I Learned:**  
- How to set up a clean server installation as a foundation for AD.

---

## 🌐 **3. Initial Configuration and Network Setup**
🔸 **Why This Is Crucial:**  
Active Directory relies on proper network configuration for DNS resolution and client-server communication.

🔸 **What I Did:**  
- Configured a **static IP address** for the server.
- Set the **DNS server address to itself** (the server's IP).
- Changed the computer name to something meaningful (e.g., `AD-DC1`).
- Applied Windows updates.

🔸 **What I Learned:**  
- The importance of network configuration for AD to function smoothly.

---

## 🌐 **4. Installing Active Directory Domain Services (AD DS)**
🔸 **Why Install AD DS?**  
AD DS is the heart of Active Directory, managing user authentication, policies, and computer configurations.

🔸 **What I Did:**  
- Opened **Server Manager > Add Roles and Features**.
- Selected **Active Directory Domain Services (AD DS)** and installed it.
- Included **DNS Server** role when prompted.

🔸 **What I Learned:**  
- The significance of each role and feature in supporting AD.

---

## 🏛 **5. Promoting to Domain Controller (Detailed Walkthrough)**
🔸 **Why Promote?**  
Promotion transforms the server into a **Domain Controller (DC)**, centralizing authentication and domain management.

🔸 **What I Did:**  
- Clicked the **yellow notification flag** in Server Manager and chose **Promote this server to a domain controller**.
- Selected **Add a new forest** with the domain `win-server.local`.
- Set the **Directory Services Restore Mode (DSRM) password**.
- Acknowledged the DNS delegation warning and proceeded.
- Rebooted the server post-promotion.

🔸 **What I Learned:**  
- The process of establishing a new AD forest and domain.
- Importance of DSRM password and DNS setup.

---

## 🌐 **6. Configuring DNS (Key Step for AD Functionality)**
🔸 **Why DNS Matters:**  
AD relies heavily on DNS to locate services and domain controllers.

🔸 **What I Did:**  
- Ensured the DNS role was installed.
- Verified that the DNS zone for `win-server.local` was created.
- Configured clients (like Windows 10) to use the server's IP as their DNS server.

🔸 **What I Learned:**  
- The interplay between DNS and AD for seamless authentication.

---

## 🏢 **7. Creating Organizational Units (OUs) and User Accounts**
🔸 **Why Use OUs?**  
OUs provide structure and allow for targeted Group Policy application.

🔸 **What I Did:**  
- Opened **Active Directory Users and Computers (ADUC)**.
- Created OUs: `LabUsers` and `LabComputers`.
- Created a user account (e.g., `John Doe`) inside `LabUsers`.
- Moved the Windows 10 computer object into `LabComputers`.

🔸 **What I Learned:**  
- How to structure AD effectively for policy management and clarity.

---

## 🖥 **8. Joining Windows 10 Client to the Domain**
🔸 **Why Join a Client?**  
To test domain authentication and user policy application.

🔸 **What I Did:**  
- Configured the Windows 10 client to use the Domain Controller's IP as DNS.
- Opened **System > Rename this PC > Join Domain** and entered `win-server.local`.
- Used domain admin credentials to join.
- Restarted the machine and logged in with the domain user (`win-server\jd`).

🔸 **What I Learned:**  
- The mechanics of domain joining and login authentication.

---

## 🎛 **9. Applying Group Policies (GPOs)**
🔸 **Why GPOs?**  
They enforce settings and enhance security at the domain level.

🔸 **What I Did:**  
- Opened **Group Policy Management Console (GPMC)**.
- Created a GPO for `LabUsers` (e.g., enforced desktop wallpaper).
- Applied GPO and ran `gpupdate /force` on Windows 10 client.
- Verified policy application.

🔸 **What I Learned:**  
- How GPOs are structured and how they control user environments.

📸 **Insert Screenshot**: GPO editor and policy verification.

---

## 🧠 **10. Key Learnings and Concepts**
- Active Directory centralizes user and computer management.
- DNS is the backbone of AD communication.
- Organizational structure via OUs simplifies policy application.
- GPOs are powerful tools for domain security and configuration.

---

## 🚀 **11. Future Plans and Expansions**

While this documentation covers the complete setup of a **Windows Server Active Directory domain** with Windows clients, I plan to expand this lab in the future with additional systems and features for a more comprehensive learning experience.

### 🧑‍💻 **Add Linux Systems**
🔸 **Ubuntu and Kali Linux** can be configured to integrate with Active Directory using protocols like **SSSD, Kerberos, Winbind, and LDAP**.  
🔸 **Kali Linux** will be used for **red team penetration testing** against Windows systems, simulating real-world attack scenarios.  
🔸 **Metasploitable2** (or similar vulnerable machines) will serve as **targets** for practicing exploit techniques.

### 📈 **Set Up SIEM and Monitoring**
🔸 Deploy a **SIEM solution** such as **Splunk** to collect and analyze logs from the Domain Controller and clients.  
🔸 Practice creating alerts and monitoring for suspicious activities.

### 🔒 **Advanced Security Hardening**
🔸 Implement advanced **Group Policies (GPOs)** for password complexity, account lockouts, and restricted access.  
🔸 Configure **backup and recovery plans** for Active Directory.  
🔸 Explore **privilege escalation scenarios** and defensive measures.

### 🌐 **Network Segmentation and Isolation**
🔸 Create **segmented virtual networks** within the lab environment to simulate isolated attack and defense environments.

### 📖 **Documentation and Continuous Learning**
🔸 Maintain detailed records of experiments, configurations, and outcomes.  
🔸 Expand this documentation with **screenshots, diagrams, and case studies** for personal reference and professional portfolio.

---

## 📝 **Final Summary**
This documentation provides a complete, step-by-step guide to setting up **Active Directory** in a home lab, from Windows Server ISO installation to a functional domain with users, computers, and policies. Every decision is explained with its purpose and learning outcome, forming a solid foundation for further exploration.

