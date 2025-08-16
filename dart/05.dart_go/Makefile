# Компиляция библиотеки
compile:
	clang ffi_c/lib.c -fPIC -shared -o ffi_c/lib

compile_go:
	cd ffi_go && go build -buildmode=c-shared -o lib

compile_rust:
	cd ffi_rust && cargo build --release
	cd ffi_rust && cbindgen --config cbindgen.toml --output lib.h
	cp ffi_rust/target/release/libffi_rust.dylib ffi_rust/lib

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
	rm -rf ffi_go/lib
	rm -rf ffi_rust/lib
	rm -rf lib/lib_bindings.dart
