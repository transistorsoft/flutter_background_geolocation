part of flt_background_geolocation;

class GeofencesChangeEvent {
  List<String> off;
  List<Geofence> on;

  GeofencesChangeEvent(List on, List off) {
    this.off = off.cast<String>();
    this.on = new List<Geofence>();

    on.forEach((dynamic data) {
      dynamic loiteringDelay = data['loiteringDelay'];
      if (loiteringDelay.runtimeType == double) {
        loiteringDelay = loiteringDelay.toInt();
      }
      this.on.add(new Geofence(
          identifier: data['identifier'],
          radius: data['radius'] * 1.0,
          latitude: data['latitude'] * 1.0,
          longitude: data['longitude'] * 1.0,
          notifyOnEntry: data['notifyOnEntry'],
          notifyOnExit: data['notifyOnExit'],
          notifyOnDwell: data['notifyOnDwell'],
          loiteringDelay: loiteringDelay));
    });
  }

  String toString() {
    return '[GeofencesChangeEvent off: $off, on: $on]';
  }
}
