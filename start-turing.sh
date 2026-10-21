#!/usr/bin/env bash
DEVICE="/dev/serial/by-id/usb-Turing_UsbMonitor_USB35INCHIPSV2-if00"
PROJECT="$HOME/turing-smart-screen-python"
for ((i=0;i<30;i++)); do
  [ -r "$DEVICE" ] && [ -w "$DEVICE" ] && break
  sleep 2
done
cd "$PROJECT" || exit 1
exec "$HOME/.venv/bin/python" main.py
