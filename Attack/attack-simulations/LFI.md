### Attack Simulation 6: Local File Inclusion (LFI) – Custom Exploitation Demo

In this simulation, we demonstrate Local File Inclusion (LFI) using Damn Vulnerable Web Application (DVWA). This attack targets PHP-based web applications that dynamically include files using unsanitized user input.

**Objective:** Exploit the vulnerable `page` parameter in DVWA’s File Inclusion module by including a file we manually created on the server.

---

LFI occurs when the PHP code includes a file from the filesystem based on input from a GET parameter. For example, the vulnerable code in DVWA likely resembles:

```php
<?php
    include($_GET['page']);
?>
```

If an attacker controls the `page` parameter, they can trick the application into loading arbitrary files from the server.

### Step-by-Step Execution

**1. Create a test file on the server:**

On the DVWA server (Ubuntu), we created a new PHP file in the File Inclusion directory:

```bash
cd /var/www/html/DVWA/vulnerabilities/fi/
echo "<?php echo 'LFI Success - Readable File'; ?>" > testlfi.php
```

This file simply returns a known string if it is successfully included.

> Alternatively, we could also use `nano testlfi.php` to write it manually.

---

**2. Trigger the inclusion via DVWA interface**

In the browser, we accessed the file using the vulnerable `page` parameter:

```
http://localhost/DVWA/vulnerabilities/fi/?page=testlfi.php
```

This resulted in the message:

```
LFI Success - Readable File
```

being rendered on the page. This confirms that the file was included and executed, meaning the input is indeed unsanitized.

---

### Why This Matters

In a real-world attack, the attacker wouldn’t have file system access. But if any file upload mechanism or log injection is available, this LFI vulnerability could be chained with:
- Inclusion of uploaded backdoors
- Reading configuration files (`/etc/passwd`, `.htaccess`, etc.)
- Log file inclusion for RCE via web server logs

By testing with a controlled file, we validate that arbitrary file inclusion is possible — which would form the first stage of a real exploitation chain.

---

**Key Concepts:**
- `include()` in PHP directly executes any file path provided.
- If input isn’t sanitized, attackers can traverse directories or reference malicious files.
- This demo proves the LFI is exploitable and sets the stage for advanced attacks like RCE.

---

**Conclusion:**
Even if remote file inclusion or file traversal is restricted, attackers may still leverage local vectors if they can place or control content on the filesystem. Our demonstration confirms the inclusion logic is vulnerable and usable in a practical exploitation workflow.