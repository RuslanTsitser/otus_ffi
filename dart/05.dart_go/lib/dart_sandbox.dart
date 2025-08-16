import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'lib_bindings.dart';
import 'string_extension.dart';

final _libraryPath = 'ffi_go/lib';

final _lib = LibBindings(ffi.DynamicLibrary.open(_libraryPath));

int sum(int a, int b) {
  return _lib.sum(a, b);
}

int multiply(int a, int b) {
  return _lib.multiply(a, b);
}

String getStringLength(String value) {
  final pointer = value.toPointer();
  final result = _lib.get_string_length(pointer);
  final resultStr = result.toStr();
  _lib.lib_free(result);
  malloc.free(pointer);
  return resultStr;
}
