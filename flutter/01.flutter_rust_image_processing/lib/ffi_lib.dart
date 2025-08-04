import 'dart:ffi' as ffi;
import 'dart:io';

import 'lib_bindings.dart';
import 'string_extension.dart';

final libName = Platform.isAndroid ? 'ffi_lib.so' : 'ffi_lib.framework/ffi_lib';
final lib = FfiLibBindings(ffi.DynamicLibrary.open(libName));

void rotateImage90(String inputPath, String outputPath) {
  lib.rotate_image_90_file(inputPath.toPointer(), outputPath.toPointer());
}
