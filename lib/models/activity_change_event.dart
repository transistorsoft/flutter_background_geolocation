part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onActivityChange].
///
/// ### Example
/// ```dart
/// BackgroundGeolocation.onActivityChange((ActivityChangeEvent event) {
///   print('[activitychange] ${event.activity}, ${event.confidence}');
/// });
/// ```
///
class ActivityChangeEvent {
  /// The reported device motion activity.
  ///
  /// | Activity Name  |
  /// |----------------|
  /// | `still`        |
  /// | `on_foot`      |
  /// | `walking`      |
  /// | `running`      |
  /// | `on_bicycle`   |
  /// | `in_vehicle`   |
  /// | `unknown`      |
  final String activity;

  /// Confidence of the reported device motion activity in %.
  ///
  final int confidence;

  ActivityChangeEvent(this.activity, this.confidence);

  /// String representation of object.
  String toString() {
    return "[ActivityChangeEvent " +
        this.activity.toString() +
        " (" +
        this.confidence.toString() +
        "%)]";
  }

  /// Convert object to Map.
  Map<String, dynamic> toMap() {
    return {'activity': activity, 'confidence': confidence};
  }
}
