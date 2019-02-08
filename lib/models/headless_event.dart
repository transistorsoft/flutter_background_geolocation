part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.registerHeadlessTask]
///
/// ## Example
/// __`main.dart`
///
/// ```dart
/// void myHeadlessTask(HeadlessEvent headlesseEvent) async {
///   String name = headlessEvent.name;
///
///
///   switch(name) {
///     case Event.TERMINATE:
///       break;
///     case Event.LOCATION:
///       break;
///     .
///     .
///     .
///   }
/// }
///
/// void main() {
///   runApp(HelloWorld());
///
///   // Register your headlessTask:
///   BackgroundGeolocation.registerHeadlessTask(myHeadlessTask);
/// }
/// ```
///
class HeadlessEvent {
  /// The name of the [Event]
  ///
  String name;

  /// The corresponding event-object.
  ///
  /// This `event` object can be cast according to those provided by [BackgroundGeolocation]'s primary event-listener'
  ///
  /// | Event `name`                 | `event` Class                         |
  /// |------------------------------|---------------------------------------|
  /// | [Event.BOOT]                 | [State]                               |
  /// | [Event.TERMINATE]            | [State]                               |
  /// | [Event.LOCATION]             | [Location]                            |
  /// | [Event.MOTIONCHANGE]         | [Location]                            |
  /// | [Event.HTTP]                 | [HttpEvent]                           |
  /// | [Event.ACTIVITYCHANGE]       | [ActivityChangeEvent]                 |
  /// | [Event.PROVIDERCHANGE]       | [ProviderChangeEvent]                 |
  /// | [Event.HEARTBEAT]            | [HeartbeatEvent]                      |
  /// | [Event.GEOFENCE]             | [GeofenceEvent]                       |
  /// | [Event.GEOFENCESCHANGE]      | [GeofencesChangeEvent]                |
  /// | [Event.SCHEDULE]             | [State]                               |
  /// | [Event.CONNECTIVITYCHANGE]   | [ConnectivityChangeEvent]             |
  /// | [Event.POWERSAVECHANGE]      | `bool enabled`                        |
  /// | [Event.ENABLEDCHANGE]        | `bool enabled`                        |
  ///
  dynamic event;

  HeadlessEvent(String name, Map params) {
    this.name = name;

    try {
      switch (name) {
        case Event.TERMINATE:
        case Event.SCHEDULE:
        case Event.BOOT:
          event = new State(params);
          break;
        case Event.LOCATION:
          event = new Location(params);
          break;
        case Event.MOTIONCHANGE:
          event = new Location(params['location']);
          break;
        case Event.ACTIVITYCHANGE:
          event =
              new ActivityChangeEvent(params['activity'], params['confidence']);
          break;
        case Event.GEOFENCE:
          event = new GeofenceEvent(params);
          break;
        case Event.GEOFENCESCHANGE:
          event = new GeofencesChangeEvent(params['on'], params['off']);
          break;
        case Event.HEARTBEAT:
          event = new HeartbeatEvent(params);
          break;
        case Event.HTTP:
          event = new HttpEvent(params);
          break;
        case Event.PROVIDERCHANGE:
          event = new ProviderChangeEvent(params['enabled'], params['status'],
              params['network'], params['gps']);
          break;
        case Event.CONNECTIVITYCHANGE:
          event = new ConnectivityChangeEvent(params['connected']);
          break;
        case Event.ENABLEDCHANGE:
          event = params;
          break;
        case Event.POWERSAVECHANGE:
          event = params;
          break;
      }
    } catch (e, stacktrace) {
      print('[HeadlessEvent] ‼️ ERROR DECODING EVENT $name: $e');
      print(params.toString());
      print(stacktrace);
    }
  }

  String toString() {
    return '[HeadlessEvent name: $name, event: $event]';
  }
}
