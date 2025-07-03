# Setting Up Metasploitable2 VM on Home Server

This guide describes the steps I took to set up Metasploitable2 on my home server.

## Steps

1. **Download and Unzip Metasploitable2**  
   - I downloaded the Metasploitable2 ZIP file from the official source.  
   - I unzipped the contents on my host machine.

2. **Prepare Storage Directory on the Server**  
   - I connected to my server using SSH (for those unfamiliar with this):  
     ```bash
     ssh root@192.168.1.200
     ```
   - Then, on the server, I navigated to `/var/lib/vz/images` and created a directory for the VM with ID `103`:  
     ```bash
     mkdir /var/lib/vz/images/103
     ```

3. **Transfer the Disk Image**  
   - I used `scp` to transfer the `.qcow2` disk image from my host machine to the new directory on the server:  
     ```bash
     scp /Desktop/metasploitable2.qcow2 root@192.168.1.200:/var/lib/vz/images/103/
     ```

4. **Create a Blank VM**  
   - On the server, I created a new empty VM with ID `103` and configured it with the following specifications:
     - **Memory**: 2 GB RAM
     - **CPU**: 1 vCPU
     - **Disk**: 32 GB (no pre-allocated disk)
   - (This can be done through the Proxmox interface or using the `qm create` command.)

5. **Configure the VM Disk**  
   - I navigated to `/etc/pve/qemu-server` where VM configuration files are stored.  
   - I edited the `103.conf` file to assign the `.qcow2` image to the VM.
     ```ini
     ide0: file=local:103/metasploitable2.qcow2,size=32G
     ```

6. **Verify and Start the VM**  
   - Once the configuration was complete, I started the VM via the Proxmox interface or using:
     ```bash
     qm start 103
     ```

7. **Success!**  
   - The Metasploitable2 VM was up and running.