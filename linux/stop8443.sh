#!/bin/bash

PORT=8443

# Find PID listening on the port
PID=$(sudo lsof -t -i:$PORT)

if [ -z "$PID" ]; then
    echo "No process is listening on port $PORT"
    exit 0
fi

echo "Process listening on port $PORT has PID: $PID"

# Kill the process
sudo kill "$PID"

echo "Sent SIGTERM to process $PID"

# Optional: verify if process is still running
sleep 1

if sudo lsof -i:$PORT >/dev/null 2>&1; then
    echo "Process still running, force killing..."
    sudo kill -9 "$PID"
    echo "Process force killed."
else
    echo "Process stopped successfully."
fi