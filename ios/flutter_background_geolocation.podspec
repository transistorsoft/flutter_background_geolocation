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
  s.source_files = 'flutter_background_geolocation/Sources/flutter_background_geolocation/**/*.{h,m}'
  s.public_header_files = 'flutter_background_geolocation/Sources/flutter_background_geolocation/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CocoaLumberjack', '~> 3.8.5'
  s.dependency 'TSLocationManager', '~> 4.0.0-beta.2'
  s.dependency 'TSBackgroundFetch', '~> 4.0.5'
  s.libraries           = 'sqlite3', 'z', 'stdc++'
  s.static_framework = true
  s.resource_bundles = {'TSLocationManagerPrivacy' => ['flutter_background_geolocation/Sources/flutter_background_geolocation/PrivacyInfo.xcprivacy']}
  s.ios.deployment_target = '11.0'
end

