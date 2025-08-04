rm -rf ios/ffi_lib
mkdir -p ios/ffi_lib
mkdir -p ios/ffi_lib/ffi_lib.framework
# copy podspec and info plist
cp bin/ios/ffi_lib.podspec ios/ffi_lib/ffi_lib.podspec
cp bin/ios/Info.plist ios/ffi_lib/ffi_lib.framework/Info.plist
# copy simulator framework
cp bin/ios/simulator/ffi_lib ios/ffi_lib/ffi_lib.framework/ffi_lib
cd ios && rm -rf Pods Podfile.lock || true && pod install --repo-update && cd ..