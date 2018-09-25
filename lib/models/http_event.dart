part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onHttp].
///
/// # HTTP Features
///
/// ## JSON Request Templates
///
/// The plugin supports customizable JSON request schemas with the following config options:
///
/// | Option             | Type       | Default     | Description |
/// |--------------------|------------|-------------|-------------|
/// |[Config.httpRootProperty]  | `String`   | `location`  | The root key in the JSON to render records |
/// |[Config.locationTemplate]  | `String`   | `undefined` | Optional template to render [Location] data |
/// |[Config.geofenceTemplate]  | `String`   | `undefined` | Optional template to render [GeofenceEvent] data |
///
/// ### [Config.httpRootProperty]
///
/// Traditionally, the plugin had a hard-coded "Location Data Schema", where it automatically appended location-data to the `location` key in the JSON data, eg:
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   url: 'http://my_url',
///   params: {
///     myParams: {'foo': 'bar'}
///   }
/// ));
/// ```
///
/// ```dart
/// POST /my_url
/// {
///   "location": {  // <-- hardcoded "httpRootProperty"
///     "coords": {
///         "latitude": 23.23232323,
///         "longitude": 37.37373737
///     }
///   },
///   "myParams": {
///     "foo": "bar"
///   }
/// }
/// ```
///
/// With [Config.httpRootProperty], you can now customize this key:
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   url: 'http://my_url',
///   httpRootProperty: 'data',
///   params: {
///     myParams: {'foo': 'bar'}
///   }
/// ));
/// ```
///
/// ```dart
/// POST /my_url
/// {
///   "data": {  // <-- customizable "httpRootProperty"!
///     "coords": {
///         "latitude": 23.23232323,
///         "longitude": 37.37373737
///     }
///   },
///   "myParams": {
///     "foo": "bar"
///   }
/// }
/// ```
///
/// #### [Config.httpRootProperty]: "."
///
/// If you'd rather POST your data *as* the root of the JSON, use **[Config.httpRootProperty]: "."**:
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   url: 'http://my_url',
///   httpRootProperty: '.',
///   params: {
///     myParams: {'foo': 'bar'}
///   }
/// ))
/// ```
///
/// ```dart
/// POST /my_url
/// {
///   "coords": {  // <-- location data place *as* the root of the JSON
///       "latitude": 23.23232323,
///       "longitude": 37.37373737
///   },
///   "myParams": {
///     "foo": "bar"
///   }
/// }
/// ```
///
/// ### [Config.locationTemplate] & [Config.geofenceTemplate]
///
/// If you wish to provide your own custom HTTP JSON schema, you can configure distinct templates for both [Location] and [GeofenceEvent] data.  Evaluate variables in your template using Ruby `erb`-style tags:
///
/// ```erb
/// <%= variable_name %>
/// ```
///
/// ## Example:
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   url: 'http://my_url',
///   httpRootProperty: 'data',
///   params: {
///     myParams: {'foo': 'bar'}
///   },
///   locationTemplate: '{ "lat":<%= latitude %>, "lng":<%= longitude %> }',
///   extras: {
///     "location_extra_foo": "extra location data"
///   }
/// ))
/// ```
///
/// ```dart
/// POST /my_url
/// {
///   "data": {
///     "lat": 45.5192657,
///     "lng": -73.6169116,
///     "location_extra_foo": "extra location data"
///   },
///   "myParams": {
///     "foo": "bar"
///   }
/// }
/// ```
///
/// ### Template Tags
///
/// #### Common Tags
///
/// The following template tags are common to both **[Config.locationTemplate]** and **[Config.geofenceTemplate]**:
///
/// | Tag | Type | Description |
/// |-----|------|-------------|
/// | `latitude` | `Float` ||
/// | `longitude` | `Float` ||
/// | `speed` | `Float` | Meters|
/// | `heading` | `Float` | Degress|
/// | `accuracy` | `Float` | Meters|
/// | `altitude` | `Float` | Meters|
/// | `altitude_accuracy` | `Float` | Meters|
/// | `timestamp` | `String` |ISO-8601|
/// | `uuid` | `String` |Unique ID|
/// | `event` | `String` |`motionchange,geofence,heartbeat,providerchange`
/// | `odometer` | `Float` | Meters|
/// | `activity.type` | `String` | `still,on_foot,running,on_bicycle,in_vehicle,unknown`|
/// | `activity.confidence` | `Integer` | 0-100%|
/// | `battery.level` | `Float` | 0-100%|
/// | `battery.is_charging` | `Boolean` | Is device plugged in?|
///
/// #### Geofence Tags
///
/// The following template tags are specific to **[Config.geofenceTemplate]** only:
///
/// | Tag | Type | Description |
/// |-----|------|-------------|
/// | `geofence_identifier` | `String` | Which geofence?|
/// | `geofence_action` | `String` | `ENTER,EXIT,DWELL`|
///
/// #### Quoting String Values
///
/// You're completely responsible for `"quoting"` your own `String` values.  The following will generate a JSON parsing error:
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   locationTemplate: '{ "event":<%= event %> }',
/// ));
/// ```
///
/// In the logs, you'll find:
/// ```
/// ‼️-[TSLocation templateError:template:] locationTemplate error: Invalid value around character 10.
/// { "event":<%= event %> }
/// ```
///
/// To fix this, the `String` tag `<%= event %>` must be wrapped in `""`:
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   locationTemplate: '{ "event":"<%= event %>" }',
/// ));
/// ```
///
/// #### `bool`, `double` and `int` Values
///
/// `bool`, `double` and `int` values do **not** require quoting:
///
/// ```
/// BackgroundGeolocation.ready(Config(
///   locationTemplate: '{ "is_moving":<%= is_moving %>, "odometer":<%= odometer %> }',
/// ));
/// ```
///
/// #### Array Templates
///
/// You're not forced to define your templates as an **`{Object}`** &mdash; You can define them as an **`[Array]`** too.
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   url: 'http://my_url',
///   httpRootProperty: 'data',
///   params: {
///     myParams: {'foo': 'bar'}
///   },
///   locationTemplate: '[ <%= latitude %>, <%= longitude %> ]',
///   extras: {
///     "location_extra_foo": "extra location data"
///   }
/// ))
/// ```
///
/// ```dart
/// POST /my_url
/// {
///   "data": [
///     45.5192657,
///     -73.6169116,
///     {"location_extra_foo": "extra location data"}  // <-- appended #extras
///   ],
///   "myParams": {
///     "foo": "bar"
///   }
/// }
/// ```
///
/// :exclamation: `#extras` are automatically appened to the last element of the array as an `{Object}`.
///
/// #### Array Template with `httpRootProperty: "."`
///
/// :warning: This case is tricky and should probably be avoided, particularly if you have configured [Config.params], since there no place in the request JSON to append them.
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   url: 'http://my_url',
///   httpRootProperty: '.',
///   params: {
///     myParams: {'foo': 'bar'}
///   },
///   locationTemplate: '[<%=latitude%>, <%=longitude%>]',
///   extras: {
///     "location_extra_foo": "extra location data"
///   }
/// ))
/// ```
///
/// ```dart
/// - POST /my_url
///  [  // <-- #params are lost.  There's no place in the data-structure to append them.
///   45.5192657,
///   -73.6169116,
///   {
///     "location_extra_foo": "extra location data"
///   }
/// ]
/// ```

class HttpEvent {
  /// `true` if the HTTP response was successful (`200`, `201`, `204`).
  bool success;

  /// HTTP response status.
  int status;

  /// HTTP response text.
  String responseText;

  HttpEvent(dynamic params) {
    this.success = params['success'];
    this.status = params['status'];
    this.responseText = params['responseText'];
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'status': status,
      'responseText': (responseText.length > 100)
          ? (responseText.substring(0, 100) + '...')
          : responseText
    };
  }

  String toString() {
    return "[HttpEvent " + toMap().toString() + "]";
  }
}
