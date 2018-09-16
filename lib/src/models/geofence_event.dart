part of flt_background_geolocation;

class GeofenceEvent {
  String identifier;
  String action;
  Location location;
  Map extras;

  GeofenceEvent(Map params) {
    // Remove geofence from location to prevent recursive creation fo GeofenceEvent.
    Map locationData = params['location'];
    locationData.remove("geofence");

    this.identifier = params['identifier'];
    this.action = params['action'];
    this.location = new Location(locationData);
    this.extras = params['extras'];
  }

  String toString() {
    return '[GeofenceEvent identifier: $identifier, action: $action]';
  }
}
