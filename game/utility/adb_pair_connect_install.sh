#!/bin/bash

# Set the path to ADB
ADB_PATH="/home/jakub/platform-tools/adb"

# Prompt for device IP
read -p "Enter device IP: " DEVICE_IP

# Prompt for pairing port
read -p "Enter pairing port (default 39519): " PAIRING_PORT
PAIRING_PORT=${PAIRING_PORT:-39519}

# Prompt for connection port
read -p "Enter connection port (default 5555): " CONNECT_PORT
CONNECT_PORT=${CONNECT_PORT:-5555}

# Pair with device
echo "Pairing with device..."
"$ADB_PATH" pair "${DEVICE_IP}:${PAIRING_PORT}"

# Connect to device
echo "Connecting to device..."
"$ADB_PATH" connect "${DEVICE_IP}:${CONNECT_PORT}"

# Install APK
echo "Installing APK..."
"$ADB_PATH" install "../Plantago.apk"

echo "Script completed."
