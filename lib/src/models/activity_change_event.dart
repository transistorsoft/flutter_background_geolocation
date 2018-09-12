part of flt_background_geolocation;

class ActivityChangeEvent {
  String activity;
  int confidence;

  ActivityChangeEvent(this.activity, this.confidence);

  String toString() {
    return "[ActivityChangeEvent " + this.activity.toString() + " (" + this.confidence.toString() + "%)]";
  }
}