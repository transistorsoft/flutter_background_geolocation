part of flt_background_geolocation;

/// Configures the SDK for authorization wtih your server's [accessToken] token (eg: [JSON Web Token](https://jwt.io/)) and automatically requests new tokens when server returns HTTP status `"401 Unauthorized"`.
///
/// __Note:__ Only *[JSON Web Token](https://jwt.io/)* (JWT) is currently supported.
///
/// The SDK will automatically apply the configured [accessToken] to each HTTP request's `Authorization` header, eg:
///
/// `"Authorization": "Bearer XXX.YYY.ZZZ"`
///
/// When using [Config.authorization], you do **not** need to manually configure [Config.headers] with the `Authorization` parameter.  It is all **automatic**.
///
/// If provided with [refreshUrl], [refreshToken] and [refreshPayload], the SDK can automatically re-register for a new token after expiration, such as when an HTTP response `401 Unauthorized` is received.
///
/// ## Configuration
///
/// ## Example
///
/// ```dart
/// Map myToken = this.getMyAuthorizationToken();
///
/// BackgroundGeolocation.onAuthorization((AuthorizationEvent event) {
///   if (event.success) {
///     print("[authorization] SUCCESS: ${event.response}");
///   } else {
///     print("[authorization] ERROR: ${event.error}");
///   }
/// });
///
/// BackgroundGeolocation.ready(Config(
///   url: "https://app.your.server.com/users/locations",
///   autoSync: true,
///   authorization: Authorization(
///     strategy: "JWT",
///     accessToken: myToken["accessToken"],
///     refreshToken: myToken["refreshToken"]
///     refreshUrl: "https://auth.your.server.com/tokens",
///     refreshPayload: {
///       "the_refresh_token_field_name": "{refreshToken}"
///     },
///     expires: myToken["expiresAt"]
///   )
/// ));
/// ```
///
/// ## Receiving the Response from [refreshUrl].
///
/// Whenever a response is received from [refreshUrl], the SDK will fire the [BackgroundGeolocation.onAuthorization] event.  Your callback will be provided an [AuthorizationEvent].  Check [AuthorizationEvent.success]:
/// - When successful, [AuthorizationEvent.response] will contain the decoded JSON from [refreshUrl].
/// - When a failure occurs, [AuthorizationEvent.error] will contain an error message.
///
/// ## Example
///
/// ```dart
/// BackgroundGeolocation.onAuthorization((AuthorizationEvent event) {
///   if (event.success) {
///     print("[authorization] SUCCESS: ${event.response}");
///   } else {
///     print("[authorization] ERROR: ${event.error}");
///   }
/// });
/// ```
///
class Authorization {
  static const String _STRATEGY = "strategy";
  static const String _ACCESS_TOKEN = "accessToken";
  static const String _REFRESH_URL = "refreshUrl";
  static const String _REFRESH_TOKEN = "refreshToken";
  static const String _REFRESH_PAYLOAD = "refreshPayload";
  static const String _REFRESH_HEADERS = "refreshHeaders";
  static const String _EXPIRES = "expires";

  static const String STRATEGY_JWT = "jwt";

  /// Authorization strategy.  Only [JWT](https://jwt.io/) is currently supported.
  String? strategy = STRATEGY_JWT;

  /// Authorization token (eg: [JWT](https://jwt.io/)) required for authorization by your server at [Config.url].
  ///
  /// The SDK will automatically apply the configured `accessToken` to each HTTP request's `Authorization` header, eg:
  ///
  /// `"Authorization": "Bearer XXX.YYY.ZZZ"`
  ///
  /// You do **not** need to manually configure [Config.headers] with the `Authorization` parameter.  It is all **automatic**.
  String? accessToken;

  /// The url to your authorization server that provides new [accessToken] when expired.
  ///
  /// When the SDK receives a response the server, it will decode the JSON and recursively iterate through the keys, performing regular expressions and other String-analysis *to "taste"* the data in search of the following 3 items:
  ///
  /// 1. "access token"
  /// 2. "refresh token"
  /// 3. "expiry time"
  ///
  /// The SDK is designed to operate with *any* response data-structure.  For example, one authorization server might return a complex response such as:
  ///
  /// ```json
  /// {
  ///   "token": {
  ///     "access_token": "XXX.YYY.ZZZ",
  ///     "expires_at": 3900
  ///   },
  ///   "refresh_token": "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb"
  /// }
  /// ```
  ///
  /// While another server might return a flat response, such as:
  ///
  /// ```json
  /// {
  ///  "accessToken": "XXX.YYY.ZZZ",
  ///  "refreshToken": "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb",
  ///  "expiry": 3900
  /// }
  /// ```
  ///
  /// When the response from the server is received, the event [BackgroundGeolocation.onAuthorization] will be fired, provided with the [AuthorizationEvent].
  ///
  String? refreshUrl;

  /// The url to your authorization server that provides new [accessToken] when expired.
  ///
  /// When the SDK receives a response the server, it will decode the JSON and recursively iterate through the keys, performing regular expressions and other String-analysis *to "taste"* the data in search of the following 3 items:
  ///
  /// 1. "access token"
  /// 2. "refresh token"
  /// 3. "expiry time"
  ///
  /// The SDK is designed to operate with *any* response data-structure.  For example, one authorization server might return a complex response such as:
  ///
  /// ```json
  /// {
  ///   "token": {
  ///     "access_token": "XXX.YYY.ZZZ",
  ///     "expires_at": 3900
  ///   },
  ///   "refresh_token": "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb"
  /// }
  /// ```
  ///
  /// While another server might return a flat response, such as:
  ///
  /// ```json
  /// {
  ///  "accessToken": "XXX.YYY.ZZZ",
  ///  "refreshToken": "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb",
  ///  "expiry": 3900
  /// }
  /// ```
  ///
  /// When the response from the server is received, the event [BackgroundGeolocation.onAuthorization] will be fired, provided with the [AuthorizationEvent].
  String? refreshToken;

  /// Refresh payload will be encoded into the FORM POST to the [refreshUrl] when requesting a new [accessToken] after expiration.
  ///
  /// You *must* provide one field-template which will represent your "refresh token" using the value: __`{refreshToken}`__.  The SDK will
  /// _automatically_ replace this simple template with the configured [refreshToken].
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   authorization: Authorization(
  ///     strategy: "JWT",
  ///     accessToken: "XXX.YYY.ZZZ",
  ///     refreshUrl: "https://auth.domain.com/tokens",
  ///     refreshToken: "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb",
  ///     refreshPayload: {
  ///       "my_refresh_token": "{refreshToken}", // <-- replaced with configured refreshToken above.
  ///       "grant_type": "refresh_token",        // <-- arbitrary fields required by your auth server
  ///       "foo": "another arbitrary field"
  ///     }
  ///   )
  /// ));
  /// ```
  ///
  /// With the configuration above, a **`curl`** representation of the SDK's FORM POST, might look like this:
  /// ```bash
  /// $ curl -X POST \
  ///   -F 'my_refresh_token=smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb' \
  ///   -F 'grant_type=refresh_token' \
  ///   -F 'foo=another arbitrary field' \
  ///   https://auth.your.server.com/tokens
  ///
  Map? refreshPayload;

  /// Optional refreshHeaders applied on requests to [refreshUrl]
  /// Defaults to: `{"Authorization":  "Bearer {accessToken}"}`
  ///
  /// The template variable `{accessToken}` will automatically be replaced with your app's current auth token.
  ///
  /// If you do not want *any* headers applied on requests to {refreshUrl}, provide an empty `{}`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   authorization: Authorization(
  ///     strategy: "JWT",
  ///     accessToken: "XXX.YYY.ZZZ",
  ///     refreshUrl: "https://auth.domain.com/tokens",
  ///     refreshToken: "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb",
  ///     refreshPayload: {
  ///       "my_refresh_token": "{refreshToken}", // <-- replaced with configured refreshToken above.
  ///       "grant_type": "refresh_token",        // <-- arbitrary fields required by your auth server
  ///       "foo": "another arbitrary field"
  ///     },
  ///     refreshHeaders: {}  // <-- Empty {} to provide no refreshHeaders.
  ///   )
  /// ));
  /// ```
  ///
  Map? refreshHeaders;

  /// Token expiry time in seconds
  int? expires = -1;

  static fromMap(Map map) {
    return Authorization(
        strategy: (map[_STRATEGY] != null) ? map[_STRATEGY] : STRATEGY_JWT,
        accessToken: (map[_ACCESS_TOKEN] != null) ? map[_ACCESS_TOKEN] : null,
        refreshToken:
            (map[_REFRESH_TOKEN] != null) ? map[_REFRESH_TOKEN] : null,
        refreshUrl: (map[_REFRESH_URL] != null) ? map[_REFRESH_URL] : null,
        refreshPayload:
            (map[_REFRESH_PAYLOAD] != null) ? map[_REFRESH_PAYLOAD] : null,
        refreshHeaders:
            (map[_REFRESH_HEADERS] != null) ? map[_REFRESH_HEADERS] : null,
        expires: (map[_EXPIRES] != null) ? _ensureInt(map[_EXPIRES]) : -1);
  }

  Authorization(
      {this.strategy = STRATEGY_JWT,
      this.accessToken,
      this.refreshToken,
      this.refreshPayload,
      this.refreshHeaders,
      this.refreshUrl,
      this.expires = -1});

  Map<String, dynamic> toMap() {
    return {
      _STRATEGY: strategy,
      _ACCESS_TOKEN: accessToken,
      _REFRESH_TOKEN: refreshToken,
      _REFRESH_URL: refreshUrl,
      _REFRESH_PAYLOAD: refreshPayload,
      _REFRESH_HEADERS: refreshHeaders,
      _EXPIRES: expires
    };
  }
}
