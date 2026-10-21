# Installation — English

## 1. Check USB
Connect the screen and run `lsusb` and `ls -l /dev/serial/by-id/`. Tested hardware uses USB ID `1a86:5722` and `usb-Turing_UsbMonitor_USB35INCHIPSV2-if00`. The `ttyACM0` number can change.

## 2. Install manager
```bash
git clone https://github.com/K-A-Tz/turing-smart-screen-manager.git
cd turing-smart-screen-manager
chmod +x *.sh
mkdir -p ~/bin
cp *.sh ~/bin/
~/bin/turing-manager.sh
```

## 3. Install upstream project
Use menu **2** to check/clone the upstream project, **1** to check Python, create `~/.venv` and install dependencies, **3** to check permissions and **9** for USB diagnostics. All changes require confirmation. After joining `dialout`, log out and back in.

## 4. Configure COM port
Open `~/turing-smart-screen-python/config.yaml` using option **7**. Within the existing `config:` section, set this line with two spaces indentation:
```yaml
  COM_PORT: "/dev/serial/by-id/usb-Turing_UsbMonitor_USB35INCHIPSV2-if00"
```
Do not add another `config:` section. A `config.yaml.backup` is created before editing.

## 5. Management
**4** start; **5** stop; **6** theme configurator (stop the screen first); **8** themes; **10/11** enable/disable autostart; **12** log. Screen initialization can take 10–20 seconds. Avoid duplicate instances.

## 6. Autostart
`~/bin/start-turing.sh` waits up to 60 seconds for USB. Select **10** and sign in to your graphical desktop again. For manual start run `~/bin/turing-manager.sh`.

[Troubleshooting](TROUBLESHOOTING_EN.md)
