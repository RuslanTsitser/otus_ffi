import 'dart:ffi' as ffi;
import 'dart:io';

import 'lib_bindings.dart';
import 'string_extension.dart';

final libName = Platform.isAndroid ? 'ffi_lib.so' : 'ffi_lib.framework/ffi_lib';
final lib = FfiLibBindings(ffi.DynamicLibrary.open(libName));

int sum(int a, int b) {
  return lib.sum(a, b);
}

int multiply(int a, int b) {
  return lib.multiply(a, b);
}

String getStringLength(String str) {
  return lib.get_string_length(str.toPointer()).toStr();
}
