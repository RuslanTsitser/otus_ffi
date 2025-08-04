import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension StringExtension on String {
  Pointer<Char> toPointer() {
    return toNativeUtf8().cast<Char>();
  }
}

extension PointerExtension on Pointer<Char> {
  String toStr() {
    final res = cast<Utf8>().toDartString();
    return res;
  }
}
