import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

/**
 * GoogleMap View
 */
class MapView extends StatefulWidget {
  @override
  State createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  static const double DEFAULT_ZOOM = 18.0;

  GoogleMapController _mapController;
  
  @override
  Widget build(BuildContext context) {
    bg.BackgroundGeolocation.onEnabledChange((enabled) {
      if (!enabled) { _removeMarkers(); }
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      _setCenter(location, DEFAULT_ZOOM);
    });

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      if (!location.sample) {
        _addMarker(location);
      }
      _setCenter(location, DEFAULT_ZOOM);
    });

    return GoogleMap(
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() { _mapController = controller; });
  }

  void _addMarker(bg.Location location) {
    if (_mapController == null) {
      // No iOS implementation of flutter_google_maps :(
      return;
    }
    _mapController.addMarker(MarkerOptions(
      position: LatLng(location.coords.latitude, location.coords.longitude
      ),
    ));
  }

  void _removeMarkers() {
    _mapController.markers.forEach((Marker marker) => _mapController.removeMarker(marker));
  }

  void _setCenter(bg.Location location, double zoom) {
    if (_mapController == null) {
      // No iOS implementation of flutter_google_maps :(
      return;
    }
    CameraPosition position;
    position = new CameraPosition(
        target: LatLng(location.coords.latitude, location.coords.longitude),
        zoom: zoom
    );

    _mapController.updateMapOptions(GoogleMapOptions(
        cameraPosition: position
    ));
  }
}


