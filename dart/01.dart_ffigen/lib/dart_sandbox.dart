import 'dart:ffi' as ffi;
import 'dart:io';

import 'sum_bindings.dart';

/// Текущая директория проекта (корень)
final dirPath = Directory.current.path;

final libraryPath = '$dirPath/ffi_c/sum';

final lib = NativeLibrary(ffi.DynamicLibrary.open(libraryPath));

int calculate() {
  return lib.sum(1, 2);
}

int multiply() {
  return lib.multiply(5, 6);
}
