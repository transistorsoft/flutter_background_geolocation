part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onActivityChange].
/// 
class ActivityChangeEvent {
  final String activity;
  final int confidence;

  ActivityChangeEvent(this.activity, this.confidence);

  String toString() {
    return "[ActivityChangeEvent " +
        this.activity.toString() +
        " (" +
        this.confidence.toString() +
        "%)]";
  }

  Map<String, dynamic> toMap() {
    return {'activity': activity, 'confidence': confidence};
  }
}
