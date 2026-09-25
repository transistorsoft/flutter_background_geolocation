// (WO-049) Location.geofence is the trigger summary both native cores attach to a geofence-type
// location (identifier, action, timestamp, extras?), never a GeofenceEvent: it has no location
// inside. And State stops offering reset / transistorAuthorizationToken, which no native State
// carries.
// ignore_for_file: deprecated_member_use
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_test/flutter_test.dart';

const _timestamp = '2026-09-24T12:00:00.000Z';

/// The summary TSLocation attaches to a geofence-type location, typed the way the platform
/// channel delivers it.
Map<Object?, Object?> trigger() => <Object?, Object?>{
      'identifier': 'lab-fence-here',
      'action': 'ENTER',
      'timestamp': _timestamp,
      'extras': <Object?, Object?>{'zone': 'A'},
    };

/// A geofence-type location, as onGeofence delivers it and getLocations() returns it.
Map<Object?, Object?> geofenceLocation() => <Object?, Object?>{
      'uuid': 'b8f4a3c2-0000-4000-8000-000000000049',
      'timestamp': _timestamp,
      'event': 'geofence',
      'is_moving': false,
      'odometer': 0,
      'coords': <Object?, Object?>{
        'latitude': 45.5,
        'longitude': -73.6,
        'accuracy': 5.0,
      },
      'activity': <Object?, Object?>{'type': 'still', 'confidence': 100},
      'battery': <Object?, Object?>{'level': 0.5, 'is_charging': false},
      'geofence': trigger(),
    };

Map<Object?, Object?> onGeofencePayload() => <Object?, Object?>{
      'identifier': 'lab-fence-here',
      'action': 'ENTER',
      'timestamp': _timestamp,
      'location': geofenceLocation(),
      'geofence': <Object?, Object?>{
        'identifier': 'lab-fence-here',
        'radius': 200.0,
        'latitude': 45.5,
        'longitude': -73.6,
        'notifyOnEntry': true,
        'notifyOnExit': true,
        'notifyOnDwell': false,
        'loiteringDelay': 0,
      },
    };

void main() {
  test('WO-049 Location(record) of a geofence record builds a GeofenceTrigger', () {
    // A getLocations() record: before WO-049 this threw inside GeofenceEvent(), which read a
    // `location` the summary does not have.
    final bg.Location location = bg.Location(geofenceLocation());
    final bg.GeofenceTrigger g = location.geofence!;
    expect(g.identifier, 'lab-fence-here');
    expect(g.action, 'ENTER');
    expect(g.timestamp, _timestamp);
    expect(g.extras, {'zone': 'A'});
  });

  test("WO-049 GeofenceEvent keeps its location's geofence", () {
    final bg.GeofenceEvent event = bg.GeofenceEvent(onGeofencePayload());
    expect(event.location.geofence?.identifier, 'lab-fence-here');
    expect(event.location.geofence?.action, 'ENTER');
    // The channel map is no longer mutated; the lab driver reports event.location.map.
    expect((event.location.map as Map).containsKey('geofence'), isTrue);
    // The event's own fields and full Geofence record are unchanged.
    expect(event.identifier, 'lab-fence-here');
    expect(event.geofence.identifier, 'lab-fence-here');
  });

  test('WO-049 GeofenceTrigger tolerates a null action and absent keys', () {
    // Android sends "action": null for an unknown transition; iOS omits a key it has no value for.
    final bg.GeofenceTrigger g =
        bg.GeofenceTrigger(<Object?, Object?>{'identifier': 'x', 'action': null});
    expect(g.identifier, 'x');
    expect(g.action, '');
    expect(g.timestamp, '');
    expect(g.extras, isNull);

    final bg.GeofenceTrigger empty = bg.GeofenceTrigger(null);
    expect(empty.identifier, '');
  });

  test('WO-049 a location recorded without a geofence has none', () {
    final Map<Object?, Object?> record = geofenceLocation()
      ..remove('geofence')
      ..['event'] = '';
    expect(bg.Location(record).geofence, isNull);
  });

  test('WO-049 State carries neither reset nor transistorAuthorizationToken', () {
    final bg.State state = bg.State(<Object?, Object?>{
      'enabled': false,
      'isMoving': false,
      'schedulerEnabled': false,
      'trackingMode': 1,
      'odometer': 0,
      'isFirstBoot': false,
    });
    expect(state.reset, isNull);
    expect(state.transistorAuthorizationToken, isNull);

    // Still a Config: the deprecated members forward, so a State passed to setConfig() behaves
    // as before.
    final bg.Config config = state;
    expect(config.toMap()!.containsKey('reset'), isFalse);
    state.reset = false;
    expect(config.toMap()!['reset'], false);
  });
}
