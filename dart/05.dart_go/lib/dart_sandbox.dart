import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'lib_bindings.dart';
import 'string_extension.dart';

final _libraryPath = 'ffi_go/lib';

final _lib = LibBindings(ffi.DynamicLibrary.open(_libraryPath));

int sum(int a, int b) {
  return _lib.Sum(a, b);
}

int multiply(int a, int b) {
  return _lib.Multiply(a, b);
}

String getStringLength(String value) {
  final pointer = value.toPointer();
  final result = _lib.GetStringLength(pointer);
  final resultStr = result.toStr();
  _lib.FreeString(result);
  malloc.free(pointer);
  return resultStr;
}
