# logwatcher

### Как запустить Flutter Web-приложение в тестовом режиме

1. Убедитесь, что установлен Flutter SDK версии 2.0 или выше (поддержка Web встроена).

2. Проверьте, доступна ли поддержка Web:

   ```bash
   flutter devices
   ```

   В списке устройств должно быть хотя бы одно из:

   * `Chrome`
   * `Edge`
   * `Web Server`

4. Запустите приложение в режиме разработки:

   * В браузере Chrome:

     ```bash
     flutter run -d chrome
     ```

   * Или на web-сервере:

     ```bash
     flutter run -d web-server
     ```

---
