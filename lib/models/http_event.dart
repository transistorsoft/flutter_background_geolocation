part of '../flutter_background_geolocation.dart';

/// Event object provided to [BackgroundGeolocation.onHttp].
///
/// ## Example
///
/// ```dart
/// BackgroundGeolocation.onHttp((HttpEvent response) {
///   print('[http] success? ${response.success}, status? ${response.status}');
/// });
/// ```
/// - See [HttpConfig] for a detailed description of HTTP Features.
///
class HttpEvent {
  /// `true` if the HTTP response was successful (`200`, `201`, `204`).
  late bool success;

  /// HTTP response status.
  late int status;

  /// HTTP response text.
  late String responseText;

  HttpEvent(dynamic params) {
    this.success = params['success'];
    this.status = params['status'];
    this.responseText = params['responseText'];
  }

  /// `Map` representation of `HttpEvent`.
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'status': status,
      'responseText': (responseText.length > 100)
          ? (responseText.substring(0, 100) + '...')
          : responseText
    };
  }

  /// String representation of `HttpEvent` for `print` to logs.
  String toString() {
    return "[HttpEvent " + toMap().toString() + "]";
  }
}
