# 🪄 Smart Event Radar & Flow Monitoring System

Це комплексний мобільний додаток для моніторингу подій у реальному часі, що поєднує в собі архітектуру **B2B**, **IoT-інтеграцію** та **Native Android Plugin** для магічного керування пристроєм.

## 🌟 Ключові фішки (Лабораторна №7)

Найголовніша особливість цієї версії — **"Magical Secret Functionality"**. Замість звичайних кнопок, додаток використовує систему розпізнавання мовлення для взаємодії з апаратним забезпеченням телефону.

  * **Voice-Activated Flashlight:** Використання закляття *"Lumos"* для ввімкнення ліхтарика та *"Nox"* для його вимкнення.
  * **Native Plugin Architecture:** Керування ліхтариком реалізовано через власний плагін на **Kotlin**, що взаємодіє з Android `CameraManager` через `MethodChannel`.
  * **Secret Trigger:** Активація голосового режиму через довге натискання (Long Press) на іконку профілю в `AppBar`.

-----

## 🏗 Технічний стек

### **Frontend (Mobile)**

  * **Framework:** Flutter (Dart)
  * **State Management:** BLoC / Cubit (для розкладу та користувачів) + Provider (для MQTT).
  * **Navigation:** Named Routes.
  * **UI/UX:** Material 3, Custom Glassmorphism Dashboards.

### **Backend & IoT**

  * **Protocol:** MQTT (брокер `broker.emqx.io`).
  * **Real-time Data:** Відстеження кількості людей, температури та якості повітря в залі.
  * **REST API:** Інтеграція з власним сервером для керування розкладом подій.

### **Native Layer (Android)**

  * **Language:** Kotlin (Java 21 support).
  * **Hardware Control:** Власний плагін `my_flashlight` для прямого доступу до апаратних ресурсів Android.

-----

## 🛠 Як це працює (Магія в коді)

Додаток використовує патерн **MethodChannel** для зв'язку між Dart та Native Kotlin:

```dart
// Виклик у Flutter
await MyFlashlight.toggleLight();
```

```kotlin
// Обробка в Android (Kotlin)
cameraManager.setTorchMode(cameraId, isFlashOn)
```

Для голосового керування інтегровано бібліотеку `speech_to_text`, яка розпізнає ключові слова та тригерить відповідні методи плагіна.

-----

## 📱 Встановлення та запуск

1.  **Клонуйте репозиторій:**
    ```bash
    git clone https://github.com/veronikakorcagin/lab-7.git
    ```
2.  **Підключіть плагін ліхтарика:**
    Переконайтеся, що репозиторій плагіна доступний або вказаний вірний шлях у `pubspec.yaml`.
3.  **Дозволи:**
    Перевірте наявність `RECORD_AUDIO` у `AndroidManifest.xml`.
4.  **Запуск:**
    ```bash
    flutter pub get
    flutter run
    ```


