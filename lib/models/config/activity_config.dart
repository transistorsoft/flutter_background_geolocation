part of '../../flutter_background_geolocation.dart';

/// {@macro config.activity}
class ActivityConfig {
  /// {@macro config.activity_recognition_interval}
  final double? activityRecognitionInterval;            // ANDROID

  /// {@macro config.minimum_activity_confidence}
  final int? minimumActivityRecognitionConfidence;   // ANDROID

  /// {@macro config.disable_stop_detection}
  final bool? disableStopDetection;                  // ANDROID + iOS (behavioural)

  /// {@macro config.stop_on_stationary}
  final bool? stopOnStationary;                      // ANDROID + iOS (behavioural)

  /// {@macro config.motion_trigger_delay}
  final int? motionTriggerDelay;                     // ANDROID

  /// {@macro config.trigger_activities}
  final String? triggerActivities;

  /// {@macro config.disable_motion_activity_updates}
  final bool? disableMotionActivityUpdates;

  /// {@macro config.stop_detection_delay}
  final double? stopDetectionDelay;                     // iOS (ms)

  const ActivityConfig({
    this.activityRecognitionInterval,
    this.minimumActivityRecognitionConfidence,
    this.disableStopDetection,
    this.stopOnStationary,
    this.motionTriggerDelay,
    this.triggerActivities,
    this.disableMotionActivityUpdates,
    this.stopDetectionDelay,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    if (activityRecognitionInterval != null) 'activityRecognitionInterval': activityRecognitionInterval,
    if (minimumActivityRecognitionConfidence != null) 'minimumActivityRecognitionConfidence': minimumActivityRecognitionConfidence,
    if (disableStopDetection != null) 'disableStopDetection': disableStopDetection,
    if (stopOnStationary != null) 'stopOnStationary': stopOnStationary,
    if (motionTriggerDelay != null) 'motionTriggerDelay': motionTriggerDelay,
    if (triggerActivities != null) 'triggerActivities': triggerActivities,
    if (disableMotionActivityUpdates != null) 'disableMotionActivityUpdates': disableMotionActivityUpdates,
    if (stopDetectionDelay != null) 'stopDetectionDelay': stopDetectionDelay,
  };

  factory ActivityConfig.fromMap(Map<String, dynamic> m) => ActivityConfig(
    activityRecognitionInterval: m['activityRecognitionInterval'],
    minimumActivityRecognitionConfidence: m['minimumActivityRecognitionConfidence'],
    disableStopDetection: m['disableStopDetection'],
    stopOnStationary: m['stopOnStationary'],
    motionTriggerDelay: m['motionTriggerDelay'],
    // Accept either CSV or array -> CSV
    triggerActivities: m['triggerActivities'] ??
        ((m['triggerActivities'] is List)
            ? (m['triggerActivities'] as List).whereType<String>().join(', ')
            : m['triggerActivities']),
    disableMotionActivityUpdates: m['disableMotionActivityUpdates'],
    stopDetectionDelay: m['stopDetectionDelay'],
  );
}