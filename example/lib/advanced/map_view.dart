import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
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

class MapViewState extends State<MapView> with AutomaticKeepAliveClientMixin<MapView> {
  static const LOCATION_ARROW_IMAGE_PATH = "assets/images/markers/location-arrow-blue.png";

  @override
  bool get wantKeepAlive {
    return true;
  }

  bg.Location? _stationaryLocation;
  bg.Location? _lastLocation;

  LatLng _currentPosition = LatLng(45.508888, -73.561668);
  List<LatLng> _polyline = [];
  List<Marker> _locations = [];
  List<CircleMarker> _stopLocations = [];
  List<Polyline> _motionChangePolylines = [];
  List<CircleMarker> _stationaryMarker = [];

  List<GeofenceMarker> _geofences = [];
  List<Polygon> _geofencePolygons = [];
  List<GeofenceMarker> _geofenceEvents = [];
  List<Marker> _geofenceEventEdges = [];
  List<Marker> _geofenceEventLocations = [];
  List<Polyline> _geofenceEventPolylines = [];
  List<Marker> _polygonGeofenceCursorMarkers = [];
  List<LatLng> _polygonGeofenceCursorPoints = [];

  bool _isCreatingPolygonGeofence = false;
  OverlayEntry? _polygonGeofenceMenuOverlay = null;

  LatLng _center = LatLng(45.508888, -73.561668);

  late MapController _mapController;
  late MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();
    _mapOptions = MapOptions(
        onPositionChanged: _onPositionChanged,
        center: _center,
        zoom: 12.0,
        onTap: _onTap,
        onLongPress: _onAddGeofence);
    _mapController = MapController();

    bg.BackgroundGeolocation.onLocation(_onLocation);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onGeofencesChange(_onGeofencesChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);
  }

  void _onEnabledChange(bool enabled) {
    if (!enabled) {
      setState(() {
        _locations.clear();
        _geofencePolygons.clear();
        _polyline.clear();
        _stopLocations.clear();
        _motionChangePolylines.clear();
        _stationaryMarker.clear();
        _geofenceEvents.clear();
        _geofenceEventPolylines.clear();
        _geofenceEventLocations.clear();
        _geofenceEventEdges.clear();
      });
    }
  }

  void _onMotionChange(bg.Location location) async {
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);

    _updateCurrentPositionMarker(ll);

    _mapController.move(ll, 16);

    // clear the big red stationaryRadius circle.
    _stationaryMarker.clear();

    if (location.isMoving) {
      if (_stationaryLocation == null) {
        _stationaryLocation = location;
      }
      // Add previous stationaryLocation as a small red stop-circle.
      _stopLocations.add(_buildStopCircleMarker(_stationaryLocation!));
      // Create the green motionchange polyline to show where tracking engaged from.
      _motionChangePolylines
          .add(_buildMotionChangePolyline(_stationaryLocation!, location));
    } else {
      // Save a reference to the location where we became stationary.
      _stationaryLocation = location;
      // Add the big red stationaryRadius circle.
      bg.State state = await bg.BackgroundGeolocation.state;
      setState(() {
        _stationaryMarker.add(_buildStationaryCircleMarker(location, state));
      });
    }
  }

  void _onGeofence(bg.GeofenceEvent event) async {
    bg.Logger.info('[onGeofence] Flutter received onGeofence event $event');
    // Provide the location of this event to the Polyline.  BGGeo does not fire an onLocation for geofence events.
    _polyline.add(LatLng(event.location.coords.latitude, event.location.coords.longitude));
    GeofenceMarker? marker = _geofences.firstWhereOrNull(
        (GeofenceMarker marker) => marker.geofence?.identifier == event.identifier);
    if (marker == null) {
      bool exists = await bg.BackgroundGeolocation.geofenceExists(event.identifier);
      if (exists) {
        // Maybe this is a boot from a geofence event and geofencechange hasn't yet fired
        bg.Geofence? geofence = await bg.BackgroundGeolocation.getGeofence(event.identifier);
        marker = GeofenceMarker(geofence!);
        _geofences.add(marker);
      } else {
        print(
            "[_onGeofence] failed to find geofence marker: ${event.identifier}");
        return;
      }
    }

    bg.Geofence? geofence = marker.geofence;

    // Render a new greyed-out geofence CircleMarker to show it's been fired but only if it hasn't been drawn yet.
    // since we can have multiple hits on the same geofence.  No point re-drawing the same hit circle twice.
    GeofenceMarker? eventMarker = _geofenceEvents.firstWhereOrNull(
        (GeofenceMarker marker) =>
            marker.geofence?.identifier == event.identifier);
    if (eventMarker == null)
      _geofenceEvents.add(GeofenceMarker(geofence!, true));

    // Build geofence hit statistic markers:
    // 1.  A computed CircleMarker upon the edge of the geofence circle (red=exit, green=enter)
    // 2.  A CircleMarker for the actual location of the geofence event.
    // 3.  A black PolyLine joining the two above.
    bg.Location location = event.location;
    LatLng center = LatLng(geofence!.latitude!, geofence!.longitude!);
    LatLng hit = LatLng(location.coords.latitude, location.coords.longitude);

    // Update current position marker.
    _updateCurrentPositionMarker(hit);
    // Determine bearing from center -> event location
    double bearing = Geospatial.getBearing(center, hit);
    // Compute a coordinate at the intersection of the line joining center point -> event location and the circle.
    LatLng edge = Geospatial.computeOffsetCoordinate(center, geofence.radius!, bearing);
    // Green for ENTER, Red for EXIT.
    Color color = Colors.green;
    var colorName = 'green';
    if (event.action == "EXIT") {
      color = Colors.red;
      colorName = 'red';
    } else if (event.action == "DWELL") {
      color = Colors.yellow;
      colorName = 'amber';
    }
    // Colored circular image marker (red/amber/green) on geofence edge.
    _geofenceEventEdges.add(Marker(point: edge, width: 16, height: 16, rotate: false, builder: (context) {
      return Image.asset("assets/images/markers/geofence-event-edge-circle-${event.action.toLowerCase()}.png");
    }));

    // Colored event location-arrow Marker (red/amber/green)
    double heading = location.coords.heading.round().toDouble();
    _geofenceEventLocations.add(Marker(point: hit, width: 24, height: 24, rotate: false, builder: (context) {
      return Transform.rotate(angle: (heading * (math.pi / 180)), child: Image.asset("assets/images/markers/location-arrow-${colorName}.png"));
    }));
    // Polyline joining the two above.
    _geofenceEventPolylines.add(Polyline(points: [edge, hit], strokeWidth: 2.0, color: Colors.black));
  }

  bool hasGeofenceMarker(String identifier) {
    return _geofences.firstWhereOrNull(
      (GeofenceMarker marker) => marker.geofence?.identifier == identifier
    ) != null;
  }

  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
    print('[${bg.Event.GEOFENCESCHANGE}] - $event');
    setState(() {
      event.off.forEach((String identifier) {
        _geofences.removeWhere((GeofenceMarker marker) {
          return marker.geofence?.identifier == identifier;
        });
      });

      event.on.forEach((bg.Geofence geofence) {
        // Don't re-render markers for existing geofences.
        if (hasGeofenceMarker(geofence.identifier)) return;
        _geofences.add(GeofenceMarker(geofence));

        if (geofence.vertices!.isNotEmpty) {
          _geofencePolygons.add(Polygon(
              borderColor: Colors.blue,
              borderStrokeWidth: 5.0,
              isDotted: true,
              label: geofence.identifier,
              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              color: Colors.blue.withOpacity(0.2),
              isFilled: true,
              points: geofence.vertices!.map((vertex) {
                return LatLng(vertex[0], vertex[1]);
              }).toList()
          ));
        }
      });

      if (event.off.isEmpty && event.on.isEmpty) {
        _geofences.clear();
        _geofencePolygons.clear();
      }
    });
  }

  void _onLocation(bg.Location location) {
    _lastLocation = location;
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);
    _mapController.move(ll, _mapController.zoom);

    _updateCurrentPositionMarker(ll);

    if (location.sample) {
      return;
    }

    // Add a point to the tracking polyline.
    _polyline.add(ll);
    // Add a marker for the recorded location.
    //_locations.add(_buildLocationMarker(location));
    //_locations.add(CircleMarker(point: ll, color: Colors.black, radius: 5.0));
    //_locations.add(CircleMarker(point: ll, color: Colors.blue, radius: 4.0));

    double heading = (location.coords.heading >= 0) ? location.coords.heading.round().toDouble() : 0;
    _locations.add(Marker(point: ll, width: 16, height: 16, rotate: false, builder: (context) {
      return Transform.rotate(angle: (heading * (math.pi / 180)), child: Image.asset(LOCATION_ARROW_IMAGE_PATH));
    }));
  }

  /// Update Big Blue current position dot.
  void _updateCurrentPositionMarker(LatLng ll) {
    setState(() {
      _currentPosition = ll;
    });
  /*
    // White background
    _currentPosition
        .add(CircleMarker(point: ll, color: Colors.white, radius: 10));
    // Blue foreground
    _currentPosition
        .add(CircleMarker(point: ll, color: Colors.blue, radius: 7));

   */
  }

  CircleMarker _buildStationaryCircleMarker(
      bg.Location location, bg.State state) {
    return CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Color.fromRGBO(255, 0, 0, 0.5),
        useRadiusInMeter: true,
        radius: (state.trackingMode == 1)
            ? 200
            : (state.geofenceProximityRadius! / 2));
  }

  Polyline _buildMotionChangePolyline(bg.Location from, bg.Location to) {
    return Polyline(points: [
      LatLng(from.coords.latitude, from.coords.longitude),
      LatLng(to.coords.latitude, to.coords.longitude)
    ], strokeWidth: 10.0, color: Color.fromRGBO(22, 190, 66, 0.7));
  }

  CircleMarker _buildStopCircleMarker(bg.Location location) {
    return CircleMarker(
        point: LatLng(location.coords.latitude, location.coords.longitude),
        color: Color.fromRGBO(200, 0, 0, 0.3),
        useRadiusInMeter: false,
        radius: 20);
  }

  void _onTap(pos, latLng) {
    if (!_isCreatingPolygonGeofence) return;
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("TEST_MODE_CLICK"));
    HapticFeedback.heavyImpact();
    int index = _polygonGeofenceCursorMarkers.length + 1;
    setState(() {
      _polygonGeofenceCursorPoints.add(latLng);
      _polygonGeofenceCursorMarkers.add(
          Marker(point: latLng, width: 20, height: 20, rotate:false, builder: (context) {
            return Container(
              child: Text("$index", style: TextStyle(color: Colors.white)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //border: Border.all(width: 2, color: Colors.white),
                shape: BoxShape.circle,
                color: Colors.black
              )
            );
          })
      );
    });
  }
  void _onAddGeofence(pos, latLng) {
    if (_isCreatingPolygonGeofence) return;
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("LONG_PRESS_ACTIVATE"));
    HapticFeedback.heavyImpact();
    print("[_onAddGgeofence] latLng: $latLng");

    showAdaptiveActionSheet(
      context: context,
      title: const Text('Add Geofence'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(title: const Text('Circular'), onPressed: (context) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute<Null>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return GeofenceView(center: latLng);
            })
          );
        }),
        BottomSheetAction(title: const Text('Polygon'), onPressed: (context) {
          setState(() {
            _isCreatingPolygonGeofence = true;
          });
          _showPolygonGeofenceMenu();
          Navigator.of(context).pop();
        })
      ],
      cancelAction: CancelAction(title: const Text('Cancel'), onPressed: (context) {
        Navigator.of(context).pop();
        _cancelAddGeofence();
      }),// onPressed parameter is optional by default will dismiss the ActionSheet
    );
    /*
    Navigator.of(context).push(MaterialPageRoute<Null>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return GeofenceView(latLng);
        }));

     */
  }
  void _showPolygonGeofenceMenu() {

    OverlayState overlayState = Overlay.of(context);
    if (_polygonGeofenceMenuOverlay == null) {
      _polygonGeofenceMenuOverlay = OverlayEntry(builder: (context) {
        return Positioned(
            top: 55,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black
                    )
                  )
                ),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(child: Text(
                              "Cancel", style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                              onPressed: _cancelAddGeofence
                          ),

                          //Text("Tap map to add points", style: TextStyle(fontWeight: FontWeight.bold)),
                          MaterialButton(child: Text(
                              "Next", style: TextStyle(color: Colors.white)),
                              color: Colors.blue,
                              onPressed: () {

                                var vertices = _polygonGeofenceCursorMarkers.map((Marker marker) {
                                  return marker.point;
                                }).toList();
                                _cancelAddGeofence();
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) {
                                      return GeofenceView(vertices: vertices);
                                    })
                                );
                              })
                        ]
                    ),
                    Row(
                      children: [
                        MaterialButton(child: Icon(Icons.undo), onPressed: () {
                          HapticFeedback.heavyImpact();
                          if (_polygonGeofenceCursorPoints.isEmpty) return;
                          setState(() {
                            _polygonGeofenceCursorPoints.removeLast();
                            _polygonGeofenceCursorMarkers.removeLast();
                          });
                        }),
                        Text("Click map to add polygon points", style: TextStyle(
                            fontFamily: "sans-serif",
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 12
                        ))
                      ]
                    )
                  ]
                )
            )
        );
      });
    }
    overlayState.insert(_polygonGeofenceMenuOverlay!);
  }
  void _cancelAddGeofence() {
    HapticFeedback.heavyImpact();
    if (_polygonGeofenceMenuOverlay != null) {
      _polygonGeofenceMenuOverlay?.remove();
    }
    setState(() {
      _polygonGeofenceCursorMarkers.clear();
      _polygonGeofenceCursorPoints.clear();
      _isCreatingPolygonGeofence = false;
    });
  }
  void _onPositionChanged(MapPosition pos, bool hasGesture) {
    _mapOptions.crs.scale(_mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          color: Color(0xfffff1a5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Long-press on map to add Geofences", style: TextStyle(color: Colors.black))
              ]
          )
        ),
        Expanded(
          child: FlutterMap(
              mapController: _mapController,
              options: _mapOptions,
              children: [
                TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                // Active geofence circles
                CircleLayer(circles: _geofences),
                PolygonLayer(polygons: _geofencePolygons),
                // Small, red circles showing where motionchange:false events fired.
                CircleLayer(circles: _stopLocations),
                // Big red stationary radius while in stationary state.
                CircleLayer(circles: _stationaryMarker),
                PolygonLayer(polygons: [
                  Polygon(
                      borderColor: Colors.blue,
                      borderStrokeWidth: 5.0,
                      isDotted: true,
                      label: "Click next to continue",
                      labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      color: Colors.blue.withOpacity(0.2),
                      isFilled: true,
                      points: _polygonGeofenceCursorPoints
                  )
                ]),
                MarkerLayer(markers: _polygonGeofenceCursorMarkers),
                // Recorded locations.
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _polyline,
                      strokeWidth: 10.0,
                      color: Color.fromRGBO(0, 179, 253, 0.6),
                    ),
                  ],
                ),
                // Polyline joining last stationary location to motionchange:true location.
                PolylineLayer(polylines: _motionChangePolylines),
                MarkerLayer(markers: _locations),
                CircleLayer(circles: _geofenceEvents),
                PolylineLayer(polylines: _geofenceEventPolylines),
                MarkerLayer(markers: _geofenceEventLocations),
                MarkerLayer(markers: _geofenceEventEdges),
                // Geofence events (edge marker, event location and polyline joining the two)
                CircleLayer(circles: [
                  // White background
                  CircleMarker(point: _currentPosition, color: Colors.white, radius: 10),
                  // Blue foreground
                  CircleMarker(point: _currentPosition, color: Colors.blue, radius: 7)
                ]),
              ]
          )
        )
      ]
    );
  }
}

class GeofenceMarker extends CircleMarker {
  bg.Geofence? geofence;
  GeofenceMarker(bg.Geofence geofence, [bool triggered = false])
      : super(
            useRadiusInMeter: true,
            radius: geofence.radius!,
            color: (triggered) ? Colors.transparent : Colors.green.withOpacity(0.3),
            borderColor: Colors.green,
            borderStrokeWidth: 1,
            point: LatLng(geofence.latitude!, geofence.longitude!)) {
    this.geofence = geofence;
  }
}
