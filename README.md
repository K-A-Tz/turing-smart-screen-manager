# Turing Smart Screen Manager

**Русский:** [Установка](docs/INSTALL_RU.md) · [Решение проблем](docs/TROUBLESHOOTING_RU.md)

**English:** [Installation](docs/INSTALL_EN.md) · [Troubleshooting](docs/TROUBLESHOOTING_EN.md)

Bilingual Bash manager for [Turing Smart Screen Python](https://github.com/mathoudebine/turing-smart-screen-python) on Linux Mint/Ubuntu. / Двуязычное Bash-меню для Turing Smart Screen в Linux Mint/Ubuntu.

## Quick start / Быстрый запуск

```bash
git clone https://github.com/K-A-Tz/turing-smart-screen-manager.git
cd turing-smart-screen-manager
chmod +x turing-manager.sh start-turing.sh
mkdir -p ~/bin
cp turing-manager.sh start-turing.sh ~/bin/
~/bin/turing-manager.sh
```

Press **L** to switch Русский / English. / Нажми **L** для переключения языка.

Supports Python/dependency checks, cloning upstream, dialout permissions, launch/stop, themes, USB checks and autostart. / Проверка Python, зависимостей, проекта, прав dialout, USB, темы и автозапуск.

Tested USB hardware: **1a86:5722 / USB35INCHIPSV2**. Other screens may need a different USB path. Independent community project, not the upstream driver.
