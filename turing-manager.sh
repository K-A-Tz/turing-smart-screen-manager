#!/usr/bin/env bash
PROJECT="$HOME/turing-smart-screen-python"
PY="$HOME/.venv/bin/python"
DEVICE="/dev/serial/by-id/usb-Turing_UsbMonitor_USB35INCHIPSV2-if00"
START="$HOME/bin/start-turing.sh"
AUTO="$HOME/.config/autostart/turing-screen.desktop"
LOG="$HOME/turing-screen.log"
LANGUAGE=en
case "$LANG" in ru*) LANGUAGE=ru;; esac
msg() { if [ "$LANGUAGE" = ru ]; then echo "$1"; else echo "$2"; fi; }
confirm() { local answer; if [ "$LANGUAGE" = ru ]; then read -r -p "$1 [д/Н]: " answer; else read -r -p "$2 [y/N]: " answer; fi; case "$answer" in y|Y|yes|д|Д|да) return 0;; *) return 1;; esac; }
pause() { read -r -p "Enter..." _; }
running() { pgrep -f "^[^ ]*python main.py$" || true; }
check_project() {
 if [ -f "$PROJECT/main.py" ] && [ -f "$PROJECT/requirements.txt" ]; then msg "Проект найден" "Project found"; return; fi
 if [ -e "$PROJECT" ]; then msg "Папка существует, проверьте содержимое вручную" "Directory exists; inspect it manually"; return; fi
 if confirm "Скачать официальный проект?" "Clone upstream project?"; then
   command -v git >/dev/null || { msg "Установите Git (пункт 1)" "Install Git (option 1)"; return; }
   git clone https://github.com/mathoudebine/turing-smart-screen-python.git "$PROJECT"
 fi
}
check_python() {
 if ! command -v python3 >/dev/null || ! command -v git >/dev/null || ! python3 -m venv --help >/dev/null 2>&1; then
   if confirm "Установить Python, Git и venv через apt?" "Install Python, Git and venv using apt?"; then
     sudo apt update && sudo apt install -y python3 python3-pip python3-venv python3-dev git || return
   else return; fi
 fi
 python3 --version
 if [ ! -x "$PY" ]; then
   if confirm "Создать ~/.venv?" "Create ~/.venv?"; then python3 -m venv "$HOME/.venv" || return; else return; fi
 fi
 "$PY" -m pip check || true
 if [ ! -f "$PROJECT/requirements.txt" ]; then msg "Сначала скачайте проект (пункт 2)" "Clone project first (option 2)"; return; fi
 if confirm "Установить зависимости из requirements.txt?" "Install dependencies from requirements.txt?"; then
   "$PY" -m pip install -r "$PROJECT/requirements.txt"
 fi
}
check_rights() {
 id -nG
 ls -l "$DEVICE" 2>/dev/null || true
 if [ -r "$DEVICE" ] && [ -w "$DEVICE" ]; then msg "Доступ разрешён" "Access granted"; return; fi
 if ! id -nG "$USER" | grep -qw dialout; then
   if confirm "Добавить пользователя в dialout?" "Add user to dialout?"; then
     sudo usermod -aG dialout "$USER" && msg "Выйдите и войдите в систему снова" "Log out and back in"
   fi
 else msg "Проверьте USB и повторно войдите в сеанс" "Check USB and log in again"; fi
}
start_display() {
 if [ ! -f "$PROJECT/main.py" ] || [ ! -x "$PY" ]; then msg "Установка неполная" "Installation incomplete"; return; fi
 if [ -n "$(running)" ]; then msg "Уже запущено" "Already running"; return; fi
 if [ -x "$START" ]; then nohup "$START" > "$LOG" 2>&1 < /dev/null &
 else (cd "$PROJECT" && nohup "$PY" main.py > "$LOG" 2>&1 < /dev/null &) ; fi
 msg "Запуск отправлен" "Launch requested"
}
stop_display() { local p; while read -r p; do [ -n "$p" ] && kill "$p" 2>/dev/null || true; done < <(running); }
configure() { if [ -n "$(running)" ]; then msg "Сначала остановите экран" "Stop display first"; return; fi; (cd "$PROJECT" && "$PY" configure.py); }
edit_config() { [ -f "$PROJECT/config.yaml" ] || return; cp "$PROJECT/config.yaml" "$PROJECT/config.yaml.backup"; nano "$PROJECT/config.yaml"; }
usb() { lsusb -d 1a86:5722 2>/dev/null || true; ls -l /dev/serial/by-id/ 2>/dev/null || true; id -nG; }
enable_auto() {
 [ -x "$START" ] || { msg "Сначала установите start-turing.sh" "Install start-turing.sh first"; return; }
 mkdir -p "$HOME/.config/autostart"
 printf '[Desktop Entry]\nType=Application\nName=Turing Smart Screen\nExec=%s\nTerminal=false\nX-GNOME-Autostart-enabled=true\n' "$START" > "$AUTO"
 msg "Автозапуск включён" "Autostart enabled"
}
while true; do
 echo; echo "=== TURING SMART SCREEN MANAGER ==="
 if [ "$LANGUAGE" = ru ]; then
 printf '%s\n' "1 Python и зависимости" "2 Проверить/скачать проект" "3 Права пользователя" "4 Запустить экран" "5 Остановить экран" "6 Настроить тему" "7 Редактировать config.yaml" "8 Список тем" "9 USB" "10 Включить автозапуск" "11 Отключить автозапуск" "12 Журнал" "L English" "0 Выход"
 else
 printf '%s\n' "1 Python and dependencies" "2 Check/clone project" "3 User permissions" "4 Start display" "5 Stop display" "6 Configure theme" "7 Edit config.yaml" "8 List themes" "9 USB" "10 Enable autostart" "11 Disable autostart" "12 Log" "L Русский" "0 Exit"
 fi
 read -r -p "> " choice || exit 0
 case "$choice" in
 1) check_python;; 2) check_project;; 3) check_rights;; 4) start_display;; 5) stop_display;;
 6) configure;; 7) edit_config;; 8) find "$PROJECT/res/themes" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort;;
 9) usb;; 10) enable_auto;; 11) [ -f "$AUTO" ] && mv "$AUTO" "$AUTO.disabled";;
 12) tail -n 80 "$LOG" 2>/dev/null || true;;
 l|L) if [ "$LANGUAGE" = ru ]; then LANGUAGE=en; else LANGUAGE=ru; fi; continue;;
 0) exit 0;; *) msg "Неизвестный пункт" "Unknown option";;
 esac
 pause
done
