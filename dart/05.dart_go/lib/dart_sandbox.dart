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

String factorialsOfIntArray(List<int> array) {
  final pointer = malloc<ffi.Int>(array.length);
  for (var i = 0; i < array.length; i++) {
    pointer[i] = array[i];
  }
  final result = _lib.FactorialsOfIntArray(pointer, array.length);
  final resultStr = result.toStr();
  _lib.FreeString(result);
  malloc.free(pointer);
  return resultStr;
}

String factorialsOfIntArrayDart(List<int> array) {
  final result = <int>[];
  for (var i = 0; i < array.length; i++) {
    result.add(factorial(array[i]));
  }
  return result.join(' ');
}

int factorial(int n) {
  if (n == 0) {
    return 1;
  }
  int res = 1;
  for (var i = 2; i <= n; i++) {
    res *= i;
  }
  return res;
}
