part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onHttp].
///
class HttpEvent {
  bool success;
  int status;
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
