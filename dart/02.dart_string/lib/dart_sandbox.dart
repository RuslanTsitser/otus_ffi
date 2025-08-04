import 'dart:ffi' as ffi;
import 'dart:io';

import 'lib_bindings.dart';
import 'string_extension.dart';

/// Текущая директория проекта (корень)
final dirPath = Directory.current.path;

final libraryPath = '$dirPath/ffi_c/lib';

final lib = NativeLibrary(ffi.DynamicLibrary.open(libraryPath));

String getStringLength(String value) {
  final result = lib.get_string_length(value.toPointer());
  return result.toStr();
}
