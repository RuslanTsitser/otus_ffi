# Компиляция библиотеки
compile:
	clang ffi_c/lib.c -fPIC -shared -o ffi_c/lib

# Генерация dart bindings
ffigen:
	dart run ffigen --config ffigen.yaml

# Подготавливаем сборку
prebuild: compile ffigen

# Запуск приложения
run:
	dart run bin/dart_sandbox.dart

# Очистка
clean:
	rm -rf ffi_c/lib
	rm -rf lib/lib_bindings.dart
