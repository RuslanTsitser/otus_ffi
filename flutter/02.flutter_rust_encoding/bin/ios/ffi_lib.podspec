Pod::Spec.new do |s|
  s.name             = 'ffi_lib'
  s.version          = '1.0.0'
  s.summary          = 'Precompiled dynamic framework for Flutter FFI'
  s.description      = 'A C-based dynamic framework providing sum() function for use with Flutter FFI.'
  s.homepage         = 'http://example.com/ffi_lib'
  s.license          = { :type => 'MIT', :text => 'MIT License' }
  s.author           = { 'Your Name' => 'your@email.com' }

  s.source           = { :path => '.' } # локальный путь, т.к. используешь :path в Podfile
  s.vendored_frameworks = 'ffi_lib.framework'

  s.platform         = :ios, '12.0'
  s.requires_arc     = false

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)'
  }

  s.static_framework = false # ← т.к. это динамический .framework
end
