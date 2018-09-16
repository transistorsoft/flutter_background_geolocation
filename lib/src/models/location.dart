part of flt_background_geolocation;

class Coords {
  int floor;
  double latitude;
  double longitude;
  double accuracy;
  double altitude;
  double heading;
  double speed;
  double altitudeAccuracy;

  Coords(dynamic coords) {
    this.latitude = coords['latitude'] * 1.0;
    this.longitude = coords['longitude'] * 1.0;
    this.accuracy = coords['accuracy'] * 1.0;
    this.altitude = coords['altitude'] * 1.0;
    this.heading = coords['heading'] * 1.0;
    this.speed = coords['speed'] * 1.0;
    if (coords['altitude_accuracy'] != null) {
      this.altitudeAccuracy = coords['altitude_accuracy'] * 1.0;
    }
    this.floor = coords['floor'];
  }
}

class Battery {
  bool isCharging;
  double level;

  Battery(dynamic battery) {
    this.isCharging = battery['is_charging'];
    this.level = battery['level'] * 1.0;
  }
}

class Activity {
  String type;
  int confidence;

  Activity(dynamic activity) {
    this.type = activity['type'];
    this.confidence = activity['confidence'];
  }
}

class Location {
  dynamic map;
  String timestamp;
  String event;
  bool mock;
  bool sample;
  double odometer;
  bool isMoving;
  String uuid;

  Coords coords;
  GeofenceEvent geofence;
  Battery battery;
  Activity activity;

  Map extras;

  Location(dynamic params) {
    this.map = params;
    this.coords = new Coords(params['coords']);
    this.battery = new Battery(params['battery']);
    this.activity = new Activity(params['activity']);

    this.timestamp = params['timestamp'];
    this.isMoving = params['is_moving'];
    this.uuid = params['uuid'];
    this.odometer = params['odometer'] * 1.0;

    this.sample = (params['sample'] != null) ? params['sample'] : false;

    if (params['event'] != null) {
      this.event = params['event'];
    }
    if (params['geofence'] != null) {
      this.geofence = new GeofenceEvent(params['geofence']);
    }
    if (params['mock'] != null) {
      this.mock = params['mock'];
    }
    if (params['extras'] != null) {
      this.extras = params['extras'];
    }
  }

  String toString() {
    return '[Location ' + this.map.toString() + ']';
  }

  Map toMap() {
    return map;
  }
}
