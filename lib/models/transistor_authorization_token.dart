part of flt_background_geolocation;

/// Use [TransistorAuthorizationToken.findOrCreate] to generate an Authorization token suitable for configuring the SDK's [Authorization] with Transistor Software's Demo Server at [http://tracker.transistorsoft.com](http://tracker.transistorsoft.com).
///
/// You may also run your own instance of Demo Server locally.  See [background-geolocation-console](https://github.com/transistorsoft/background-geolocation-console)
///
/// The test server is a great way to debug location problems or evalute the SDK's behaviour, since the results can easily be shared with *Transistor Software* when requesting support.
///
/// ![](https://dl.dropboxusercontent.com/s/3abuyyhioyypk8c/screenshot-tracker-transistorsoft.png?dl=1)
///
///
/// # Example
/// ```dart
/// String orgname = "my-company-name";
/// String usernmae = "my-username";
///
/// // Fetch an authoriztion token from server.
/// // The SDK will cache the received token and return it if found locally.
/// TransistorAuthorizationToken token = await
///   TransistorAuthorizationToken.findOrCreate(orgname, username);
///
/// BackgroundGeolocation.ready(Config(
///   transistorAuthorizationToken: token
/// ))
/// ```
///
/// # Viewing Your Tracking Results
///
/// To *view* your tracking results in the browser, use your configured "Organization Name" and visit:
///
/// http://tracker.transistorsoft.com/my-organization-name
///
class TransistorAuthorizationToken {
  static const String _DUMMY_TOKEN = "DUMMY_TOKEN";
  static const String _DEFAULT_TRANSISTOR_URL =
      "https://tracker.transistorsoft.com";
  static const String _LOCATIONS_PATH = "api/locations";
  static const String _REFRESH_TOKEN_PATH = "api/refresh_token";
  static const Map<String, String> _REFRESH_PAYLOAD = {
    "refresh_token": "{refreshToken}"
  };

  static const String FIELD_ACCESS_TOKEN = "accessToken";
  static const String FIELD_REFRESH_TOKEN = "refreshToken";
  static const String FIELD_EXPIRES = "expires";

  /// The authorization token to provide to [Authorization.accessToken]
  String accessToken;

  /// The token used to request to provide to [Authorization.refreshToken]
  String refreshToken;

  /// The expiry time of the [Authorization.accessToken]
  int expires;

  /// The base-url of Transistor Demo server where this token came from.
  /// __Read only__
  String url;

  TransistorAuthorizationToken(
      this.accessToken, this.refreshToken, this.expires, this.url);

  /// Return full url to `/locations` endpoint.
  String get locationsUrl {
    return "$url/$_LOCATIONS_PATH";
  }

  /// Return full url to refreshUrl endpoint.
  String get refreshUrl {
    return "$url/$_REFRESH_TOKEN_PATH";
  }

  /// Return `Map` of refreshPayload.
  Map<String, String> get refreshPayload {
    return _REFRESH_PAYLOAD;
  }

  /// Returns [Authorization] instance suitable for consumption by [Config.authorization].
  /// See [Config.transistorAuthorizationToken]
  ///
  Authorization get authorizationConfig {
    return Authorization(
        strategy: Authorization.STRATEGY_JWT,
        accessToken: accessToken,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl,
        refreshPayload: _REFRESH_PAYLOAD,
        expires: expires);
  }

  /// JSON represention of token.
  String toJson() {
    return jsonEncode({
      FIELD_ACCESS_TOKEN: accessToken,
      FIELD_REFRESH_TOKEN: refreshToken,
      FIELD_EXPIRES: expires
    });
  }

  /// Destroys the cached Transistor JSON Web Token used to authorize with the Demo Server at http://tracker.transistorsoft.com or your local instance of [background-geolocation-console](https://github.com/transistorsoft/background-geolocation-console)
  ///
  /// ## Example
  /// ```dart
  /// // defaults to http://tracker.transistorsoft.com
  /// await TransistorAuthorizationToken.destroy();
  ///
  /// // If using a custom instance of Demo Server:
  /// /// await TransistorAuthorizationToken.destroy("http://192.168.0.100:9000");
  /// ```
  ///
  /// ### ℹ️ See also:
  /// - [findOrCreate]
  ///
  static Future<bool?> destroy(String url) async {
    return await (_methodChannel.invokeMethod<bool?>(
        'destroyTransistorToken', url));
  }

  /// Returns a *JSON Web Token* ([JWT](https://jwt.io/)) suitable for [Authorization] with the Transistor Software demo server at http://tracker.transistorsoft.com.
  ///
  /// This token is typically provided to [Config.transistorAuthorizationToken] when first configuring the SDK with [BackgroundGeolocation.ready].
  ///
  /// ## Params
  ///
  /// ### __`@param {String} orgname`__
  ///
  /// Represents a "company" or "organization"; a container for posting locations from multiple devices to the same account.  `orgname` is used for accessing your device results in web app, eg: http://tracker.transistorsoft.com/my-organization-name.
  ///
  /// ### __`@param {String} username`__
  ///
  /// Appended to the [DeviceInfo.model] as a means of creating a consistent and unique device identifier.  For example:
  /// - `Pixel 3a-my-username`
  /// - `A310-my-username`
  /// - `iPhone 11,3-my-username`
  ///
  /// ### __`@param {String} url [http://tracker.transistorsoft.com]`__
  ///
  /// The server to register with and receive authentication tokens from.  Defaults to `http://tracker.transistorsoft.com`.  If you have a local instance of [background-geolocation-console](https://github.com/transistorsoft/background-geolocation-console) running
  /// on your localhost, you would provide the __ip address__ of your server, eg: `http://192.168.0.100:9000`.
  ///
  /// --------------------------------------------------
  ///
  ///
  /// When the SDK receives the [TransistorAuthorizationToken] from `url`, it will be cached in persistant-storage within the native code.  If the SDK doesn't find a cached token on the client, it will automatically register for one from `url`, using the provided `orgname` and `username`.  Otherwise, the cached token will be immediately returned.
  ///
  ///
  /// ## Example
  /// ```dart
  /// String orgname = "my-company-name";
  /// String usernmae = "my-username";
  ///
  /// // Fetch an authoriztion token from server.  The SDK will cache the received token.
  /// TransistorAuthorizationToken token = await
  ///   TransistorAuthorizationToken.findOrCreate(orgname, username);
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   transistorAuthorizationToken: token
  /// ))
  /// ```
  ///
  /// ### ℹ️ See also:
  /// - [destroy]
  /// - [Config.transistorAuthorizationToken]
  ///
  static Future<TransistorAuthorizationToken> findOrCreate(
      String orgname, String username,
      [String url = _DEFAULT_TRANSISTOR_URL]) async {
    Completer completer = new Completer<TransistorAuthorizationToken>();
    _methodChannel.invokeMethod(
        'getTransistorToken', [orgname, username, url]).then((dynamic data) {
      completer.complete(TransistorAuthorizationToken(data[FIELD_ACCESS_TOKEN],
          data[FIELD_REFRESH_TOKEN], data[FIELD_EXPIRES], url));
    }).catchError((error) {
      print("[TransistorAuthorizationToken findOrCreate] ERROR: $error");
      if (error.code != "403") {
        completer.complete(
            TransistorAuthorizationToken(_DUMMY_TOKEN, _DUMMY_TOKEN, -1, url));
      } else {
        throw Error(error);
      }
    });
    return completer.future as FutureOr<TransistorAuthorizationToken>;
  }
}
