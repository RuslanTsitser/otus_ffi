# Компиляция для macos Apple
compile-macos-apple:
	mkdir -p bin/macos/apple
	clang ffi_c/lib.c \
	-install_name @rpath/ffi_lib.framework/ffi_lib \
	-fPIC -shared -o bin/macos/apple/ffi_lib	

# Компиляция для iOS
compile-ios-device:
	mkdir -p bin/ios/device
	xcrun --sdk iphoneos clang ffi_c/lib.c \
	-install_name @rpath/ffi_lib.framework/ffi_lib \
	-arch arm64 -fPIC -shared -o bin/ios/device/ffi_lib

# Компиляция для iOS Simulator
compile-ios-simulator:
	mkdir -p bin/ios/simulator
	xcrun --sdk iphonesimulator clang ffi_c/lib.c \
	-install_name @rpath/ffi_lib.framework/ffi_lib \
	-arch arm64 -fPIC -shared -o bin/ios/simulator/ffi_lib

compile-ios: compile-ios-device compile-ios-simulator

NDK := $(HOME)/Library/Android/sdk/ndk/27.0.12077973
ANDROID_CLANG := $(NDK)/toolchains/llvm/prebuilt/darwin-x86_64/bin

# Компиляция для Android arm64-v8a
compile-android-arm64-v8a:
	mkdir -p bin/android/arm64-v8a
	$(ANDROID_CLANG)/aarch64-linux-android21-clang ffi_c/lib.c \
	-fPIC -shared -o bin/android/arm64-v8a/ffi_lib.so

# Компиляция для Android x86_64
compile-android-x86_64:
	mkdir -p bin/android/x86_64
	$(ANDROID_CLANG)/x86_64-linux-android21-clang ffi_c/lib.c \
	-fPIC -shared -o bin/android/x86_64/ffi_lib.so

compile-android: compile-android-arm64-v8a compile-android-x86_64

# Генерация dart bindings
ffigen:
	dart run ffigen --config ffigen.yaml

compile-go-macos:
	cd ffi_go && go build -buildmode=c-shared -o lib
	otool -L ffi_go/lib
	install_name_tool -id @rpath/ffi_lib.framework/ffi_lib ffi_go/lib
	otool -L ffi_go/lib
	mv ffi_go/lib bin/macos/apple/ffi_lib
	sh bin/scripts/move_macos.sh

# Компиляция Go для Android arm64-v8a
compile-go-android-arm64-v8a:
	cd ffi_go && CGO_ENABLED=1 GOOS=android GOARCH=arm64 CC="$(ANDROID_CLANG)/aarch64-linux-android21-clang" go build -buildmode=c-shared -o lib
	mv ffi_go/lib bin/android/arm64-v8a/ffi_lib.so

# Компиляция Go для Android x86_64
compile-go-android-x86_64:
	cd ffi_go && CGO_ENABLED=1 GOOS=android GOARCH=amd64 CC="$(ANDROID_CLANG)/x86_64-linux-android21-clang" go build -buildmode=c-shared -o lib
	mv ffi_go/lib bin/android/x86_64/ffi_lib.so

compile-go-android: compile-go-android-arm64-v8a compile-go-android-x86_64

# Компиляция Rust для macOS
compile-rust-macos:
	cd ffi_rust && cargo build --release --target x86_64-apple-darwin
	cd ffi_rust && cargo build --release --target aarch64-apple-darwin
	mkdir -p bin/macos/apple
	lipo -create ffi_rust/target/x86_64-apple-darwin/release/libffi_rust.dylib ffi_rust/target/aarch64-apple-darwin/release/libffi_rust.dylib -output bin/macos/apple/ffi_lib
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

# Очистка Rust
clean-rust:
	cd ffi_rust && cargo clean

# Генерация заголовочных файлов Rust
generate-rust-headers:
	cd ffi_rust && cbindgen --config cbindgen.toml --output lib.h

