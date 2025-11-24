part of '../../flutter_background_geolocation.dart';

/// Represents the verbosity level of the SDK’s internal logger.
enum LogLevel {
  /// Disable all logging.
  off(Config.LOG_LEVEL_OFF),

  /// Log only error-level messages.
  error(Config.LOG_LEVEL_ERROR),

  /// Log warnings and errors.
  warning(Config.LOG_LEVEL_WARNING),

  /// Log informational, warning, and error messages.
  info(Config.LOG_LEVEL_INFO),

  /// Log debug, info, warning, and error messages.
  debug(Config.LOG_LEVEL_DEBUG),

  /// Log everything including verbose diagnostic output.
  verbose(Config.LOG_LEVEL_VERBOSE);

  final int id;
  const LogLevel(this.id);

  /// Convert from legacy integer or string to [LogLevel].
  static LogLevel from(dynamic v) {
    if (v is LogLevel) return v;
    if (v is int) {
      return LogLevel.values.firstWhere(
        (e) => e.id == v,
        orElse: () => LogLevel.info,
      );
    }
    if (v is String) {
      switch (v.toLowerCase()) {
        case 'off':
          return LogLevel.off;
        case 'error':
          return LogLevel.error;
        case 'warning':
          return LogLevel.warning;
        case 'info':
          return LogLevel.info;
        case 'debug':
          return LogLevel.debug;
        case 'verbose':
          return LogLevel.verbose;
      }
    }
    return LogLevel.info;
  }
}

///
/// {@macro config.logger}
///
class LoggerConfig {
  /// {@macro config.debug}
  final bool? debug;

  /// {@macro config.log_level}
  final LogLevel? logLevel;

  /// {@macro config.log_max_days}
  final int? logMaxDays;

  const LoggerConfig({this.debug, this.logLevel, this.logMaxDays});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (debug != null) 'debug': debug,
      if (logLevel != null) 'logLevel': logLevel!.id,
      if (logMaxDays != null) 'logMaxDays': logMaxDays,
    };
  }

  factory LoggerConfig.fromMap(Map<String, dynamic> m) => LoggerConfig(
        debug: m['debug'],
        logLevel: (m['logLevel'] != null) ? LogLevel.from(m['logLevel']) : null,
        logMaxDays: m['logMaxDays'],
      );
}
