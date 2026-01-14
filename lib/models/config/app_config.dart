part of '../../flutter_background_geolocation.dart';

/// {@macro config.application}
class AppConfig {
  /// {@macro config.stop_on_terminate}
  final bool? stopOnTerminate;

  /// {@macro config.start_on_boot}
  final bool? startOnBoot;

  /// {@macro config.enable_headless}
  final bool? enableHeadless;

  /// {@macro config.heartbeat_interval}
  final double? heartbeatInterval;

  /// {@macro config.schedule}
  final List<String>? schedule;

  /// {@macro config.schedule_use_alarm_manager}
  final bool? scheduleUseAlarmManager;

  /// {@macro config.notification}
  final Notification? notification;

  /// {@macro config.background_permission_rationale}
  final PermissionRationale? backgroundPermissionRationale;

  /// {@macro config.prevent_suspend}
  final bool? preventSuspend; // iOS only

  const AppConfig({
    this.stopOnTerminate,
    this.startOnBoot,
    this.enableHeadless,
    this.heartbeatInterval,
    this.schedule,
    this.scheduleUseAlarmManager,
    this.notification,
    this.backgroundPermissionRationale,
    this.preventSuspend,
  });

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      if (stopOnTerminate != null) 'stopOnTerminate': stopOnTerminate,
      if (startOnBoot != null) 'startOnBoot': startOnBoot,
      if (enableHeadless != null) 'enableHeadless': enableHeadless,
      if (heartbeatInterval != null) 'heartbeatInterval': heartbeatInterval,
      if (schedule != null) 'schedule': schedule,
      if (scheduleUseAlarmManager != null)
        'scheduleUseAlarmManager': scheduleUseAlarmManager,
      if (notification != null) 'notification': notification!.toMap(),
      if (backgroundPermissionRationale != null)
        'backgroundPermissionRationale': backgroundPermissionRationale!.toMap(),
      if (preventSuspend != null) 'preventSuspend': preventSuspend,
    };
    return m;
  }

  factory AppConfig.fromMap(Map<String, dynamic> m) => AppConfig(
        stopOnTerminate: _ensureBool(m['stopOnTerminate']),
        startOnBoot: _ensureBool(m['startOnBoot']),
        enableHeadless: _ensureBool(m['enableHeadless']),
        heartbeatInterval: _ensureDouble(m['heartbeatInterval']),
        schedule: (m['schedule'] is List)
            ? (m['schedule'] as List).whereType<String>().toList()
            : null,
        scheduleUseAlarmManager: _ensureBool(m['scheduleUseAlarmManager']),
        notification: (m['notification'] is Map)
            ? Notification.fromMap(
                (m['notification'] as Map).cast<String, dynamic>())
            : null,
        backgroundPermissionRationale:
            (m['backgroundPermissionRationale'] is Map)
                ? PermissionRationale.fromMap(
                    (m['backgroundPermissionRationale'] as Map)
                        .cast<String, dynamic>())
                : null,
        preventSuspend: _ensureBool(m['preventSuspend']),
      );
}
