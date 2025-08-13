import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'lib_bindings.dart';
import 'string_extension.dart';

const libraryPath = 'ffi_c/lib';
final nativeLibrary = ffi.DynamicLibrary.open(libraryPath);
final lib = NativeLibrary(nativeLibrary);

String getStringLengthWithStatic(String value) {
  final pointer = value.toPointer();

  final result = lib.get_string_length_with_static(pointer);
  malloc.free(pointer);

  final resultDart = result.toStr();
  return resultDart;
}

String getStringLengthWithMalloc(String value) {
  final pointer = value.toPointer();

  final result = lib.get_string_length_with_malloc(pointer);
  malloc.free(pointer);

  final resultDart = result.toStr();
  // Нужно освободить, потому что в C была выделена память
  lib.lib_free(result);

  return resultDart;
}
