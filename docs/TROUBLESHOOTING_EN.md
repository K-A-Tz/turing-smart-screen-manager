# Troubleshooting

- `No such file /dev/ttyACM0`: check `ls -l /dev/serial/by-id/` and use the stable path in `config.yaml`.
- `Errno 13 Permission denied`: check `id -nG`, add user to `dialout` via option 3, then log out/in.
- YAML error: check indentation; backup is `config.yaml.backup`.
- USB missing: `lsusb -d 1a86:5722`, `sudo dmesg | tail -30`.
- Duplicate processes: `pgrep -af main.py`; stop old instance.
- Script permission denied: `chmod +x ~/bin/*.sh`.
- `DISPLAY_SIZE` warning was non-fatal for the tested theme.
