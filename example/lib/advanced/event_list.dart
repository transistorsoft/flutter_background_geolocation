import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

/// Simple container class pushed onto ListView
class _Event {
  String name;
  String content;
  _Event(this.name, this.content);
}

class EventList extends StatefulWidget {
  @override
  State createState() => EventListState();
}

class EventListState extends State<EventList> with AutomaticKeepAliveClientMixin<EventList> {
  List<_Event> _events;

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();

    _events = [];

    // Listen to all of BackgroundGeolocation events and render to a ListView.
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      setState(() {
        _events.insert(0, _Event(bg.Event.LOCATION, location.toString(compact: true)));
      });
    }, (bg.LocationError error) {
      setState(() {
        _events.insert(0, _Event(bg.Event.LOCATION, error.toString()));
      });
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      setState(() {
        _events.insert(0, _Event(bg.Event.MOTIONCHANGE, location.toString(compact:true)));
      });
    });

    bg.BackgroundGeolocation.onActivityChange((bg.ActivityChangeEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.ACTIVITYCHANGE, event.toString()));
      });
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.PROVIDERCHANGE, event.toString()));
      });
    });

    bg.BackgroundGeolocation.onHttp((bg.HttpEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.HTTP, event.toString()));
      });
    });

    bg.BackgroundGeolocation.onEnabledChange((bool enabled) {
      if (!enabled) {
        _events.clear();
      }
      setState(() {
        _events.insert(0, _Event(bg.Event.ENABLEDCHANGE, '[EnabledChangeEvent enabled: $enabled]'));
      });
    });

    bg.BackgroundGeolocation.onConnectivityChange((bg.ConnectivityChangeEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.CONNECTIVITYCHANGE, event.toString()));
      });
    });

    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.HEARTBEAT, event.location.toString(compact: false)));
      });
    });

    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.GEOFENCE, event.toString(compact: false)));
      });
    });

    bg.BackgroundGeolocation.onGeofencesChange((bg.GeofencesChangeEvent event) {
      setState(() {
        _events.insert(0, _Event(bg.Event.GEOFENCESCHANGE, event.toString(compact: false)));
      });
    });

    bg.BackgroundGeolocation.onPowerSaveChange((bool enabled) {
      setState(() {
        _events.insert(0, _Event(bg.Event.POWERSAVECHANGE, 'Power-saving enabled: $enabled'));
      });
    });

    bg.BackgroundGeolocation.onSchedule((bg.State state) {
      setState(() {
        _events.insert(0, _Event(bg.Event.SCHEDULE, "enabled: ${state.enabled}"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Color.fromRGBO(20, 20, 20, 1.0),
        color: Colors.white,
        padding: EdgeInsets.all(5.0),
        child: ListView.builder(
            itemCount: _events.length,
            itemBuilder: (BuildContext context, int index) => InputDecorator(
                decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(left: 5.0, top: 0.0, bottom: 5.0),
                    isDense: true,
                    labelStyle: TextStyle(color: Colors.blue, fontSize: 24.0, fontWeight: FontWeight.bold),
                    labelText: _events[index].name,
                ),
                child: Text(_events[index].content, style: TextStyle(color: Colors.black, fontSize: 16.0))
            )
        )
    );
  }
}