import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'lib_bindings.dart';
import 'string_extension.dart';

/// Текущая директория проекта (корень)
final _dirPath = Directory.current.path;

final _libraryPath = '$_dirPath/ffi_c/lib';

final _lib = LibBindings(ffi.DynamicLibrary.open(_libraryPath));

int sum(int a, int b) {
  return _lib.sum(a, b);
}

int multiply(int a, int b) {
  return _lib.multiply(a, b);
}

String getStringLength(String value) {
  final pointer = value.toPointer();
  final result = _lib.get_string_length_with_static(pointer);
  malloc.free(pointer);
  return result.toStr();
}
