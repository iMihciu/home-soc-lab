#!/bin/bash
# Automates Splunk Universal Forwarder configuration
SPLUNK_SERVER="<IP_MASZYNY_A>:9997"

echo "[*] Adding Forward Server..."
sudo /opt/splunkforwarder/bin/splunk add forward-server $SPLUNK_SERVER

echo "[*] Adding Monitor for auth.log..."
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log

echo "[*] Restarting Splunk Forwarder..."
sudo /opt/splunkforwarder/bin/splunk restart

echo "[+] Setup complete!"
