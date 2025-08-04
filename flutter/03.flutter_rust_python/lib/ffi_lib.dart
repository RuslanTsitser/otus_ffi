import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'lib_bindings.dart';
import 'string_extension.dart';

final libName = Platform.isAndroid ? 'ffi_lib.so' : 'ffi_lib.framework/ffi_lib';
final lib = FfiLibBindings(ffi.DynamicLibrary.open(libName));

void executePythonCode(String code) {
  final pointer = code.toPointer();
  try {
    final result = lib.execute_python_code(pointer);
    if (result == 0) {
      print('Python код выполнен успешно');
    } else {
      print('Ошибка выполнения Python кода');
    }
  } finally {
    // Освобождаем память
    calloc.free(pointer);
  }
}

String executePythonCodeWithOutput(String code) {
  final pointer = code.toPointer();
  try {
    final resultPtr = lib.execute_python_code_with_output(pointer);
    if (resultPtr == ffi.nullptr) {
      return 'Ошибка: не удалось выполнить Python код';
    }

    // Конвертируем результат обратно в Dart строку
    final result = resultPtr.toStr();

    // Освобождаем память результата
    lib.free_python_result(resultPtr);

    return result;
  } finally {
    // Освобождаем память входного параметра
    calloc.free(pointer);
  }
}
