part of flt_background_geolocation;

/// Used for selecting a range of records from the SDK's database.  Used with the methods [Logger.getLog], [Logger.emailLog] and [Logger.uploadLog].
///
/// ```dart
/// // Constrain results between optionl start/end dates using a SQLQuery
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
/// Logger.uploadLog("http://my.server.com/users/123/logs", SQLQuery(
///   end: DateTime.parse('2019-10-21')
/// ));
///
/// // Select first 100 records from log
/// Logger.emailLog("foo@bar.com", SQLQuery(
///   order: SQLQuery.ORDER_ASC,
///   limit: 100
/// ));
///
/// // Select most recent 100 records from log
/// Logger.emailLog("foo@bar.com", SQLQuery(
///   order: SQLQuery.ORDER_DESC,
///   limit: 100
/// ));
/// ```
///
class SQLQuery {
  static const int ORDER_ASC = 1;
  static const int ORDER_DESC = -1;

  /// Start date of logs to select
  DateTime? start;

  /// End date of logs to select.
  DateTime? end;

  /// Limit number of records returned.
  int? limit;

  /// Ordering of results [SQLQuery.ORDER_ASC] or [SQLQuery.ORDER_DESC].
  int? order;

  SQLQuery({this.start, this.end, this.order, this.limit});

  /// Return `Map` representation of `SQLQuery` for communication to native platform.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> query = {};
    if (this.start != null) query["start"] = this.start!.millisecondsSinceEpoch;
    if (this.end != null) query["end"] = this.end!.millisecondsSinceEpoch;
    if (this.limit != null) query["limit"] = this.limit;
    if (this.order != null) query["order"] = this.order;
    return query;
  }
}
