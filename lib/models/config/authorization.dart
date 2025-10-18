part of '../../flutter_background_geolocation.dart';

///
/// {@macro config.authorization}
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

  /// Form fields sent to [refreshUrl] in the **application/x-www-form-urlencoded** body.
  ///
  /// ### Requirements
  /// - **String values only.** All entries in `refreshPayload` must be `String` values.
  ///   If you have non‑string types (e.g., `bool`, `int`, `Map`), **convert them to strings first**.
  /// - **Refresh token placeholder.** You **must** include exactly one field whose value is the template
  ///   `"{refreshToken}"`. At runtime, the SDK replaces this placeholder with the configured [refreshToken].
  /// - **Encoding.** The payload is always encoded as `application/x-www-form-urlencoded`.
  ///
  /// ### Example
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   authorization: Authorization(
  ///     strategy: "JWT",
  ///     accessToken: "XXX.YYY.ZZZ",
  ///     refreshUrl: "https://auth.domain.com/tokens",
  ///     refreshToken: "smTsfaspfgaadsfgqZerUt0wueflasdfkaxjdfeKIacb",
  ///     refreshPayload: {
  ///       "grant_type": "refresh_token",
  ///       "refresh_token": "{refreshToken}",   // <-- will be replaced with the configured refreshToken
  ///       "rememberMe": "true"                 // <-- non-strings must be stringified
  ///     }
  ///   )
  /// ));
  /// ```
  Map? refreshPayload;

  /// Headers applied to requests sent to [refreshUrl].
  ///
  /// ### Behavior
  /// - **Merged headers.** These headers are **merged** with global HTTP headers from [HttpConfig.headers]
  ///   (configured via `Config.http`) when the refresh request is made.
  /// - **Content-Type is fixed.** The SDK always sends refresh requests as
  ///   `application/x-www-form-urlencoded`. You **cannot** override `Content-Type` for the refresh request.
  /// - **Template variables.**
  ///   - `{accessToken}` — replaced at runtime with the current [accessToken] value (useful for chaining
  ///     auth where the refresh endpoint also requires the existing token).
  ///
  /// ### Defaults
  /// If you do not supply `refreshHeaders`, the SDK applies:
  /// ```json
  /// { "Authorization": "Bearer {accessToken}" }
  /// ```
  ///
  /// ### Disabling extra headers
  /// If you want **no additional headers** on the refresh request, set:
  /// ```dart
  /// refreshHeaders: const {}
  /// ```
  /// and ensure you haven't configured conflicting global [HttpConfig.headers] that you don't want merged.
  ///
  /// ### Examples
  /// Custom `Authorization` header:
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   http: HttpConfig(
  ///     headers: { "X-App-Version": "1.2.3" } // merged into refresh request as well
  ///   ),
  ///   authorization: Authorization(
  ///     accessToken: "XXX.YYY.ZZZ",
  ///     refreshUrl: "https://auth.domain.com/tokens",
  ///     refreshToken: "REFRESH_TOKEN",
  ///     refreshHeaders: {
  ///       "Authorization": "Bearer {accessToken}",
  ///       "X-Tenant": "acme"
  ///     }
  ///   )
  /// ));
  /// ```
  ///
  /// No extra headers on refresh:
  /// ```dart
  /// authorization: Authorization(
  ///   refreshUrl: "https://auth.domain.com/tokens",
  ///   refreshToken: "REFRESH_TOKEN",
  ///   refreshHeaders: const {} // prevents default Authorization header
  /// )
  /// ```
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
