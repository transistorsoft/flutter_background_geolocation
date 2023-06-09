// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:convert';

FlutterDriver? driver;

void main() {
  _group('Test BackgroundGeolocation API', () {
    _test('getState', (String response) async {
      expect(response.contains("State"), true);
      expect(response.contains("enabled: false"), true);
      expect(response.contains("isMoving: false"), true);
      expect(response.contains("trackingMode: 1"), true);
    });

    _test('start', (String response) async {
      expect(response.contains('State'), true);
      expect(response.contains("enabled: true"), true);
    });

  });

  _group('Test Geolocation', () {
    _test('getCurrentPosition', (String response) async {
      expect(response.contains("Location"), true);
    });
  });

  _group('Test BackgroundGeolocation events', () {

    _test('onMotionChange', (String response) async {
      expect(response.contains('Location'), true);
      expect(response.contains('event: motionchange'), true);
    });

    _test('onGeofence', (String response) async {
      expect(response.contains("GeofenceEvent"), true);
    }, 15);

    _test('onLocation', (String response) async {
      expect(response.contains("Location"), true);
    });

    _test('onEnabledChange:true', (String response) async {
      expect(response.contains("true"), true);
    });

    _test('onEnabledChange:false', (String response) async {
      expect(response.contains("false"), true);
    });

    _test('onHttp', (String response) async {
      expect(response.contains("HttpEvent"), true);
      expect(response.contains("status: 200"), true);
      expect(response.contains("success: true"), true);
    });

    _test('onHttp:404', (String response) async {
      expect(response.contains("HttpEvent"), true);
      expect(response.contains("success: false"), true);
      expect(response.contains("status: 404"), true);
    });
  });

  _group('Test Geofencing', () {
    _test('getGeofences', (String response) async {
      List<dynamic> geofences = jsonDecode(response);
      Map geofence = geofences.first;
      String identifier = geofence['identifier'];
      expect(identifier, 'test');
      expect(geofences.length, 1);
    });
  });

  _group('Test BackgroundGeolocation persistence', () {
    _test('getCount', (String response) async {
      expect(response, "1");
    });

    _test('destroyLocations', (String response) async {
      expect(response, "0");
    });
  });
}

void _group(String name, Function callback) async {
  setUpAll(() async {
    //Colorize header = Colorize("[Test Group] - $name");
    //header.green();
    print("[Test Group] - $name");
    driver = await FlutterDriver.connect();

  });
  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    /*
    final driver = this.driver;
    if (driver != null) {
      driver.close();
    }
     */
  });
  //group(name, callback);
}

void _test(String action, Function(String) callback, [int? timeout]) async {
  if (timeout == null) {
    timeout = 5;
  }
  Duration duration = Duration(seconds: timeout);
  test(action, () async {
    String? response = await driver?.requestData(action, timeout: duration);
    log(action, response!);
    callback(response);
  });
}

void log(String command, String message) {
  //Colorize header = Colorize("[FlutterDriver #$command]");
  //header.yellow();
  //Colorize response = Colorize(message);
  //response.darkGray();
  print("[FlutterDriver #$command]");
}

