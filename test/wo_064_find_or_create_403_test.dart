// (WO-064) findOrCreate completes on every branch: a 403 completes with an error, any other
// failure with a DUMMY_TOKEN. Its catchError used to throw on a 403, and to throw reading `.code`
// from an error that is not a PlatformException, leaving the returned future incomplete.
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_test/flutter_test.dart';

const _channel =
    MethodChannel('com.transistorsoft/flutter_background_geolocation/methods');
const _timeout = Duration(seconds: 2);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void mock(Future<Object?> Function(MethodCall call)? handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, handler);
  }

  tearDown(() => mock(null));

  Future<bg.TransistorAuthorizationToken> findOrCreate() =>
      bg.TransistorAuthorizationToken.findOrCreate('o', 'u', 'https://x')
          .timeout(_timeout);

  test('WO-064 a 403 completes with an error', () async {
    mock((call) async =>
        throw PlatformException(code: '403', message: 'Forbidden'));
    await expectLater(
        findOrCreate(),
        throwsA(isA<bg.Error>()
            .having((e) => e.code, 'code', 403)
            .having((e) => e.message, 'message', 'Forbidden')));
  });

  test('WO-064 another code resolves a DUMMY_TOKEN', () async {
    mock((call) async => throw PlatformException(code: '500'));
    final token = await findOrCreate();
    expect(token.accessToken, 'DUMMY_TOKEN');
    expect(token.url, 'https://x');
  });

  test('WO-064 an Android JSONException message resolves a DUMMY_TOKEN', () async {
    mock((call) async => throw PlatformException(
        code: 'Value <html> of type java.lang.String cannot be converted to JSONObject',
        message: 'Value <html> of type java.lang.String cannot be converted to JSONObject'));
    expect((await findOrCreate()).accessToken, 'DUMMY_TOKEN');
  });

  test('WO-064 a missing implementation resolves a DUMMY_TOKEN', () async {
    mock(null); // no handler: the call throws MissingPluginException
    expect((await findOrCreate()).accessToken, 'DUMMY_TOKEN');
  });

  test('WO-064 success builds the token', () async {
    mock((call) async {
      expect(call.method, 'getTransistorToken');
      expect(call.arguments, ['o', 'u', 'https://x']);
      return {'accessToken': 'a', 'refreshToken': 'r', 'expires': 42};
    });
    final token = await findOrCreate();
    expect(token.accessToken, 'a');
    expect(token.refreshToken, 'r');
    expect(token.expires, 42);
    expect(token.url, 'https://x');
  });
}
