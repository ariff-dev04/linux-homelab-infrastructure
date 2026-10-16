# Standard Operating Procedure (SOP): Server Startup & Shutdown

## 1. Cold Boot & Remote Access
1. Power on physical host and wait 45 seconds for `systemd` and `ssh.service` initialization.
2. Verify Layer 3 ICMP reachability from admin workstation:
   ```powershell
   ping 192.168.1.62
   ```
3. Connect via SSH:
   ```powershell
   ssh <your-username>@192.168.1.62
   ```
4. Audit system load and container states:
   ```bash
   uptime && docker ps
   ```

## 2. Graceful Shutdown Procedure
1. Verify clean working tree in Git:
   ```bash
   cd ~/homelab && git status
   ```
2. Execute graceful halt to flush container databases to disk:
   ```bash
   sudo shutdown -h now
   ```
