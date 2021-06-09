part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onAuthorization].
///
class AuthorizationEvent {
  /// `true` when an authorization request to [Authorization.refreshUrl] was successful.
  ///
  late bool success;

  /// When [success] `false`, this is the error message from [Authorization.refreshUrl].
  String? error;

  /// when [success] `true`, this is the data returned from [Authorization.refreshUrl].
  Map? response;

  AuthorizationEvent(Map data) {
    success = _ensureBool(data['success'])!;
    error = data['error'];
    response = data['response'];
  }

  String toString() {
    return "[AuthorizationEvent success=$success, error=$error, response=$response]";
  }
}
