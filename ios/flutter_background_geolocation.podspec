require 'yaml'
pubspec = YAML.load_file('../pubspec.yaml')

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.cocoapods_version   = '>= 1.10.0'
  s.name             = pubspec['name']
  s.version          = pubspec['version']
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']

  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Transistor Software' => 'info@transistorsoft.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CocoaLumberjack', '~> 3.7.2'

  s.libraries           = 'sqlite3', 'z', 'stdc++'
  s.vendored_frameworks = ['TSLocationManager.xcframework']
  s.static_framework = true

  s.ios.deployment_target = '11.0'
end

