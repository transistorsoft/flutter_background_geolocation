// (WO-053) removeGeofences() sends its identifiers over the channel: the list must arrive as sent
// and an omitted one as null, which both natives read as "remove all".  (WO-055) An empty list
// names none and never crosses: both cores read an empty list as "remove all".
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:flutter_test/flutter_test.dart';

const _channel =
    MethodChannel('com.transistorsoft/flutter_background_geolocation/methods');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      return true;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  test('WO-053 removeGeofences(identifiers) sends the identifiers', () async {
    expect(await BackgroundGeolocation.removeGeofences(['a', 'b']), true);
    expect(calls.single.method, 'removeGeofences');
    expect(calls.single.arguments, ['a', 'b']);
  });

  test('WO-053 removeGeofences() sends null, which the natives read as all', () async {
    expect(await BackgroundGeolocation.removeGeofences(), true);
    expect(calls.single.method, 'removeGeofences');
    expect(calls.single.arguments, isNull);
  });

  test('WO-055 removeGeofences([]) answers true without calling the channel', () async {
    expect(await BackgroundGeolocation.removeGeofences([]), true);
    expect(calls, isEmpty);
  });
}
