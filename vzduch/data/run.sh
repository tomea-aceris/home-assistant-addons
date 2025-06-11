#!/bin/bash
set -e

echo "📡 Reading Airtouch config..."

# Read config values passed in from config.json using Home Assistant env var file
CONFIG_PATH="/data/options.json"

AIRTOUCH_HOST=$(jq -r '.airtouch_host' "$CONFIG_PATH")
AIRTOUCH_PORT=$(jq -r '.airtouch_port' "$CONFIG_PATH")
AIRTOUCH_LOGLEVEL=$(jq -r '.logLevel' "$CONFIG_PATH")

echo "✔️ Host: $AIRTOUCH_HOST"
echo "✔️ Port: $AIRTOUCH_PORT"
echo "✔️ Log Level: $AIRTOUCH_LOGLEVEL"

# Export for the .NET app
export DOTEK_airTouch__localHost=$AIRTOUCH_HOST
export DOTEK_airTouch__localPort=$AIRTOUCH_PORT
export DOTEK_Serilog__MinimumLevel__Default=$AIRTOUCH_LOGLEVEL
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

echo "🚀 Starting VzduchDotek.Net..."
exec ./VzduchDotek.Net
