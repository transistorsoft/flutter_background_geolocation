import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart'
    as util;
import 'geofence_view.dart';
import 'package:latlong2/latlong.dart';
import 'util/geospatial.dart';

class MapView extends StatefulWidget {
  @override
  State createState() => MapViewState();
}

class MapViewState extends State<MapView>
    with AutomaticKeepAliveClientMixin<MapView> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  bg.Location _stationaryLocation;

  List<CircleMarker> _currentPosition = [];
  List<LatLng> _polyline = [];
  List<CircleMarker> _locations = [];
  List<CircleMarker> _stopLocations = [];
  List<Polyline> _motionChangePolylines = [];
  List<CircleMarker> _stationaryMarker = [];

  List<GeofenceMarker> _geofences = [];
  List<GeofenceMarker> _geofenceEvents = [];
  List<CircleMarker> _geofenceEventEdges = [];
  List<CircleMarker> _geofenceEventLocations = [];
  List<Polyline> _geofenceEventPolylines = [];

  LatLng _center = new LatLng(51.5, -0.09);
  MapController _mapController;
  MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();
    _mapOptions = new MapOptions(
        onPositionChanged: _onPositionChanged,
        center: _center,
        zoom: 16.0,
        onLongPress: _onAddGeofence);
    _mapController = new MapController();

    bg.BackgroundGeolocation.onLocation(_onLocation);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onGeofencesChange(_onGeofencesChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);
  }

  void _onEnabledChange(bool enabled) {
    if (!enabled) {
      _locations.clear();
      _polyline.clear();
      _stopLocations.clear();
      _motionChangePolylines.clear();
      _stationaryMarker.clear();
      _geofenceEvents.clear();
      _geofenceEventPolylines.clear();
      _geofenceEventLocations.clear();
      _geofenceEventEdges.clear();
    }
  }

  void _onMotionChange(bg.Location location) async {
    LatLng ll = new LatLng(location.coords.latitude, location.coords.longitude);

    _updateCurrentPositionMarker(ll);

    _mapController.move(ll, _mapController.zoom);

    // clear the big red stationaryRadius circle.
    _stationaryMarker.clear();

    if (location.isMoving) {
      if (_stationaryLocation == null) {
        _stationaryLocation = location;
      }
      // Add previous stationaryLocation as a small red stop-circle.
      _stopLocations.add(_buildStopCircleMarker(_stationaryLocation));
      // Create the green motionchange polyline to show where tracking engaged from.
      _motionChangePolylines
          .add(_buildMotionChangePolyline(_stationaryLocation, location));
    } else {
      // Save a reference to the location where we became stationary.
      _stationaryLocation = location;
      // Add the big red stationaryRadius circle.
      bg.State state = await bg.BackgroundGeolocation.state;
      _stationaryMarker.add(_buildStationaryCircleMarker(location, state));
    }
  }

  void _onGeofence(bg.GeofenceEvent event) async {
    bg.Logger.info('[onGeofence] Flutter received onGeofence event $event');

    GeofenceMarker marker = _geofences.firstWhere(
        (GeofenceMarker marker) =>
            marker.geofence.identifier == event.identifier,
        orElse: () => null);
    if (marker == null) {
      bool exists =
          await bg.BackgroundGeolocation.geofenceExists(event.identifier);
      if (exists) {
        // Maybe this is a boot from a geofence event and geofencechange hasn't yet fired
        bg.Geofence geofence =
            await bg.BackgroundGeolocation.getGeofence(event.identifier);
        marker = GeofenceMarker(geofence);
        _geofences.add(marker);
      } else {
        print(
            "[_onGeofence] failed to find geofence marker: ${event.identifier}");
        return;
      }
    }

    bg.Geofence geofence = marker.geofence;

    // Render a new greyed-out geofence CircleMarker to show it's been fired but only if it hasn't been drawn yet.
    // since we can have multiple hits on the same geofence.  No point re-drawing the same hit circle twice.
    GeofenceMarker eventMarker = _geofenceEvents.firstWhere(
        (GeofenceMarker marker) =>
            marker.geofence.identifier == event.identifier,
        orElse: () => null);
    if (eventMarker == null)
      _geofenceEvents.add(GeofenceMarker(geofence, true));

    // Build geofence hit statistic markers:
    // 1.  A computed CircleMarker upon the edge of the geofence circle (red=exit, green=enter)
    // 2.  A CircleMarker for the actual location of the geofence event.
    // 3.  A black PolyLine joining the two above.
    bg.Location location = event.location;
    LatLng center = new LatLng(geofence.latitude, geofence.longitude);
    LatLng hit =
        new LatLng(location.coords.latitude, location.coords.longitude);

    // Update current position marker.
    _updateCurrentPositionMarker(hit);
    // Determine bearing from center -> event location
    double bearing = Geospatial.getBearing(center, hit);
    // Compute a coordinate at the intersection of the line joining center point -> event location and the circle.
    LatLng edge =
        Geospatial.computeOffsetCoordinate(center, geofence.radius, bearing);
    // Green for ENTER, Red for EXIT.
    Color color = Colors.green;
    if (event.action == "EXIT") {
      color = Colors.red;
    } else if (event.action == "DWELL") {
      color = Colors.yellow;
    }

    // Edge CircleMarker (background: black, stroke doesn't work so stack 2 circles)
    _geofenceEventEdges
        .add(CircleMarker(point: edge, color: Colors.black, radius: 5));
    // Edge CircleMarker (foreground)
    _geofenceEventEdges.add(CircleMarker(point: edge, color: color, radius: 4));

    // Event location CircleMarker (background: black, stroke doesn't work so stack 2 circles)
    _geofenceEventLocations
        .add(CircleMarker(point: hit, color: Colors.black, radius: 6));
    // Event location CircleMarker
    _geofenceEventLocations
        .add(CircleMarker(point: hit, color: Colors.blue, radius: 4));
    // Polyline joining the two above.
    _geofenceEventPolylines.add(
        Polyline(points: [edge, hit], strokeWidth: 1.0, color: Colors.black));
  }

  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
    print('[${bg.Event.GEOFENCESCHANGE}] - $event');
    event.off.forEach((String identifier) {
      _geofences.removeWhere((GeofenceMarker marker) {
        return marker.geofence.identifier == identifier;
      });
    });

    event.on.forEach((bg.Geofence geofence) {
      _geofences.add(GeofenceMarker(geofence));
    });

    if (event.off.isEmpty && event.on.isEmpty) {
      _geofences.clear();
    }
  }

  void _onLocation(bg.Location location) {
    LatLng ll = new LatLng(location.coords.latitude, location.coords.longitude);
    _mapController.move(ll, _mapController.zoom);

    _updateCurrentPositionMarker(ll);

    if (location.sample) {
      return;
    }

    // Add a point to the tracking polyline.
    _polyline.add(ll);
    // Add a marker for the recorded location.
    //_locations.add(_buildLocationMarker(location));
    _locations.add(CircleMarker(point: ll, color: Colors.black, radius: 5.0));

    _locations.add(CircleMarker(point: ll, color: Colors.blue, radius: 4.0));
  }

  /// Update Big Blue current position dot.
  void _updateCurrentPositionMarker(LatLng ll) {
    _currentPosition.clear();

    // White background
    _currentPosition
        .add(CircleMarker(point: ll, color: Colors.white, radius: 10));
    // Blue foreground
    _currentPosition
        .add(CircleMarker(point: ll, color: Colors.blue, radius: 7));
  }

  CircleMarker _buildStationaryCircleMarker(
      bg.Location location, bg.State state) {
    return new CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Color.fromRGBO(255, 0, 0, 0.5),
        useRadiusInMeter: true,
        radius: (state.trackingMode == 1)
            ? 200
            : (state.geofenceProximityRadius / 2));
  }

  Polyline _buildMotionChangePolyline(bg.Location from, bg.Location to) {
    return new Polyline(points: [
      LatLng(from.coords.latitude, from.coords.longitude),
      LatLng(to.coords.latitude, to.coords.longitude)
    ], strokeWidth: 10.0, color: Color.fromRGBO(22, 190, 66, 0.7));
  }

  CircleMarker _buildStopCircleMarker(bg.Location location) {
    return new CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Color.fromRGBO(200, 0, 0, 0.3),
        useRadiusInMeter: false,
        radius: 20);
  }

  void _onAddGeofence(LatLng latLng) {
    bg.BackgroundGeolocation.playSound(
        util.Dialog.getSoundId("LONG_PRESS_ACTIVATE"));

    Navigator.of(context).push(MaterialPageRoute<Null>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return GeofenceView(latLng);
        }));
  }

  void _onPositionChanged(MapPosition pos, bool hasGesture) {
    _mapOptions.crs.scale(_mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FlutterMap(
      mapController: _mapController,
      options: _mapOptions,
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new PolylineLayerOptions(
          polylines: [
            new Polyline(
              points: _polyline,
              strokeWidth: 10.0,
              color: Color.fromRGBO(0, 179, 253, 0.8),
            ),
          ],
        ),
        // Active geofence circles
        new CircleLayerOptions(circles: _geofences),
        // Big red stationary radius while in stationary state.
        new CircleLayerOptions(circles: _stationaryMarker),
        // Polyline joining last stationary location to motionchange:true location.
        new PolylineLayerOptions(polylines: _motionChangePolylines),
        // Recorded locations.
        new CircleLayerOptions(circles: _locations),
        // Small, red circles showing where motionchange:false events fired.
        new CircleLayerOptions(circles: _stopLocations),
        // Geofence events (edge marker, event location and polyline joining the two)
        new CircleLayerOptions(circles: _geofenceEvents),
        new PolylineLayerOptions(polylines: _geofenceEventPolylines),
        new CircleLayerOptions(circles: _geofenceEventLocations),
        new CircleLayerOptions(circles: _geofenceEventEdges),
        new CircleLayerOptions(circles: _currentPosition),
      ],
    );
  }
}

class GeofenceMarker extends CircleMarker {
  bg.Geofence geofence;
  GeofenceMarker(bg.Geofence geofence, [bool triggered = false])
      : super(
            useRadiusInMeter: true,
            radius: geofence.radius,
            color: (triggered)
                ? Colors.black26.withOpacity(0.2)
                : Colors.green.withOpacity(0.3),
            point: LatLng(geofence.latitude, geofence.longitude)) {
    this.geofence = geofence;
  }
}
