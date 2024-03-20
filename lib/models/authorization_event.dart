part of '../flutter_background_geolocation.dart';

/// Event object provided to [BackgroundGeolocation.onAuthorization].
///
class AuthorizationEvent {
  /// HTTP Status returned from your [Authorization.refreshURl] (or `0` if the HTTP request failed).
  late int status;

  /// `true` when an authorization request to [Authorization.refreshUrl] was successful.
  ///
  late bool success;

  /// When [success] `false`, this is the error message from [Authorization.refreshUrl].
  String? error;

  /// when [success] `true`, this is the data returned from [Authorization.refreshUrl].
  Map? response;

  AuthorizationEvent(Map data) {
    status = _ensureInt(data['status'])!;
    success = _ensureBool(data['success'])!;
    error = data['error'];
    response = data['response'];
  }

  String toString() {
    return "[AuthorizationEvent success=$success, status=$status error=$error, response=$response]";
  }
}
