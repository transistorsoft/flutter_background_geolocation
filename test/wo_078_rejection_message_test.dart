// (WO-078) The natives now reject with the failure string in both code and message. These tests
// pin the Dart consumers against that envelope: each still behaves (getGeofence's "404",
// LocationError's parsing, requestPermission's details), and Dart neither hides the message nor
// int-parses a pass-through code. A mock stands in for the natives, so it cannot see the native
// change itself; the lab's api-errors row does.
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_test/flutter_test.dart';

const _channel =
    MethodChannel('com.transistorsoft/flutter_background_geolocation/methods');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void rejectWith(PlatformException e) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async => throw e);
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  Matcher passedThrough(String text) => throwsA(isA<PlatformException>()
      .having((e) => e.code, 'code', text)
      .having((e) => e.message, 'message', text));

  test('WO-078 a pass-through rejection reaches the caller with its text in code and message',
      () async {
    final calls = <String, Future<Object?> Function()>{
      'insertLocation params must contain location.timestamp':
          () => bg.BackgroundGeolocation.insertLocation({}),
      'Failed to start schedule.  Did you configure a #schedule?':
          () => bg.BackgroundGeolocation.startSchedule(),
      'No Geofences provided': () => bg.BackgroundGeolocation.addGeofences([]),
      'Failed to destroy location': () => bg.BackgroundGeolocation.destroyLocation('x'),
    };
    for (final entry in calls.entries) {
      rejectWith(PlatformException(code: entry.key, message: entry.key));
      await expectLater(entry.value(), passedThrough(entry.key), reason: entry.key);
    }
  });

  test('WO-078 getGeofence still resolves null on 404', () async {
    rejectWith(PlatformException(code: '404', message: '404'));
    expect(await bg.BackgroundGeolocation.getGeofence('missing'), isNull);
  });

  test('WO-078 getCurrentPosition keeps its numeric LocationError', () async {
    rejectWith(PlatformException(code: '408', message: null));
    await expectLater(
        bg.BackgroundGeolocation.getCurrentPosition(samples: 1),
        throwsA(isA<bg.LocationError>()
            .having((e) => e.code, 'code', 408)
            .having((e) => e.message, 'message', '')));
  });

  test('WO-078 requestPermission still errors with the bare status', () async {
    rejectWith(PlatformException(code: 'DENIED', details: 2));
    await expectLater(bg.BackgroundGeolocation.requestPermission(), throwsA(2));
  });

  test('WO-078 changePace passes a numeric rejection through', () async {
    rejectWith(PlatformException(code: '3', message: '3'));
    await expectLater(bg.BackgroundGeolocation.changePace(true), passedThrough('3'));
  });
}
