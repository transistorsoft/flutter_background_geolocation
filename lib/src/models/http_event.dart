part of flt_background_geolocation;

class HttpEvent {
  bool success;
  int status;
  String responseText;

  HttpEvent(dynamic params) {
    this.success = params['success'];
    this.status = params['status'];
    this.responseText = params['responseText'];
  }

  Map<String,dynamic> toMap() {
    return {
      'success': success,
      'status': status,
      'responseText': responseText
    };
  }
}