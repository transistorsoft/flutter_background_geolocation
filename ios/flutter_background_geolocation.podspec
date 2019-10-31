#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_background_geolocation'
  s.version          = '0.2.0'
  s.summary          = 'The most sophisticated background location-tracking &amp; geofencing module with battery-conscious motion-detection intelligence for iOS and Android. '
  s.description      = <<-DESC
The most sophisticated background location-tracking &amp; geofencing module with battery-conscious motion-detection intelligence for iOS and Android.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Transistor Softwrae' => 'info@transistorsoft.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CocoaLumberjack', '~> 3.5.0'

  s.libraries           = 'sqlite3', 'z'
  s.vendored_frameworks = ['TSLocationManager.framework']

  s.static_framework = true

  s.ios.deployment_target = '8.0'
end

