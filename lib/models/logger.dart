part of flt_background_geolocation;

/// # Logger API
///
/// The Background Geolocation SDK includes powerful logging features for debugging location-tracking problems.  The SDK stores log-entries for a period of [Config.logMaxDays] (default `3`).  The volume of logging events
/// inserted into the database is controlled via [Config.logLevel].
///
/// ## Fetching the Logs:
///
/// Logs can be fetched from the SDK in three ways:
/// 1.  [getLog]
/// 2.  [emailLog]
/// 3.  [uploadLog]
///
/// ## Inserting your own log messages
///
/// You can even insert your own log messages into the SDK's Log database using the following methods:
///
/// | method     | logLevel | icon            |
/// |------------|----------|-----------------|
/// |[error]     |`ERROR`   | ❗️             |
/// |[warn]      |`WARNING` | ⚠️             |
/// |[debug]     |`DEBUG`   | 🐞              |
/// |[info]      |`INFO`    | ℹ️              |
/// |[notice]    |`INFO`    | 🔵              |
///
/// ```dart
/// BackgroundGeolocation.onLocation((Location location) {
///   Logger.debug("Location received: $location");
/// });
/// ```
///
/// ## Example Logs
/// ```
/// 09-19 11:12:18.716 ╔═════════════════════════════════════════════
/// 09-19 11:12:18.716 ║ BackgroundGeolocation Service started
/// 09-19 11:12:18.716 ╠═════════════════════════════════════════════
/// 09-19 11:12:18.723 [c.t.l.BackgroundGeolocationService d]
/// 09-19 11:12:18.723   ✅  Started in foreground
/// 09-19 11:12:18.737 [c.t.l.ActivityRecognitionService a]
/// 09-19 11:12:18.737   🎾  Start activity updates: 10000
/// 09-19 11:12:18.761 [c.t.l.BackgroundGeolocationService k]
/// 09-19 11:12:18.761   🔴  Stop heartbeat
/// 09-19 11:12:18.768 [c.t.l.BackgroundGeolocationService a]
/// 09-19 11:12:18.768   🎾  Start heartbeat (60)
/// 09-19 11:12:18.778 [c.t.l.BackgroundGeolocationService a]
/// 09-19 11:12:18.778   🔵  setPace: null → false
/// 09-19 11:12:18.781 [c.t.l.adapter.TSConfig c] ℹ️   Persist config
/// 09-19 11:12:18.794 [c.t.locationmanager.util.b a]
/// 09-19 11:12:18.794   ℹ️  LocationAuthorization: Permission granted
/// 09-19 11:12:18.842 [c.t.l.http.HttpService flush]
/// 09-19 11:12:18.842 ╔═════════════════════════════════════════════
/// 09-19 11:12:18.842 ║ HTTP Service
/// 09-19 11:12:18.842 ╠═════════════════════════════════════════════
/// 09-19 11:12:19.000 [c.t.l.BackgroundGeolocationService onActivityRecognitionResult] still (100%)
/// 09-19 11:12:21.314 [c.t.l.l.SingleLocationRequest$2 onLocationResult]
/// 09-19 11:12:21.314 ╔═════════════════════════════════════════════
/// 09-19 11:12:21.314 ║ SingleLocationRequest: 1
/// 09-19 11:12:21.314 ╠═════════════════════════════════════════════
/// 09-19 11:12:21.314 ╟─ 📍  Location[fused 45.519239,-73.617058 hAcc=15]999923706055 vAcc=2 sAcc=??? bAcc=???
/// 09-19 11:12:21.327 [c.t.l.l.TSLocationManager onSingleLocationResult]
/// 09-19 11:12:21.327   🔵  Acquired motionchange position, isMoving: false
/// 09-19 11:12:21.342 [c.t.l.l.TSLocationManager a] 15.243
/// 09-19 11:12:21.405 [c.t.locationmanager.data.a.c persist]
/// 09-19 11:12:21.405   ✅  INSERT: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
/// 09-19 11:12:21.423 [c.t.l.http.HttpService flush]
/// 09-19 11:12:21.423 ╔═════════════════════════════════════════════
/// 09-19 11:12:21.423 ║ HTTP Service
/// 09-19 11:12:21.423 ╠═════════════════════════════════════════════
/// 09-19 11:12:21.446 [c.t.locationmanager.data.a.c first]
/// 09-19 11:12:21.446   ✅  Locked 1 records
/// 09-19 11:12:21.454 [c.t.l.http.HttpService a]
/// 09-19 11:12:21.454   🔵  HTTP POST: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
/// 09-19 11:12:22.083 [c.t.l.http.HttpService$a onResponse]
/// 09-19 11:12:22.083   🔵  Response: 200
/// 09-19 11:12:22.100 [c.t.locationmanager.data.a.c destroy]
/// 09-19 11:12:22.100   ✅  DESTROY: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
/// 09-19 11:12:55.226 [c.t.l.BackgroundGeolocationService onActivityRecognitionResult] still (100%)
/// ```
///

class Logger {
  static const String _LOG_LEVEL_DEBUG = "debug";
  static const String _LOG_LEVEL_ERROR = "error";
  static const String _LOG_LEVEL_WARN = "warn";
  static const String _LOG_LEVEL_INFO = "info";
  static const String _LOG_LEVEL_NOTICE = "notice";

  /// Inserts a debug log message into the SDK's log database
  ///
  /// ## Example
  /// ```dart
  /// Logger.debug("This is a debug message");
  /// ```
  ///
  /// ```
  /// D TSLocationManager: [c.t.l.logger.TSLog log] This is a debug message
  /// ```
  ///
  static Future<void> debug(String msg) {
    return _log(_LOG_LEVEL_DEBUG, msg);
  }

  /// Inserts an "error" log message into the SDK's log database
  ///
  /// ## Example
  /// ```dart
  /// Logger.error("Something BAD");
  /// ```
  /// ```
  /// E TSLocationManager: [c.t.l.logger.TSLog log]
  /// E TSLocationManager: ‼ Something BAD
  /// ```
  ///
  static Future<void> error(String msg) {
    return _log(_LOG_LEVEL_ERROR, msg);
  }

  /// Inserts a "warning" log message into the SDK's log database
  ///
  /// ## Example
  /// ```dart
  /// Logger.warn("Something WEIRD");
  /// ```
  /// ```
  /// E TSLocationManager: [c.t.l.logger.TSLog log]
  /// E TSLocationManager: ⚠️  Something WEIRD
  /// ```
  ///
  static Future<void> warn(String msg) {
    return _log(_LOG_LEVEL_WARN, msg);
  }

  /// Inserts an "info" log message into the SDK's log database
  ///
  /// ## Example
  /// ```dart
  /// Logger.info("Something informative");
  /// ```
  /// ```
  /// E TSLocationManager: [c.t.l.logger.TSLog log]
  /// I TSLocationManager:   ℹ️  Something informative
  /// ```
  ///
  static Future<void> info(String msg) {
    return _log(_LOG_LEVEL_INFO, msg);
  }

  /// Inserts a "notice" log message into the SDK's log database
  ///
  /// ## Example
  /// ```dart
  /// Logger.notice("A Notice");
  /// ```
  /// ```
  /// E TSLocationManager: [c.t.l.logger.TSLog log]
  /// I TSLocationManager:   🔵  A Notide3
  /// ```
  ///
  static Future<void> notice(String msg) {
    return _log(_LOG_LEVEL_NOTICE, msg);
  }

  static Future<void> _log(String level, String msg) async {
    return await _methodChannel.invokeMethod('log', [level, msg]);
  }

  /// Returns the contents of the log database as a `String`.  Provide an optional [SQLQuery] to contrain results between dates.
  ///
  /// Depending on the configured [Config.logLevel], the plugin can store an *immense* amount of helpful logging information for debugging location-tracking problems.
  ///
  /// See also:
  /// - [Config.logMaxDays] (default `3` days)
  /// - [Config.logLevel]   (default [Config.LOG_LEVEL_OFF])
  /// - [emailLog]
  /// - [uploadLog]
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Fetch entire contents of log.
  /// String log = await Logger.getLog();
  /// // Warning:  this string could be several megabytes.
  /// print('[log] success: ${log}');
  ///
  /// // Or constrain results between optionl start/end dates using a SQLQuery
  /// String log = await Logger.getLog(SQLQuery(
  ///   start: DateTime.parse('2019-10-21 13:00'),  // <-- optional HH:mm:ss
  ///   end: DateTime.parse('2019-10-22')
  /// ));
  ///
  /// // Or just a start date
  /// String log = await Logger.getLog(SQLQuery(
  ///   start: DateTime.parse('2019-10-21 13:00')
  /// ));
  ///
  /// // Or just an end date
  /// String log = await Logger.getLog(SQLQuery(
  ///   end: DateTime.parse('2019-10-21')
  /// ));
  /// ```
  /// ## Example log data:
  ///
  ///```
  /// 09-19 11:12:18.716 ╔═════════════════════════════════════════════
  /// 09-19 11:12:18.716 ║ BackgroundGeolocation Service started
  /// 09-19 11:12:18.716 ╠═════════════════════════════════════════════
  /// 09-19 11:12:18.723 [c.t.l.BackgroundGeolocationService d]
  /// 09-19 11:12:18.723   ✅  Started in foreground
  /// 09-19 11:12:18.737 [c.t.l.ActivityRecognitionService a]
  /// 09-19 11:12:18.737   🎾  Start activity updates: 10000
  /// 09-19 11:12:18.761 [c.t.l.BackgroundGeolocationService k]
  /// 09-19 11:12:18.761   🔴  Stop heartbeat
  /// 09-19 11:12:18.768 [c.t.l.BackgroundGeolocationService a]
  /// 09-19 11:12:18.768   🎾  Start heartbeat (60)
  /// 09-19 11:12:18.778 [c.t.l.BackgroundGeolocationService a]
  /// 09-19 11:12:18.778   🔵  setPace: null → false
  /// 09-19 11:12:18.781 [c.t.l.adapter.TSConfig c] ℹ️   Persist config
  /// 09-19 11:12:18.794 [c.t.locationmanager.util.b a]
  /// 09-19 11:12:18.794   ℹ️  LocationAuthorization: Permission granted
  /// 09-19 11:12:18.842 [c.t.l.http.HttpService flush]
  /// 09-19 11:12:18.842 ╔═════════════════════════════════════════════
  /// 09-19 11:12:18.842 ║ HTTP Service
  /// 09-19 11:12:18.842 ╠═════════════════════════════════════════════
  /// 09-19 11:12:19.000 [c.t.l.BackgroundGeolocationService onActivityRecognitionResult] still (100%)
  /// 09-19 11:12:21.314 [c.t.l.l.SingleLocationRequest$2 onLocationResult]
  /// 09-19 11:12:21.314 ╔═════════════════════════════════════════════
  /// 09-19 11:12:21.314 ║ SingleLocationRequest: 1
  /// 09-19 11:12:21.314 ╠═════════════════════════════════════════════
  /// 09-19 11:12:21.314 ╟─ 📍  Location[fused 45.519239,-73.617058 hAcc=15]999923706055 vAcc=2 sAcc=??? bAcc=???
  /// 09-19 11:12:21.327 [c.t.l.l.TSLocationManager onSingleLocationResult]
  /// 09-19 11:12:21.327   🔵  Acquired motionchange position, isMoving: false
  /// 09-19 11:12:21.342 [c.t.l.l.TSLocationManager a] 15.243
  /// 09-19 11:12:21.405 [c.t.locationmanager.data.a.c persist]
  /// 09-19 11:12:21.405   ✅  INSERT: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
  /// 09-19 11:12:21.423 [c.t.l.http.HttpService flush]
  /// 09-19 11:12:21.423 ╔═════════════════════════════════════════════
  /// 09-19 11:12:21.423 ║ HTTP Service
  /// 09-19 11:12:21.423 ╠═════════════════════════════════════════════
  /// 09-19 11:12:21.446 [c.t.locationmanager.data.a.c first]
  /// 09-19 11:12:21.446   ✅  Locked 1 records
  /// 09-19 11:12:21.454 [c.t.l.http.HttpService a]
  /// 09-19 11:12:21.454   🔵  HTTP POST: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
  /// 09-19 11:12:22.083 [c.t.l.http.HttpService$a onResponse]
  /// 09-19 11:12:22.083   🔵  Response: 200
  /// 09-19 11:12:22.100 [c.t.locationmanager.data.a.c destroy]
  /// 09-19 11:12:22.100   ✅  DESTROY: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
  /// 09-19 11:12:55.226 [c.t.l.BackgroundGeolocationService onActivityRecognitionResult] still (100%)
  ///```
  ///
  static Future<String> getLog([SQLQuery? query]) async {
    query = (query != null) ? query : new SQLQuery();
    return await (_methodChannel.invokeMethod<String>('getLog', query.toMap()))
        as FutureOr<String>;
  }

  /// Email the result of [getLog] using device's mail client.  Provide an optional [SQLQuery] to contrain results between dates.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Logger.emailLog('foo@bar.com').then((bool success) {
  ///   print('[emailLog] success');
  /// }).catchError((error) {
  ///   print('[emailLog] FAILURE: ${error}');
  /// });
  ///
  /// // Or constrain results by providing a [SQLQuery]:
  /// Logger.emailLog('foo@bar.com', SQLQuery(
  ///   start: DateTime.parse('2019-10-20 09:00'),
  ///   end: DateTime.parse('2019-10-20 11:59')
  /// )).then((bool success) {
  ///   print('[emailLog] success');
  /// }).catchError((error) {
  ///   print('[emailLog] FAILURE: ${error}');
  /// });
  /// ```
  ///
  static Future<bool> emailLog(String email, [SQLQuery? query]) async {
    query = (query != null) ? query : new SQLQuery();
    return await (_methodChannel.invokeMethod<bool?>(
        'emailLog', [email, query.toMap()])) as FutureOr<bool>;
  }

  /// Upload the result of [getLog] to provided url.  Provide an optional [SQLQuery] to contrain results between dates.  The file-upload
  /// request will attach your configured [Config.headers] for authentication.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Logger.uploadLog('https://my.server.com/users/123/logs').then((bool success) {
  ///   print('[uploadLog] success');
  /// }).catchError((error) {
  ///   print('[uploadLog] FAILURE: ${error}');
  /// });
  ///
  /// // Or constrain results by providing a [SQLQuery]:
  /// Logger.uploadLog('https://my.server.com/users/123/logs', SQLQuery(
  ///   start: DateTime.parse('2019-10-20 09:00'),
  ///   end: DateTime.parse('2019-10-20 11:59')
  /// )).then((bool success) {
  ///   print('[uploadLog] success');
  /// }).catchError((error) {
  ///   print('[uploadLog] FAILURE: ${error}');
  /// });
  /// ```
  ///
  /// ## MultiPart File Upload
  /// The SDK will upload the gzipped log-file to your server as a *Multi-part* file upload, the same log-file as used in [emailLog].  This is what I see with my [Node server](https://github.com/transistorsoft/background-geolocation-console) at `request.files`:
  ///
  /// ```javascript
  /// app.post('/log', async function(req, res) {
  ///   console.log('[body]: ', req.body);
  ///   console.log('[files]: ', req.files);
  ///   res.status(200).send();
  /// });
  /// ```
  /// ![](https://dl.dropbox.com/s/cn86cu0vieor0j4/uploadLog-npm-server-request.png?dl=1)
  ///
  /// ## Form Part
  ///
  /// In addition to the log-file, the SDK will upload a form as well, containing the following parameters:
  ///
  /// | Key                 | Value                                                            |
  /// |--------------|------------------------------------------|
  /// | **`state`**    | *JSON-encoded result of SDK's `#getState`*|
  /// | **`model`** | *Device model* |
  /// | **`manufacturer`** | *Device manufacturer* |
  /// | **`platform`** | *iOS or Android* |
  /// | **`version`** | *OS version* |
  ///
  static Future<bool> uploadLog(String url, [SQLQuery? query]) async {
    query = (query != null) ? query : new SQLQuery();
    return await (_methodChannel.invokeMethod<bool>(
        'uploadLog', [url, query.toMap()])) as FutureOr<bool>;
  }

  /// Destroy the entire contents of plugin's log database.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Logger.destroyLog();
  /// ```
  ///
  static Future<bool> destroyLog() async {
    return await (_methodChannel.invokeMethod<bool>('destroyLog'))
        as FutureOr<bool>;
  }
}
