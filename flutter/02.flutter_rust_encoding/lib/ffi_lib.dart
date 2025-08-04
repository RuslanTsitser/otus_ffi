import 'dart:ffi' as ffi;
import 'dart:io';

import 'lib_bindings.dart';
import 'string_extension.dart';

final libName = Platform.isAndroid ? 'ffi_lib.so' : 'ffi_lib.framework/ffi_lib';
final lib = FfiLibBindings(ffi.DynamicLibrary.open(libName));

void encodeBase64File(String inputPath, String outputPath) {
  lib.encode_base64_file(inputPath.toPointer(), outputPath.toPointer());
}

void decodeBase64File(String inputPath, String outputPath) {
  lib.decode_base64_file(inputPath.toPointer(), outputPath.toPointer());
}
