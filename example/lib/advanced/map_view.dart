import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'dialog.dart' as util;
import 'geofence_view.dart';
import 'package:latlong/latlong.dart';

const String MAP_TOKEN = 'pk.eyJ1IjoiY2hyaXN0b2NyYWN5IiwiYSI6ImVmM2Y2MDA1NzIyMjg1NTdhZGFlYmZiY2QyODVjNzI2In0.htaacx3ZhE5uAWN86-YNAQ';

class MapView extends StatefulWidget {
  @override
  State createState() => MapViewState();
}

class MapViewState extends State<MapView> with AutomaticKeepAliveClientMixin<MapView> {
  @override
  bool get wantKeepAlive { return true; }

  bg.Location _stationaryLocation;
  List<LatLng> _polyline = [];
  List<CircleMarker> _locations = [];
  List<CircleMarker> _stopLocations = [];
  List<Polyline> _motionChangePolylines = [];
  List<CircleMarker> _stationaryMarker = [];
  List<GeofenceMarker> _geofences = [];

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
        plugins: [
          new LongPressPlugin()
        ]
    );
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
    }
  }
  void _onMotionChange(bg.Location location) {
    LatLng ll = new LatLng(location.coords.latitude, location.coords.longitude);
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
      _motionChangePolylines.add(_buildMotionChangePolyline(_stationaryLocation, location));
    } else {
      // Save a reference to the location where we became stationary.
      _stationaryLocation = location;
      // Add the big red stationaryRadius circle.
      _stationaryMarker.add(_buildStationaryCircleMarker(location));
    }
  }

  void _onGeofence(bg.GeofenceEvent event) {
    bg.Geofence geofence;
    _geofences.removeWhere((GeofenceMarker marker) {
      if (marker.geofence.identifier == event.identifier) {
        geofence = marker.geofence;
        return true;
      }
      return false;
    });
    if (geofence != null) {
      _geofences.add(GeofenceMarker(geofence, true));
    }
  }

  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
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
    if (location.sample) { return; }

    // Add a point to the tracking polyline.
    _polyline.add(ll);
    // Add a marker for the recorded location.
    _locations.add(_buildLocationMarker(location));
  }

  CircleMarker _buildStationaryCircleMarker(bg.Location location) {
    return new CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Color.fromRGBO(255, 0, 0, 0.5),
        radius: 50
    );
  }

  Polyline _buildMotionChangePolyline(bg.Location from, bg.Location to) {
    return new Polyline(
      points: [
        LatLng(from.coords.latitude, from.coords.longitude),
        LatLng(to.coords.latitude, to.coords.longitude)
      ],
      strokeWidth: 10.0,
      color: Color.fromRGBO(22, 190, 66, 0.7)
    );
  }


  CircleMarker _buildStopCircleMarker(bg.Location location) {
    return new CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Color.fromRGBO(255, 0, 0, 0.5),
        radius: 10
    );
  }

  CircleMarker _buildLocationMarker(bg.Location location) {
    return new CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Colors.indigo,
        radius: 5.0
    );
  }

  void _onAddGeofence(LatLng latLng) {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("LONG_PRESS_ACTIVATE"));

    Navigator.of(context).push(MaterialPageRoute<Null>(fullscreenDialog: true, builder: (BuildContext context) {
      return GeofenceView(latLng);
    }));
  }

  void _onPositionChanged(MapPosition pos, bool foo) {
    num scale = _mapOptions.crs.scale(_mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: _mapOptions,
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': MAP_TOKEN,
            'id': 'mapbox.streets',
          },
        ),
        new PolylineLayerOptions(
          polylines: [
            new Polyline(
                points: _polyline,
                strokeWidth: 10.0,
                color: Color.fromRGBO(0, 179, 253, 0.7),
            ),
          ],
        ),
        new CircleLayerOptions(circles: _geofences),
        new CircleLayerOptions(circles: _stationaryMarker),
        new PolylineLayerOptions(polylines: _motionChangePolylines),
        new CircleLayerOptions(circles: _locations),
        new CircleLayerOptions(circles: _stopLocations),
        new LongPressOptions(context: context, onLongPress: _onAddGeofence)
      ],
    );
  }
}

class GeofenceMarker extends CircleMarker {
  bg.Geofence geofence;
  GeofenceMarker(bg.Geofence geofence, [bool triggered=false]):super(radius: 75.0, color: (triggered) ? Color.fromRGBO(100, 100, 100, 0.5) : Color.fromRGBO(0, 200, 0, 0.2), point: LatLng(geofence.latitude, geofence.longitude)) {
    this.geofence = geofence;
  }
}

class LongPressOptions extends LayerOptions {
  Function(LatLng) onLongPress;
  BuildContext context;
  LongPressOptions({this.context, this.onLongPress});
}

class LongPressPlugin implements MapPlugin {
  LatLng _latLng;

  @override
  Widget createLayer(LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is LongPressOptions) {

      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          Point origin = mapState.getPixelOrigin();
          RenderBox box = options.context.findRenderObject();
          Offset offset = box.globalToLocal(details.globalPosition);
          Point p = new Point(origin.x + offset.dx, origin.y + offset.dy);
          _latLng = mapState.layerPointToLatLng(p);
        },
        onLongPress: () {
          options.onLongPress(_latLng);
        }
      );
    }
    throw ("Unknown options type for MyCustom"
        "plugin: $options");
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is LongPressOptions;
  }
}

