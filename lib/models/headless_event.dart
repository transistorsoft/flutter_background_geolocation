part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.registerHeadlessTask]
///
/// ## Example
/// __`main.dart`
///
/// ```dart
/// void myHeadlessTask(HeadlessEvent headlessEvent) async {
///   print('[HeadlessTask]: ${headlessEvent}');
///
///   // Implement a `case` for only those events you're interested in.
///   switch(headlessEvent.name) {
///     case bg.Event.TERMINATE:
///       bg.State state = headlessEvent.event;
///       print('- State: ${state}');
///       break;
///     case bg.Event.HEARTBEAT:
///       bg.HeartbeatEvent event = headlessEvent.event;
///       print('- HeartbeatEvent: ${event}');
///       break;
///     case bg.Event.LOCATION:
///       bg.Location location = headlessEvent.event;
///       print('- Location: ${location}');
///       break;
///     case bg.Event.MOTIONCHANGE:
///       bg.Location location = headlessEvent.event;
///       print('- Location: ${location}');
///       break;
///     case bg.Event.GEOFENCE:
///       bg.GeofenceEvent geofenceEvent = headlessEvent.event;
///       print('- GeofenceEvent: ${geofenceEvent}');
///       break;
///     case bg.Event.GEOFENCESCHANGE:
///       bg.GeofencesChangeEvent event = headlessEvent.event;
///       print('- GeofencesChangeEvent: ${event}');
///       break;
///     case bg.Event.SCHEDULE:
///       bg.State state = headlessEvent.event;
///       print('- State: ${state}');
///       break;
///     case bg.Event.ACTIVITYCHANGE:
///       bg.ActivityChangeEvent event = headlessEvent.event;
///       print('ActivityChangeEvent: ${event}');
///       break;
///     case bg.Event.HTTP:
///       bg.HttpEvent response = headlessEvent.event;
///       print('HttpEvent: ${response}');
///       break;
///     case bg.Event.POWERSAVECHANGE:
///       bool enabled = headlessEvent.event;
///       print('ProviderChangeEvent: ${enabled}');
///       break;
///     case bg.Event.CONNECTIVITYCHANGE:
///       bg.ConnectivityChangeEvent event = headlessEvent.event;
///       print('ConnectivityChangeEvent: ${event}');
///       break;
///     case bg.Event.ENABLEDCHANGE:
///       bool enabled = headlessEvent.event;
///       print('EnabledChangeEvent: ${enabled}');
///       break;
///     case bg.Event.NOTIFICATIONACTION:
///       String buttonId = headlessEvent.event;
///       print('NotificationAction: ${buttonId}');
///       break;
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
  late String name;

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
  /// | [Event.NOTIFICATIONACTION]   | `String buttonId`                     |
  ///
  dynamic event;

  HeadlessEvent(String name, dynamic params) {
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
          event = new ProviderChangeEvent(params);
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
        case Event.AUTHORIZATION:
          event = new AuthorizationEvent(params);
          break;
        case Event.NOTIFICATIONACTION:
          event = params;
          break;
      }
    } catch (e, stacktrace) {
      print('[HeadlessEvent] ‼️ ERROR DECODING EVENT $name: $e');
      print(params.toString());
      print(stacktrace);
    }
  }

  /// String representation of `HeadlessEvent` for `print` to logs.
  String toString() {
    return '[HeadlessEvent name: $name, event: $event]';
  }
}
