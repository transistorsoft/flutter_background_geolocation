part of flt_background_geolocation;

class Error {
  /// Error code
  late int code;

  /// Error message
  late String message;

  Error(PlatformException e) {
    code = int.parse(e.code);
    message = e.message ?? "";
  }

  /// String representation of `Location` for `print` to logs.
  String toString() {
    return '[Error code: $code, message: $message]';
  }
}
