# Сравнение шифрования: Dart Cryptography vs Rust FFI

Этот проект демонстрирует две различные реализации шифрования данных в Flutter приложении:

1. **Dart Cryptography** - использование библиотеки `cryptography`
2. **Rust FFI** - использование Rust через FFI с алгоритмом AES-256-GCM

## Архитектура

### Интерфейс SecretNoteRepository

```dart
abstract class SecretNoteRepository {
  Future<void> save(String note);
  Future<String> get(String id);
}
```

### Реализация SecretNoteDart

Использует библиотеку `cryptography` для шифрования AES-GCM:

```dart
class SecretNoteDart implements SecretNoteRepository {
  late final AesGcm _cipher;
  late final SecretKey _masterKey;
  
  // Инициализация
  Future<void> _initializeCipher() async {
    _cipher = AesGcm.with256bits();
    _masterKey = await _cipher.newSecretKey();
  }
  
  // Шифрование
  Future<String> _encryptText(String text) async {
    final data = Uint8List.fromList(text.codeUnits);
    final nonce = _cipher.newNonce();
    
    final secretBox = await _cipher.encrypt(
      data,
      secretKey: _masterKey,
      nonce: nonce,
    );
    
    // Объединяем nonce + зашифрованные данные
    final combined = Uint8List(nonce.length + secretBox.cipherText.length);
    combined.setRange(0, nonce.length, nonce);
    combined.setRange(nonce.length, combined.length, secretBox.cipherText);
    
    return base64Encode(combined);
  }
}
```

### Реализация SecretNoteRust

Использует Rust FFI с алгоритмом AES-256-GCM:

```rust
#[no_mangle]
pub extern "C" fn encrypt(
    key_ptr: *const u8,
    key_len: usize,
    data_ptr: *const u8,
    data_len: usize,
    out_ptr: *mut *mut u8,
    out_len: *mut usize,
) -> i32 {
    let aead = Aes256Gcm::new(Key::<Aes256Gcm>::from_slice(key_slice));
    let mut nonce = [0u8; 12];
    getrandom(&mut nonce).expect("Failed to generate nonce");
    
    match aead.encrypt(&Nonce::from_slice(&nonce), data) {
        Ok(mut ct) => {
            let mut result = nonce.to_vec();
            result.append(&mut ct);
            // Возвращаем [nonce (12 байт) + зашифрованные данные]
        }
    }
}
```

## Сравнение подходов

### Dart Cryptography
**Преимущества:**
- Простота использования
- Автоматическое управление памятью
- Хорошая документация
- Кроссплатформенность

**Недостатки:**
- Может быть медленнее нативных решений
- Зависимость от сторонней библиотеки

### Rust FFI
**Преимущества:**
- Максимальная производительность
- Безопасность памяти (zero-cost abstractions)
- Полный контроль над криптографическими примитивами
- Возможность использования проверенных библиотек (aes-gcm)

**Недостатки:**
- Сложность реализации
- Необходимость ручного управления памятью
- Требует компиляции нативных библиотек

## Использование

### Запуск приложения

```bash
cd flutter/02.flutter_crypto
flutter pub get
flutter run
```

### Пример кода

```dart
// Dart Cryptography
final dartCrypto = SecretNoteDart();
await dartCrypto.save("Секретная заметка");
final decrypted = await dartCrypto.get("note_id");

// Rust FFI
final rustCrypto = SecretNoteRust();
await rustCrypto.save("Секретная заметка");
final decrypted = await rustCrypto.get("note_id");
```

## Производительность

Приложение включает измерение времени выполнения операций шифрования и расшифровки:

```dart
final stopwatch = Stopwatch()..start();
final encryptedData = await _encryptText(text);
stopwatch.stop();
log('encrypt time: ${stopwatch.elapsedMilliseconds} ms');
```

## Безопасность

Обе реализации используют:
- AES-256-GCM алгоритм шифрования
- Случайные nonce для каждого шифрования
- Безопасное хранение ключей
- Аутентифицированное шифрование

## Структура проекта

```
flutter/02.flutter_crypto/
├── lib/
│   ├── secret_note_repository.dart    # Интерфейс
│   ├── secret_note_dart.dart          # Dart реализация
│   ├── secret_note_rust.dart          # Rust FFI реализация
│   ├── lib_bindings.dart              # Автогенерированные FFI биндинги
│   └── main.dart                      # UI для тестирования
├── ffi_rust/
│   ├── src/lib.rs                     # Rust код шифрования
│   ├── Cargo.toml                     # Rust зависимости
│   └── lib.h                          # C заголовочный файл
└── pubspec.yaml                       # Dart зависимости
```

## Зависимости

### Dart
- `cryptography: ^2.7.0` - для Dart реализации
- `shared_preferences: ^2.5.3` - для хранения данных
- `ffi: ^2.1.4` - для работы с FFI

### Rust
- `aes-gcm: ^0.10.3` - AES-GCM шифрование
- `getrandom: ^0.2.10` - генерация случайных чисел
- `lazy_static: ^1.4.0` - ленивая инициализация
