import 'dart:ffi' as ffi;
import 'dart:io';

import 'lib_bindings.dart';

final libName = Platform.isAndroid ? 'ffi_lib.so' : 'ffi_lib.framework/ffi_lib';
final lib = FfiLibBindings(ffi.DynamicLibrary.open(libName));

void startServer(int port) {
  lib.StartServer(8080);
}
