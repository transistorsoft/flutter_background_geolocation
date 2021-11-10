import 'dart:math' show cos, sin, asin, tan, atan2, log;
import 'package:latlong2/latlong.dart';

///
/// Geospatial helper functions for calculating Geofence Hit markers on map_view
///
class Geospatial {
  static LatLng computeOffsetCoordinate(
      LatLng coordinate, double distance, double heading) {
    distance = distance / (6371 * 1000);
    heading = toRad(heading);

    double lat1 = toRad(coordinate.latitude);
    double lng1 = toRad(coordinate.longitude);

    double lat2 = asin(
        sin(lat1) * cos(distance) + cos(lat1) * sin(distance) * cos(heading));
    double lng2 = lng1 +
        atan2(sin(heading) * sin(distance) * cos(lat1),
            cos(distance) - sin(lat1) * sin(lat2));

    return new LatLng(toDeg(lat2), toDeg(lng2));
  }

  static double getBearing(LatLng start, LatLng end) {
    double startLat = toRad(start.latitude);
    double startLng = toRad(start.longitude);

    double endLat = toRad(end.latitude);
    double endLng = toRad(end.longitude);

    double dLng = endLng - startLng;
    double dPhi =
        log(tan(endLat / 2.0 + pi / 4.0) / tan(startLat / 2.0 + pi / 4.0));

    if (dLng.abs() > pi) {
      dLng = (dLng > 0.0) ? -(2.0 * pi - dLng) : (2.0 * pi + dLng);
    }
    return (toDeg(atan2(dLng, dPhi)) + 360.0) % 360.0;
  }

  static double toRad(double n) {
    return n * (pi / 180);
  }

  static double toDeg(double n) {
    return n * (180 / pi);
  }
}
