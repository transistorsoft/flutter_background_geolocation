// (WO-048) Config.toMap() expands transistorAuthorizationToken into the map sent over the
// channel: neither native core knows the key. The url must land in the `http` group that map
// carries, even when the caller passes an HttpConfig of their own.
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:flutter_test/flutter_test.dart';

const _tokenUrl = 'http://10.0.2.2:9';
const _locationsUrl = '$_tokenUrl/api/locations';

TransistorAuthorizationToken _token() =>
    TransistorAuthorizationToken('lab-token', 'lab-refresh', 4102444800, _tokenUrl);

Map _http(Map map) => map['http'] as Map;

void main() {
  test('WO-048 an http group plus a token: http.url is the token url, autoSync is kept', () {
    final map = Config(
      http: HttpConfig(autoSync: false),
      transistorAuthorizationToken: _token(),
    ).toMap()!;
    expect(_http(map)['url'], _locationsUrl);
    expect(_http(map)['autoSync'], false);
  });

  test('WO-048 no http group: the token url is sent as http.url, not the flat url', () {
    final map = Config(transistorAuthorizationToken: _token()).toMap()!;
    expect(_http(map)['url'], _locationsUrl);
    expect(map.containsKey('url'), false);
  });

  test("WO-048 the token overrides a caller's http.url and flat url", () {
    final map = Config(
      http: HttpConfig(url: 'http://10.0.2.2:8/app', autoSync: false),
      url: 'http://10.0.2.2:8/flat',
      transistorAuthorizationToken: _token(),
    ).toMap()!;
    expect(_http(map)['url'], _locationsUrl);
    expect(map.containsKey('url'), false);
  });

  test('WO-048 toMap() twice sends the same http.url', () {
    final config = Config(
      http: HttpConfig(autoSync: false),
      transistorAuthorizationToken: _token(),
    );
    final first = _http(config.toMap()!)['url'];
    final second = _http(config.toMap()!)['url'];
    expect(first, _locationsUrl);
    expect(second, first);
  });

  test("WO-048 the caller's HttpConfig, url and authorization are left as passed", () {
    final http = HttpConfig(autoSync: false);
    final config = Config(http: http, transistorAuthorizationToken: _token());
    config.toMap();
    expect(http.url, isNull);
    expect(config.url, isNull);
    expect(config.authorization, isNull);
  });

  test('WO-048 authorization comes from the token', () {
    final map = Config(
      http: HttpConfig(autoSync: false),
      transistorAuthorizationToken: _token(),
    ).toMap()!;
    final authorization = map['authorization'] as Map;
    expect(authorization['accessToken'], 'lab-token');
    expect(authorization['refreshToken'], 'lab-refresh');
    expect(authorization['refreshUrl'], '$_tokenUrl/api/refresh_token');
    expect(authorization['expires'], 4102444800);
  });
}
