part of '../flutter_background_geolocation.dart';

/// Describes a paged query for [BackgroundGeolocation.getLocations].
///
/// A locations read is a paging operation: fetch a bounded slice of the SDK's
/// SQLite database so a large table can be drained incrementally rather than
/// materialised all at once.  Unlike [SQLQuery] (a time-window query over the
/// log database), the vocabulary here is paging-first: [limit], [offset] (or the
/// 0-indexed [page] convenience), and [order].
///
/// ```dart
/// // Newest 500 records
/// List page = await BackgroundGeolocation.getLocations(LocationQuery(
///   limit: 500,
///   order: LocationQuery.ORDER_DESC
/// ));
///
/// // Drain the table one page at a time
/// int total = await BackgroundGeolocation.count;
/// for (int page = 0; page * 500 < total; page++) {
///   List records = await BackgroundGeolocation.getLocations(
///     LocationQuery(limit: 500, page: page)
///   );
///   // ...process records
/// }
/// ```
///
class LocationQuery {
  static const int ORDER_ASC = 1;
  static const int ORDER_DESC = -1;

  /// Maximum number of records to return.  Without a limit, every record is returned.
  int? limit;

  /// Number of records to skip before returning results (offset-based paging).
  /// An explicit offset takes precedence over [page].
  int? offset;

  /// Zero-indexed page number — a convenience over [offset] (`offset = page * limit`).
  /// Page `0` is the first page.  Requires [limit].
  int? page;

  /// Ordering of results: [LocationQuery.ORDER_ASC] or [LocationQuery.ORDER_DESC].
  /// Defaults to the configured `locationsOrderDirection`.
  int? order;

  LocationQuery({this.limit, this.offset, this.page, this.order});

  /// Return `Map` representation of `LocationQuery` for communication to the native platform.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> query = {};
    if (this.limit != null) query["limit"] = this.limit;
    if (this.offset != null) query["offset"] = this.offset;
    if (this.page != null) query["page"] = this.page;
    if (this.order != null) query["order"] = this.order;
    return query;
  }
}
