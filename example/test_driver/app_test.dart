// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Test App', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();

    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('getState', () async {
      //bg.State state = await bg.BackgroundGeolocation.getState();

      String response = await driver.requestData("getState");
      print ("********* response: $response");

      expect(true, true);

      // Use the `driver.getText` method to verify the counter starts at 0.
      //expect(await driver.getText(counterTextFinder), "0");
    });

    test('getCurrentPosition', () async {
      //bg.State state = await bg.BackgroundGeolocation.getState();

      String response = await driver.requestData("getCurrentPosition", timeout: Duration(seconds: 30));
      print ("********* response: $response");

      expect(true, true);

      // Use the `driver.getText` method to verify the counter starts at 0.
      //expect(await driver.getText(counterTextFinder), "0");
    });

    test('addGeofence', () async {
      String response = await driver.requestData("addGeofence", timeout: Duration(seconds: 30));
      print ("********* response: $response");
      expect(true, true);
    });

    test('getGeofences', () async {
      String response = await driver.requestData("getGeofences", timeout: Duration(seconds: 30));
      print ("********* response: $response");
      expect(true, true);
    });
  });
}