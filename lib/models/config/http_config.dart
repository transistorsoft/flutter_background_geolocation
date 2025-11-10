
part of '../../flutter_background_geolocation.dart';

/// {@macro config.http}
class HttpConfig {
  /// {@macro config.auto_sync}
  final bool? autoSync;

  /// {@macro config.auto_sync_threshold}
  final int? autoSyncThreshold;

  /// {@macro config.disable_autosync_on_cellular}
  final bool? disableAutoSyncOnCellular;

  /// {@macro config.batch_sync}
  final bool? batchSync;

  /// {@macro config.max_batch_size}
  final int? maxBatchSize;

  /// {@macro config.method}
  final String? method;

  /// {@macro config.url}
  String? url;

  /// {@macro config.params}
  final Map<String, dynamic>? params;

  /// {@macro config.headers}
  final Map<String, dynamic>? headers;

  /// {@macro config.http_root_property}
  final String? rootProperty;

  /// {@macro config.http_timeout}
  final int? timeout;

  HttpConfig({
    this.autoSync,
    this.autoSyncThreshold,
    this.disableAutoSyncOnCellular,
    this.batchSync,
    this.maxBatchSize,
    this.method,
    this.url,
    this.params,
    this.headers,
    this.rootProperty,
    this.timeout,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (autoSync != null) 'autoSync': autoSync,
      if (autoSyncThreshold != null) 'autoSyncThreshold': autoSyncThreshold,
      if (disableAutoSyncOnCellular != null)
        'disableAutoSyncOnCellular': disableAutoSyncOnCellular,
      if (batchSync != null) 'batchSync': batchSync,
      if (maxBatchSize != null) 'maxBatchSize': maxBatchSize,
      if (method != null) 'method': method,
      if (url != null) 'url': url,
      if (params != null) 'params': params,
      if (headers != null) 'headers': headers,
      if (rootProperty != null) 'rootProperty': rootProperty,
      if (timeout != null) 'timeout': timeout,
    };
  }

  factory HttpConfig.fromMap(Map<String, dynamic> m) => HttpConfig(
    autoSync: _ensureBool(m['autoSync']),
    autoSyncThreshold: _ensureInt(m['autoSyncThreshold']),
    disableAutoSyncOnCellular: _ensureBool(m['disableAutoSyncOnCellular']),
    batchSync: _ensureBool(m['batchSync']),
    maxBatchSize: _ensureInt(m['maxBatchSize']),
    method: m['method'],
    url: m['url'],
    params: (m['params'] is Map) ? (m['params'] as Map).cast<String, dynamic>() : null,
    headers: (m['headers'] is Map) ? (m['headers'] as Map).cast<String, dynamic>() : null,
    rootProperty: m['rootProperty'] ?? m['httpRootProperty'],
    timeout: _ensureInt(m['timeout'] ?? m['httpTimeout']),
  );
}

