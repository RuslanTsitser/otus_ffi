compile:
	cd ffi_go && go build -o lib -buildmode=c-shared 

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
	rm -rf ffi_go/lib
	rm -rf lib/lib_bindings.dart
