# Среда разработки SRB

## 1. Проект

- Название: Сменный справочник
- Английское название: Shift Reference Book
- Имя Flutter-проекта: `srb`
- Платформы: Android и Linux Desktop
- Основная цель: автономное Android-приложение с локальной базой данных.

## 2. Эталонная среда

Сведения зафиксированы 15 октября 2026 года.

| Компонент | Версия или значение |
|---|---|
| ОС | Linux Mint 22.3 |
| Ядро Linux | 7.0.0-38-generic |
| Flutter | 3.47.7 stable |
| Dart | 3.13.5 |
| Flutter Git revision | `abaf9c523780a608bd46686fd5e53740a07077f8` |
| Git | 2.43.0 |
| VS Code | `/usr/bin/code` |
| Android SDK | 36.0.0 по `flutter doctor` |
| Android SDK path | `/home/user/Android/Sdk` |
| Java для Flutter/Android | JBR из Android Studio, OpenJDK 25.0.3 |
| Android Gradle Plugin | 9.1.0 |
| Gradle Wrapper | 9.3.1 |
| Kotlin Gradle Plugin | 2.4.0 |
| Android compileOptions | Java 17 |
| Kotlin JVM target | JVM 17 |
| Android namespace | `com.example.srb` |
| Android applicationId | `com.example.srb` |

## 3. Важные замечания

- Системная Java и Java, выбранная Flutter, могут различаться.
- На эталонном ПК Flutter использует JBR из Android Studio.
- В проекте Android-компиляция настроена на Java 17, даже если Gradle запускается на более новой Java.
- Абсолютные пути к SDK не переносить на другие компьютеры.
- `android/local.properties` является локальным файлом и не должен использоваться как переносимая конфигурация.
- После установки SDK и зависимостей проверять `flutter doctor -v`.
- Не менять одновременно версии Flutter, Java, Gradle, Android Gradle Plugin и Kotlin.
- Сборка APK должна проверяться после каждого существенного изменения среды.

## 4. Проверенная команда сборки

Из корня проекта:

```bash
flutter build apk --debug
```

15 октября 2026 года сборка завершилась успешно.

Путь к результату:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 5. Перенос на другой компьютер

1. Установить совместимые Flutter, Git, Java и Android SDK.
2. Получить исходный код из Git.
3. Проверить среду командой `flutter doctor -v`.
4. Выполнить `flutter pub get`.
5. Запустить проверку окружения проекта.
6. Собрать APK командой `flutter build apk --debug`.

Версии и пути сверять с этим документом. Успешная сборка на другом компьютере подтверждает совместимость, но не гарантирует абсолютную идентичность всех компонентов.
