# Home SOC Lab: SSH Brute-Force Detection with Splunk

## Project Overview
This repository documents the setup and configuration of a home Security Operations Center (SOC) lab. The primary objective of this project was to deploy a SIEM environment using **Splunk** to monitor Linux authentication logs (`auth.log`) and create custom, automated alerts for detecting SSH brute-force attacks.

## Architecture & Environment
The lab consists of virtual machines running on VirtualBox within a bridged network configuration:
* **Machine A (SIEM Server):** Ubuntu Server running **Splunk Enterprise**. Acts as the main indexer and search head, receiving logs on port `9997`.
* **Machine B (Target/Victim):** Ubuntu machine running **Splunk Universal Forwarder**. Configured to actively monitor `/var/log/auth.log` and forward events to the SIEM server.
* **Machine C (Attacker):** Terminal used to generate malicious SSH login attempts.

## Technologies Used
* **SIEM:** Splunk Enterprise, Splunk Universal Forwarder
* **OS:** Linux (Ubuntu)
* **Protocols:** SSH, TCP/IP
* **Query Language:** SPL (Splunk Processing Language)

## Configuration & Deployment Steps
### 1. Installation Splunk Enterprise and Splunk Universal Forwarder
Downloaded everything from https://www.splunk.com/ in newest version, then proceeded to install into Machines:
```bash
sudo dpkg -i splunkforwarder-version-linux-amd64.deb
sudo dpkg -i splunk-version-linux-amd64.deb
```
<img width="737" height="198" alt="image" src="https://github.com/user-attachments/assets/952375a3-4448-4209-b729-4b7be71c9ad0" />

### 2. Log Forwarding
Installed and configured the Splunk Universal Forwarder on the target machine to monitor authentication logs:
```bash
sudo /opt/splunkforwarder/bin/splunk add forward-server <SPLUNK_SERVER_IP>:9997
```
<img width="830" height="80" alt="image" src="https://github.com/user-attachments/assets/98507d62-95d7-40f2-9c87-1ef23ac2e495" />

after this there where a lot of text about license etc... .
Accepted all terms and rights, then obligated to create login and password.
Added monitor to logs with authentication, which will be forwarding to splunk:
```bash
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log
```

### 3. SIEM Receiver Setup
Enabled listening on the main Splunk Enterprise server to ingest incoming data:
```bash
sudo /opt/splunk/bin/splunk enable listen 9997
sudo ufw allow 9997/tcp
```
### 4. Attack Simulation
Generated a simulated brute-force attack by attempting multiple SSH logins with incorrect credentials in a short time frame.
<img width="738" height="135" alt="image" src="https://github.com/user-attachments/assets/3d403650-171b-46bf-9765-3065f77c0151" />
## Detection & Alerting
To detect the attack, I developed a custom SPL query to filter failed password attempts:
```bash
index="*" "Failed password"
```
<img width="1213" height="687" alt="image" src="https://github.com/user-attachments/assets/043e3b3c-d9c6-4b8c-a38f-a4fdcc763635" />

Then I saved as Alert, filled form:


<img width="645" height="586" alt="image" src="https://github.com/user-attachments/assets/f9657d93-e19e-4d27-a309-f1e2bb65ed1b" />

* Alert expires after 24 hours, which means he will disappear.
* He will triger after sixth attempt in less than 2 minutes, and he will trigger once for this attempts.
* Trigering is disabled for 5 minutes to not spam alert, about same event.

## Ending effect:

<img width="1217" height="289" alt="image" src="https://github.com/user-attachments/assets/1e643c19-a8fc-495a-a3d9-e3e2f2e793c3" />

## Key Learnings
* Understanding the communication flow between Splunk Forwarder and Indexer.
* Troubleshooting network connectivity and firewall rules in a virtualized environment.
* Writing custom SPL queries for threat hunting.
* Configuring robust, optimized alerting mechanisms to mimic real-world SOC environments.




