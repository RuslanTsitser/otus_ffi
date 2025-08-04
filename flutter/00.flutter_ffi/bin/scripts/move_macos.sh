rm -rf macos/ffi_lib
mkdir -p macos/ffi_lib
mkdir -p macos/ffi_lib/ffi_lib.framework
# copy podspec and info plist
cp bin/macos/ffi_lib.podspec macos/ffi_lib/ffi_lib.podspec
cp bin/macos/Info.plist macos/ffi_lib/ffi_lib.framework/Info.plist
# copy framework
cp bin/macos/apple/ffi_lib macos/ffi_lib/ffi_lib.framework/ffi_lib
cd macos && rm -rf Pods Podfile.lock || true && pod install --repo-update && cd ..