# Решение проблем

- `No such file /dev/ttyACM0`: проверьте `ls -l /dev/serial/by-id/`, используйте постоянный путь в `config.yaml`.
- `Errno 13 Permission denied`: проверьте `id -nG`, добавьте пользователя в `dialout` через пункт 3 и перезайдите.
- Ошибка YAML: проверьте отступы; резервная копия — `config.yaml.backup`.
- USB отсутствует: `lsusb -d 1a86:5722`, `sudo dmesg | tail -30`.
- Две копии: `pgrep -af main.py`; остановите старую.
- Скрипт не запускается: `chmod +x ~/bin/*.sh`.
- Предупреждение `DISPLAY_SIZE` для проверенной темы не мешало работе.
