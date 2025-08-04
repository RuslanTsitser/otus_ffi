
# Генерация заголовочных файлов Rust
generate-rust-headers:
	cd ffi_rust && cbindgen --config cbindgen.toml --output lib.h

# Генерация dart bindings
ffigen:
	dart run ffigen --config ffigen.yaml

NDK := $(HOME)/Library/Android/sdk/ndk/27.0.12077973
ANDROID_CLANG := $(NDK)/toolchains/llvm/prebuilt/darwin-x86_64/bin


# Компиляция Rust для macOS
compile-rust-macos:
	cd ffi_rust && cargo build --release --target aarch64-apple-darwin
	mkdir -p bin/macos/apple
	cp ffi_rust/target/aarch64-apple-darwin/release/libffi_rust.dylib bin/macos/apple/ffi_lib
	install_name_tool -id @rpath/ffi_lib.framework/ffi_lib bin/macos/apple/ffi_lib
	sh bin/scripts/move_macos.sh

# Компиляция Rust для iOS
compile-rust-ios-device:
	cd ffi_rust && cargo build --release --target aarch64-apple-ios
	mkdir -p bin/ios/device
	cp ffi_rust/target/aarch64-apple-ios/release/libffi_rust.dylib bin/ios/device/ffi_lib
	install_name_tool -id @rpath/ffi_lib.framework/ffi_lib bin/ios/device/ffi_lib

compile-rust-ios-simulator:
	cd ffi_rust && cargo build --release --target aarch64-apple-ios-sim
	mkdir -p bin/ios/simulator
	cp ffi_rust/target/aarch64-apple-ios-sim/release/libffi_rust.dylib bin/ios/simulator/ffi_lib
	install_name_tool -id @rpath/ffi_lib.framework/ffi_lib bin/ios/simulator/ffi_lib

compile-rust-ios: compile-rust-ios-device compile-rust-ios-simulator

# Компиляция Rust для Android
compile-rust-android-arm64-v8a:
	cd ffi_rust && PATH="$(ANDROID_CLANG):$$PATH" cargo build --release --target aarch64-linux-android
	mkdir -p bin/android/arm64-v8a
	cp ffi_rust/target/aarch64-linux-android/release/libffi_rust.so bin/android/arm64-v8a/ffi_lib.so

compile-rust-android-x86_64:
	cd ffi_rust && PATH="$(ANDROID_CLANG):$$PATH" cargo build --release --target x86_64-linux-android
	mkdir -p bin/android/x86_64
	cp ffi_rust/target/x86_64-linux-android/release/libffi_rust.so bin/android/x86_64/ffi_lib.so

compile-rust-android: compile-rust-android-arm64-v8a compile-rust-android-x86_64

# Компиляция Rust для всех платформ
compile-rust-all: compile-rust-macos compile-rust-ios compile-rust-android

move-all:
	sh bin/scripts/move_macos.sh
	sh bin/scripts/move_ios.sh
	sh bin/scripts/move_android.sh

# Очистка Rust
clean-rust:
	cd ffi_rust && cargo clean

