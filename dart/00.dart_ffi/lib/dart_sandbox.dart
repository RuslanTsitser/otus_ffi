// lib/dart_sandbox.dart

import 'dart:ffi' as ffi;
import 'dart:io';

/// Текущая директория проекта (корень)
final dirPath = Directory.current.path;

final libraryPath = '$dirPath/ffi_c/sum';

final lib = ffi.DynamicLibrary.open(libraryPath);

/// Интерфейс функции на C
typedef SumFunc = ffi.Int Function(ffi.Int, ffi.Int);

/// Интерфейс функции на Dart
typedef Sum = int Function(int, int);

int sum(int a, int b) {
  final Sum libSum = lib
      .lookup<ffi.NativeFunction<SumFunc>>('sum')
      .asFunction();
  return libSum(a, b);
}

typedef MultiplyFunc = ffi.Int Function(ffi.Int, ffi.Int);

typedef Multiply = int Function(int, int);

int multiply(int a, int b) {
  final Multiply libMultiply = lib
      .lookup<ffi.NativeFunction<MultiplyFunc>>('multiply')
      .asFunction();
  return libMultiply(a, b);
}
