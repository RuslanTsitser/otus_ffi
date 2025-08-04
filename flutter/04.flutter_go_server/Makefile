
compile-go-macos:
	cd ffi_go && go build -buildmode=c-shared -o lib
	otool -L ffi_go/lib
	install_name_tool -id @rpath/ffi_lib.framework/ffi_lib ffi_go/lib
	otool -L ffi_go/lib
	mv ffi_go/lib bin/macos/apple/ffi_lib
	sh bin/scripts/move_macos.sh


NDK := $(HOME)/Library/Android/sdk/ndk/27.0.12077973
ANDROID_CLANG := $(NDK)/toolchains/llvm/prebuilt/darwin-x86_64/bin

# Компиляция Go для Android arm64-v8a
compile-go-android-arm64-v8a:
	cd ffi_go && CGO_ENABLED=1 GOOS=android GOARCH=arm64 CC="$(ANDROID_CLANG)/aarch64-linux-android21-clang" go build -buildmode=c-shared -o lib
	mv ffi_go/lib bin/android/arm64-v8a/ffi_lib.so

# Компиляция Go для Android x86_64
compile-go-android-x86_64:
	cd ffi_go && CGO_ENABLED=1 GOOS=android GOARCH=amd64 CC="$(ANDROID_CLANG)/x86_64-linux-android21-clang" go build -buildmode=c-shared -o lib
	mv ffi_go/lib bin/android/x86_64/ffi_lib.so

compile-go-android: compile-go-android-arm64-v8a compile-go-android-x86_64

# Генерация dart bindings
ffigen:
	dart run ffigen --config ffigen.yaml
