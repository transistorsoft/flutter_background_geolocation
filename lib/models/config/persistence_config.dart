part of '../../flutter_background_geolocation.dart';

/// Enum for persistence mode.
enum PersistMode {
  all(Config.PERSIST_MODE_ALL),
  location(Config.PERSIST_MODE_LOCATION),
  geofence(Config.PERSIST_MODE_GEOFENCE),
  none(Config.PERSIST_MODE_NONE);

  final int id;
  const PersistMode(this.id);

  /// Helper to parse from int or String.
  static PersistMode? from(dynamic value) {
    if (value is PersistMode) return value;
    if (value is int) {
      for (final e in PersistMode.values) {
        if (e.id == value) return e;
      }
      return null;
    }
    if (value is String) {
      for (final e in PersistMode.values) {
        if (e.name == value) return e;
      }
      return null;
    }
    return null;
  }
}

/// {@macro config.persistence}
/// 
class PersistenceConfig {
  /// {@macro config.location_template}
  final String? locationTemplate;

  /// {@macro config.geofence_template}
  final String? geofenceTemplate;

  /// {@macro config.max_days_to_persist}
  final int? maxDaysToPersist;

  /// {@macro config.max_records_to_persist}
  final int? maxRecordsToPersist;

  /// {@macro config.locations_order_direction}
  final String? locationsOrderDirection;

  /// {@macro config.persist_mode}
  final PersistMode? persistMode;

  /// {@macro config.extras}
  final Map<String, dynamic>? extras;

  /// {@macro config.disable_providerchange_record}
  final bool? disableProviderChangeRecord;

  const PersistenceConfig({
    this.locationTemplate,
    this.geofenceTemplate,
    this.maxDaysToPersist,
    this.maxRecordsToPersist,
    this.locationsOrderDirection,
    this.persistMode,
    this.extras,
    this.disableProviderChangeRecord,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (locationTemplate != null) 'locationTemplate': locationTemplate,
      if (geofenceTemplate != null) 'geofenceTemplate': geofenceTemplate,
      if (maxDaysToPersist != null) 'maxDaysToPersist': maxDaysToPersist,
      if (maxRecordsToPersist != null) 'maxRecordsToPersist': maxRecordsToPersist,
      if (locationsOrderDirection != null) 'locationsOrderDirection': locationsOrderDirection,
      if (persistMode != null) 'persistMode': persistMode!.id,
      if (extras != null) 'extras': extras,
      if (disableProviderChangeRecord != null)
        'disableProviderChangeRecord': disableProviderChangeRecord,
    };
  }

  factory PersistenceConfig.fromMap(Map<String, dynamic> m) => PersistenceConfig(
    locationTemplate: m['locationTemplate'],
    geofenceTemplate: m['geofenceTemplate'],
    maxDaysToPersist: _ensureInt(m['maxDaysToPersist']),
    maxRecordsToPersist: _ensureInt(m['maxRecordsToPersist']),
    locationsOrderDirection: m['locationsOrderDirection'],
    persistMode: m['persistMode'] != null ? PersistMode.from(m['persistMode']) : null,
    extras: (m['extras'] is Map) ? (m['extras'] as Map).cast<String, dynamic>() : null,
    disableProviderChangeRecord: _ensureBool(m['disableProviderChangeRecord']),
  );
}
