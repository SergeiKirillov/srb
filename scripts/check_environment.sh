
#!/usr/bin/env bash

set -u

# Эталонные версии проекта SRB.
EXPECTED_FLUTTER="3.47.7"
EXPECTED_DART="3.13.5"
EXPECTED_FLUTTER_REV="abaf9c523780a608bd46686fd5e53740a07077f8"
EXPECTED_JAVA="25.0.3"

ERRORS=0

check_value() {
    local name="$1"
    local actual="$2"
    local expected="$3"

    if [[ "$actual" == "$expected" ]]; then
        printf 'OK   %-22s %s\n' "$name" "$actual"
    else
        printf 'DIFF %-22s ожидается: %s | найдено: %s\n' \
            "$name" "$expected" "${actual:-не найдено}"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "=== SRB: проверка среды ==="
echo

if ! command -v flutter >/dev/null 2>&1; then
    echo "ERROR: команда flutter не найдена."
    exit 1
fi

FLUTTER_VERSION="$(flutter --version 2>/dev/null |
    sed -n '1s/.*Flutter \([^ ]*\).*/\1/p')"

DART_VERSION="$(flutter --version 2>/dev/null |
    sed -n 's/.*Tools • Dart \([^ ]*\).*/\1/p')"

FLUTTER_PATH="$(command -v flutter)"
FLUTTER_ROOT="$(cd "$(dirname "$FLUTTER_PATH")/.." 2>/dev/null && pwd)"

FLUTTER_REV="$(git -C "$FLUTTER_ROOT" rev-parse HEAD 2>/dev/null || true)"

check_value "Flutter" "$FLUTTER_VERSION" "$EXPECTED_FLUTTER"
check_value "Dart" "$DART_VERSION" "$EXPECTED_DART"
check_value "Flutter revision" "$FLUTTER_REV" "$EXPECTED_FLUTTER_REV"

echo
echo "=== Java, используемая Flutter ==="

JAVA_LINE="$(flutter doctor -v 2>/dev/null |
    grep -m1 'Java version' || true)"

JAVA_VERSION="$(printf '%s\n' "$JAVA_LINE" |
    sed -n 's/.*build \([0-9][0-9.]*\).*/\1/p')"

check_value "Java" "$JAVA_VERSION" "$EXPECTED_JAVA"

echo
echo "=== Основные инструменты ==="

for tool in git code; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf 'OK   %-22s %s\n' "$tool" "$(command -v "$tool")"
    else
        printf 'WARN %-22s не найден\n' "$tool"
    fi
done

echo
echo "=== Android SDK ==="

if [[ -n "${ANDROID_HOME:-}" && -d "$ANDROID_HOME" ]]; then
    printf 'OK   Android SDK           %s\n' "$ANDROID_HOME"
else
    echo "WARN Android SDK: ANDROID_HOME не задан или каталог отсутствует."
fi

echo
echo "=== Итог ==="

if [[ "$ERRORS" -eq 0 ]]; then
    echo "Все проверяемые версии совпадают с эталоном."
else
    echo "Обнаружено несовпадений: $ERRORS"
    echo "Это не обязательно означает неисправность. Сначала изучи различия."
fi

exit "$ERRORS"
