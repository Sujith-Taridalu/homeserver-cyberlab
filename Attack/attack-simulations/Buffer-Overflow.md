## 🧠 Attack Simulation 11: Buffer Overflow (Local Binary Exploitation)

This simulation demonstrates a **simple buffer overflow attack** on a custom C binary that I compiled myself. While not a real-world service, this simulation was designed to show how insecure memory handling can lead to **memory corruption**, and is often the starting point for advanced exploits like **Return-Oriented Programming (ROP)** or shellcode injection.

---

### 🧠 What is a Buffer Overflow?

A **buffer overflow** occurs when a program writes more data to a buffer (a fixed-size block of memory) than it can hold. If unchecked, this can **overwrite adjacent memory**, including return addresses, function pointers, or variables — allowing an attacker to manipulate program execution.

In real-world scenarios, buffer overflows can lead to:
- Code execution (via shellcode or ROP)
- Privilege escalation
- Denial of service

---

### 🧪 Goal of this Simulation

To simulate a buffer overflow by:
- Writing a vulnerable C program
- Compiling it with protections disabled
- Supplying an overly long input
- Observing a **segmentation fault (crash)**
- Confirming **register and memory corruption**

---

### 💻 Environment

- **OS**: Kali Linux
- **Tools**:
  - `gcc`: GNU Compiler Collection
  - `gdb`: GNU Debugger
  - `python3`: Used to generate payload

---

### 📄 Step 1: Writing a Vulnerable C Program

Created a file called `vuln.c`:

```c
#include <stdio.h>
#include <string.h>

void vulnerable_function(char *input) {
    char buffer[64];
    strcpy(buffer, input);  // No bounds checking!
    printf("You Entered %s\n", buffer);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input>\n", argv[0]);
        return 1;
    }
    vulnerable_function(argv[1]);
    return 0;
}
```

⚠️ The `strcpy()` function does **not** check for input size — classic overflow.

---

### 🛠️ Step 2: Compile with Protections Disabled

```bash
gcc -fno-stack-protector -z execstack vuln.c -o vuln
```

Explanation:
- `-fno-stack-protector`: Disables canary-based stack protection
- `-z execstack`: Makes the stack executable (needed for advanced shellcode attacks)
- `-o vuln`: Output binary

---

### ✅ Step 3: Run and Observe Behavior

Basic test:

```bash
./vuln hello
```

Output:
```
You Entered hello
```

Now trigger the crash:

```bash
./vuln $(python3 -c 'print("A"*100)')
```

Output:
```
You Entered AAAAAAAAAA....[100 A's]
Segmentation fault (core dumped)
```

💥 This proves the program **crashed** due to memory overflow.

---

### 🔍 Step 4: Analyze the Crash with GDB

Start debugger:

```bash
gdb ./vuln
```

Set argument and run:

```gdb
(gdb) set args $(python3 -c 'print("A"*100)')
(gdb) run
```

📌 The program crashed with:
```
Program received signal SIGSEGV, Segmentation fault.
```

Check the registers:

```gdb
(gdb) info registers
```

![Proof of work](../../screenshots/attack-simulation-11/Buffer%20overflow%20vulnerability.png)

*Figure 1: Buffer Overflow vulnerability*

You’ll see:
- `rip` (instruction pointer) points into the middle of `vulnerable_function`
- `rdi`, `rbp`, or `rsp` may contain repeated `0x41414141` (hex for `AAAA`)
- Memory and control flow **were overwritten** with input

✅ This is a successful buffer overflow and memory corruption demo.

---

### 📌 Why Is This Important?

Even though this attack didn't lead to full shell access, it:

- **Proves the vulnerability exists**
- **Demonstrates the memory can be corrupted**
- Is the **first step in real-world binary exploitation**
- Mirrors **classic CVEs** in older Linux/Windows systems

---

### 🔐 Real-World Implications

If this program ran as:
- A **privileged user**
- A **network service**
- A **backend to a public web form**

...an attacker could go further:
- Inject shellcode
- Hijack execution
- Escalate privileges

---

### ✅ Summary Table

| Step | Action | Tool/Command | Result |
|------|--------|--------------|--------|
| 1 | Write C code | `nano vuln.c` | Unchecked `strcpy()` |
| 2 | Compile w/o protection | `gcc -fno-stack-protector ...` | Creates vulnerable binary |
| 3 | Fuzz input | `./vuln $(python3 -c 'print("A"*100')` | Crashes with segmentation fault |
| 4 | Debug | `gdb vuln`, `info registers` | Confirmed control of memory |

---

### Final Thoughts

This was a successful demonstration of:
- Manual vulnerability discovery
- Simple memory corruption
- Using developer tools (GCC, GDB, Python) to understand low-level bugs

While not a remote exploit, this shows the fundamentals behind many **CVE-level attacks** and provides strong credibility in my red teaming or exploit development journey.

---
