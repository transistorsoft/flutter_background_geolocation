part of '../../flutter_background_geolocation.dart';

/// Defines the priority / visibility of the Android foreground-service notification.
///
/// This affects how the notification appears in the status bar and how strongly
/// the OS ranks it among other notifications.
enum NotificationPriority {
  /// Default notification priority (normal weighting).
  defaultPriority(Config.NOTIFICATION_PRIORITY_DEFAULT),

  /// Notification strongly weighted to top of list; icon strongly weighted to the left.
  high(Config.NOTIFICATION_PRIORITY_HIGH),

  /// Notification weighted to bottom of list; icon weighted to the right.
  low(Config.NOTIFICATION_PRIORITY_LOW),

  /// Same as [high].
  max(Config.NOTIFICATION_PRIORITY_MAX),

  /// Notification strongly weighted to bottom of list; icon hidden.
  min(Config.NOTIFICATION_PRIORITY_MIN);

  final int id;
  const NotificationPriority(this.id);

  static NotificationPriority from(dynamic v) {
    if (v is NotificationPriority) return v;
    if (v is int) {
      return NotificationPriority.values.firstWhere(
        (e) => e.id == v,
        orElse: () => NotificationPriority.defaultPriority,
      );
    }
    if (v is String) {
      switch (v.toLowerCase()) {
        case 'default':
        case 'defaultpriority':
          return NotificationPriority.defaultPriority;
        case 'high':
          return NotificationPriority.high;
        case 'low':
          return NotificationPriority.low;
        case 'max':
          return NotificationPriority.max;
        case 'min':
          return NotificationPriority.min;
      }
    }
    return NotificationPriority.defaultPriority;
  }
}

///
/// {@macro config.notification}
///
class Notification {
  /// Specifies the name of your custom Android Layout XML file.
  ///
  /// ℹ️ See [Android Custom Notification Layout](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Custom-Notification-Layout) for setup instructions.
  ///
  /// ![](https://dl.dropbox.com/s/whcb6q1gxxdk9t1/android-foreground-notification-transistor.png?dl=1)
  ///
  /// Even if you have no experience with Android Layouts, it doesn't take much to figure out the basics.  You'll mostly be adding `<TextView />`, `<ImageView />` and `<Button />` elements.  The key thing to be aware of is the `android:id` of these elements and how these are referenced from [AppConfig.notification] configuration:  your `android:id` **must** be prefixed with the word `notification` (eg: `notificationText`).  There is one exception: `applicationName`, which the SDK will automatically render your Android application name.
  ///
  /// ## Layout Special Elements
  ///
  /// When BackgroundGeolocation renders your custom notification layout, it will be querying for the following elements addressed by their `android:id`.  When found, their content will be updated from the corresponding "Data-source":
  ///
  /// | Layout element `android:id`   | Data-source                               |
  /// |-------------------------------|-------------------------------------------|
  /// | `applicationName`             | *Application name* from `AndroidManifest` |
  /// | `notificationTitle`           | [title]                                 |
  /// | `notificationText`            | [text]                                  |
  /// | `notificationSmallIcon`       | [smallIcon]                             |
  /// | `notificationLargeIcon`       | [largeIcon]                             |
  ///
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     layout: "my_notification_layout",  // <-- custom layout xml file
  ///     title: "The Notification Title",
  ///     text: "The Notification Text",
  ///     smallIcon: "mipmap/my_small_icon", // <-- defaults to app icon
  ///     largeIcon: "mipmap/my_large_icon"
  ///   )
  /// ));
  /// ```
  ///
  /// ## Custom `<TextView />` Elements
  ///
  /// You can declare your own custom `<TextView />` elements and render data into them using the [strings] parameter.
  ///
  /// ```xml
  /// <TextView
  ///     android:id="@+id/myCustomElement"  // <-- myCustomElement
  ///     android:layout_width="match_parent"
  ///     android:layout_height="wrap_content"
  ///     android:text="notificationTitle" />
  /// ```
  ///
  /// You can provide data to your custom elements using the [strings] configuration parameter:
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     strings: {
  ///       "myCustomElement": "My Custom Element Text"
  ///     }
  ///   )
  /// ));
  /// ```
  ///
  /// ## Custom `<Button />` Elements:
  ///
  /// You can declare your own custom `<Button />` elements and register click-listeners upon them using the [actions] parameter:
  ///
  /// ```xml
  /// <Button
  ///     android:id="@+id/notificationButtonFoo" // <-- notificationButtonFoo
  ///     style="@style/Widget.AppCompat.Button.Small"
  ///     android:layout_width="60dp"
  ///     android:layout_height="40dp"
  ///     android:text="Foo" />
  /// ```
  ///
  /// Register listeners for your button using the [actions] parameter:
  ///
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     actions: [  // <-- register button listeners
  ///       "notificationButtonFoo",
  ///       "notificationButtonBar"
  ///     ]
  ///   )
  /// ));
  ///
  /// // Listen to custom button clicks:
  /// BackgroundGeolocation.onNotificationAction((String buttonId) {
  ///   print("[onNotificationAction] - ${buttonId}");
  ///   switch(buttonId) {
  ///     case 'notificationButtonFoo':
  ///       break;
  ///     case 'notificationButtonBar':
  ///       break;
  ///   }
  /// });
  /// ```
  ///
  /// ## Sample Layout
  ///
  /// As a starting-point for your custom layout, copy the following content into your new file:
  ///
  /// ```xml
  /// <?xml version="1.0" encoding="utf-8"?>
  /// <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
  ///     xmlns:tools="http://schemas.android.com/tools"
  ///     android:layout_width="match_parent"
  ///     android:layout_height="135dp"
  ///     android:gravity="start"
  ///     android:adjustViewBounds="true"
  ///     android:orientation="vertical"
  ///     android:padding="15dp">
  ///
  ///     <LinearLayout
  ///         android:layout_width="match_parent"
  ///         android:layout_height="wrap_content"
  ///         android:layout_marginBottom="15dp"
  ///         android:gravity="center"
  ///         android:orientation="horizontal">
  ///
  ///         <ImageView
  ///             android:id="@+id/notificationSmallIcon"
  ///             android:layout_width="16dp"
  ///             android:layout_height="16dp"
  ///             android:tint="@android:color/background_dark"
  ///             tools:srcCompat="@tools:sample/avatars" />
  ///
  ///         <TextView
  ///             android:id="@+id/applicationName"
  ///             android:layout_width="match_parent"
  ///             android:layout_height="match_parent"
  ///             android:paddingLeft="10dp"
  ///             android:text="applicationName"
  ///             android:textAppearance="@style/TextAppearance.Compat.Notification.Title"
  ///             android:textColor="#888888"
  ///             android:textSize="12sp" />
  ///     </LinearLayout>
  ///
  ///     <TextView
  ///         android:id="@+id/notificationTitle"
  ///         style="@style/TextAppearance.Compat.Notification.Title"
  ///         android:layout_width="match_parent"
  ///         android:layout_height="wrap_content"
  ///         android:text="notificationTitle"
  ///         android:textSize="14sp" />
  ///
  ///     <TextView
  ///         android:id="@+id/notificationText"
  ///         style="@style/TextAppearance.Compat.Notification.Line2"
  ///         android:layout_width="match_parent"
  ///         android:layout_height="wrap_content"
  ///         android:text="notificationText"
  ///         android:textSize="14sp" />
  ///
  ///     <LinearLayout
  ///         android:layout_width="match_parent"
  ///         android:layout_height="wrap_content"
  ///         android:layout_weight="1"
  ///         android:gravity="right"
  ///         android:orientation="horizontal">
  ///
  ///         <Button
  ///             android:id="@+id/notificationButtonFoo"
  ///             style="@style/Widget.AppCompat.Button.Small"
  ///             android:layout_width="60dp"
  ///             android:layout_height="40dp"
  ///             android:text="FooA" />
  ///
  ///         <Button
  ///             android:id="@+id/notificationButtonBar"
  ///             style="@style/Widget.AppCompat.Button.Small"
  ///             android:layout_width="60dp"
  ///             android:layout_height="40dp"
  ///             android:text="Bar" />
  ///     </LinearLayout>
  /// </LinearLayout>
  /// ```
  ///
  /// ![](https://dl.dropbox.com/s/k2l0oaqk86axfgu/android-custom-layout-elements.png?dl=1)
  ///
  /// ## Using your custom layout:
  ///
  /// ```dart
  /// // Listen to custom notification button clicks (notification.actions)
  /// BackgroundGeolocation.onNotificationAction((buttonId) {
  ///   print("[onNotificationAction] ${buttonId}");
  ///   switch(buttonId) {
  ///     case 'notificationButtonFoo':
  ///       // Handle button click on [Foo]
  ///       break;
  ///     case 'notificationButtonBar':
  ///       // Handle button click on [Bar]
  ///       break;
  ///   }
  /// });
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     title: "The title",
  ///     text: "The text",
  ///     layout: "notification_layout",
  ///     actions: [  // <-- register button listeners
  ///       "notificationButtonFoo",
  ///       "notificationButtonBar"
  ///     ]
  ///   )
  /// ));
  /// ```
  String? layout;

  /// Configure the *title* of the persistent notification in the Notification Bar
  ///
  /// Defaults to the application name from `AndroidManifest`.
  String? title;

  /// Configure the *text* of the persistent notification in the Notification Bar when
  ///
  /// Defaults to *"Location service activated"*.
  String? text;

  /// Configure the *color* of the persistent notification icon in the Notification Bar
  ///
  /// Defaults to `""`.
  ///
  /// Supported formats are:
  /// - `#RRGGBB`
  /// - `#AARRGGBB`
  String? color;

  /// Configure the *small icon* of the persistent notification in the Notification Bar.
  ///
  /// ### ⚠️ Warning:
  /// - You must specify the **`type`** (`drawable|mipmap`) of resource you wish to use in the following format: `{type}/icon_name`
  /// - Do not append the file-extension (eg: `.png`)
  ///
  /// ## Example
  ///
  /// ```dart
  /// // 1. drawable
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     smallIcon: "drawable/my_custom_notification_small_icon"
  ///   )
  /// ));
  ///
  /// // 2. mipmap
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     smallIcon: "mipmap/my_custom_notification_small_icon"
  ///   }
  /// });
  /// ```
  ///
  /// ### ℹ️ See also:
  /// - [largeIcon]
  String? smallIcon;

  /// Configure the *large icon* of the persistent notification in the Notification Bar.
  ///
  /// ### ⚠️ Warning:
  /// - You must specify the **`type`** (`drawable|mipmap`) of resource you wish to use in the following format: `{type}/icon_name`
  /// - Do not append the file-extension (eg: `.png`)
  ///
  /// ## Example
  ///
  /// ```dart
  /// // 1. drawable
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     largeIcon: "drawable/my_custom_notification_large_icon"
  ///   )
  /// });
  ///
  /// // 2. mipmap
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     largeIcon: "mipmap/my_custom_notification_large_icon"
  ///   )
  /// });
  /// ```
  ///
  /// ### ℹ️ See also:
  /// - [smallIcon]
  ///
  String? largeIcon;

  /// Android requires a persistent notification in the Notification Bar.  This will control the **priority** of that notification as well as the position of the notificaiton-bar icon.
  ///
  /// The following `priority` values are defined as [NotificationPriority] enum values:
  ///
  /// | Value                                   | Description                                                                                             |
  /// |-----------------------------------------|---------------------------------------------------------------------------------------------------------|
  /// | [NotificationPriority.defaultPriority]  | Notification weighted to top of list; notification-bar icon weighted left |
  /// | [NotificationPriority.high]             | Notification **strongly** weighted to top of list; notification-bar icon **strongly** weighted to left  |
  /// | [NotificationPriority.low]              | Notification weighted to bottom of list; notification-bar icon weighted right |
  /// | [NotificationPriority.max]              | Same as [NotificationPriority.high] |
  /// | [NotificationPriority.min]              | Notification **strongly** weighted to bottom of list; notification-bar icon **hidden** |
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     priority: NotificationPriority.min
  ///   )
  /// ));
  /// ```
  NotificationPriority? priority;

  /// Configure the Android Foreground Service icon and notification to be displayed __always__.  Defaults to `false`.
  ///
  /// The default behaviour is for the notification to be shown only while the SDK detects the device to be *moving*.  Some developers desire to provide full-disclosure to their users when the SDK has been enabled.
  bool? sticky;

  /// Configure the name of the plugin's notification-channel used to display the foreground-service notification.
  ///
  /// On Android O+, the plugin's foreground-service needs to create a "Notification Channel".  The name of this channel can be seen in:
  /// > `Settings->App & Notifications->Your App.`
  ///
  /// Defaults to your application's name from `AndroidManifest`.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/zgcxau7lyjfuaw9/android-notificationChannelName.png?dl=1)\
  ///
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     channelName: "Location Tracker"
  ///   )
  /// ));
  ///
  /// // or with #setConfig
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     channelName: "My new channel name"
  ///   )
  /// ));
  /// ```
  ///
  String? channelName;

  /// Customize the notification channel ID.
  /// Defaults to `your.package.name.TSLocationManager`
  ///
  /// It is not typically required to change this.  Typical use-cases are for users who use an existing Android foreground-service who wish the SDK to share an existing notification and channel.
  ///
  String? channelId;

  ///
  /// Custom strings to render into `<TextView />` elements of a custom notification [layout].
  ///
  /// ℹ️ See [Android Custom Notification Layout](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Custom-Notification-Layout) for setup instructions.
  ///
  /// You can declare your own custom `<TextView />` elements and render data into them using the `notification.strings` parameter.
  ///
  ///
  /// ```xml
  /// <TextView
  ///     android:id="@+id/myCustomElement"  // <-- myCustomElement
  ///     android:layout_width="match_parent"
  ///     android:layout_height="wrap_content"
  ///     android:text="notificationTitle" />
  /// ```
  ///
  /// You can provide data to your custom elements using the [strings] configuration parameter:
  ///
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     strings: {
  ///       "myCustomElement": "My Custom Element Text"
  ///     }
  ///   )
  /// ));
  /// ```
  ///
  Map<String, String>? strings;

  ///
  /// Declare click listeners for `<Button />` elements of a custom notification [layout].
  ///
  /// ![](https://dl.dropbox.com/s/whcb6q1gxxdk9t1/android-foreground-notification-transistor.png?dl=1)
  ///
  /// ℹ️ See [Android Custom Notification Layout](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Custom-Notification-Layout) for setup instructions.
  ///
  /// You can declare your own custom `<Button />` elements and register click-listeners upon them using the [actions] parameter:
  ///
  /// ```xml
  /// <Button
  ///     android:id="@+id/notificationButtonPause" // <-- notificationButtonPause
  ///     style="@style/Widget.AppCompat.Button.Small"
  ///     android:layout_width="60dp"
  ///     android:layout_height="40dp"
  ///     android:text="Foo" />
  /// ```
  ///
  /// Register listeners for your button using `notification.actions`:
  ///
  /// ## Example
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     actions: [  // <-- register button listeners
  ///       "notificationButtonPause"
  ///     ]
  ///   )
  /// ));
  ///
  /// // Listen to custom button clicks:
  /// BackgroundGeolocation.onNotificationAction((String buttonId) {
  ///   print("[onNotificationAction] - ${buttonId}");
  ///   switch(buttonId) {
  ///     case 'notificationButtonPause':
  ///       BackgroundGeolocation.changePace(false);
  ///       break;
  ///   }
  /// });
  /// ```
  ///
  List<String>? actions;

  /// Convert supplied `Map` to `Notification` instance.
  static Notification fromMap(Map map) {
    final Map<String, dynamic> m = map.cast<String, dynamic>();
    return Notification(
        layout: (m['layout'] != null) ? m['layout'] : null,
        title: (m['title'] != null) ? m['title'] : null,
        text: (m['text'] != null) ? m['text'] : null,
        color: (m['color'] != null) ? m['color'] : null,
        smallIcon: (m['smallIcon'] != null) ? m['smallIcon'] : null,
        largeIcon: (m['largeIcon'] != null) ? m['largeIcon'] : null,
        priority: (m['priority'] != null)
            ? NotificationPriority.from(m['priority'])
            : null,
        sticky: (m['sticky'] != null) ? m['sticky'] : null,
        channelName: (m['channelName'] != null) ? m['channelName'] : null,
        channelId: (m['channelId'] != null) ? m['channelId'] : null,
        strings: (m['strings'] != null)
            ? m['strings'].cast<String, String>()
            : null,
        actions:
            (m['actions'] != null) ? m['actions'].cast<String>() : null);
  }

  Notification(
      {this.layout,
      this.title,
      this.text,
      this.color,
      this.channelName,
      this.channelId,
      this.smallIcon,
      this.largeIcon,
      this.priority,
      this.sticky,
      this.strings,
      this.actions});

  /// Return `Map` representation of `Notification`.
  Map<String, dynamic> toMap() {
    return {
      "layout": layout,
      "title": title,
      "text": text,
      "color": color,
      "channelName": channelName,
      "channelId": channelId,
      "smallIcon": smallIcon,
      "largeIcon": largeIcon,
      "priority": priority?.id,
      "sticky": sticky,
      "strings": strings,
      "actions": actions
    };
  }
}
