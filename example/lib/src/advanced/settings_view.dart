import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class SettingsView extends StatefulWidget {
  @override
  State createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bg.State _state;
  List<Map> _platformSettings;

  void initState() {
    super.initState();

    // Build list of available settings by plaform.
    _platformSettings = [];
    PLUGIN_SETTINGS['common'].forEach((Map item) {
      _platformSettings.add(item);
    });

    if (defaultTargetPlatform == TargetPlatform.android) {
      PLUGIN_SETTINGS['android'].forEach((Map item) {
        _platformSettings.add(item);
      });
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      PLUGIN_SETTINGS['ios'].forEach((Map item) {
        _platformSettings.add(item);
      });
    }

    bg.BackgroundGeolocation.getState().then((bg.State state) {
      setState(() {
        _state = state;
      });
    });
  }

  _onClickAbout() {


  }

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
      return new Scaffold(
        body: new Text('Loading...')
      );
    }

    List<Widget> fields = [];

    fields.add(_buildFieldSeparator('GEOLOCATION'));
    _platformSettings.where((Map item) {
      return item['group'] == 'geolocation';
    }).forEach((Map item) {
      fields.add(_buildField(item));
    });

    fields.add(_buildFieldSeparator("ACTIVITY RECOGNITION"));
    _platformSettings.where((Map item) {
      return item['group'] == 'activity recognition';
    }).forEach((Map item) {
      fields.add(_buildField(item));
    });

    fields.add(_buildFieldSeparator("HTTP & PERSISTENCE"));
    _platformSettings.where((Map item) {
      return item['group'] == 'http';
    }).forEach((Map item) {
      fields.add(_buildField(item));
    });

    fields.add(_buildFieldSeparator("APPLICATION"));
    _platformSettings.where((Map item) {
      return item['group'] == 'application';
    }).forEach((Map item) {
      fields.add(_buildField(item));
    });

    fields.add(_buildFieldSeparator("DEBUG"));
    _platformSettings.where((Map item) {
      return item['group'] == 'debug';
    }).forEach((Map item) {
      fields.add(_buildField(item));
    });

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          new FlatButton(onPressed: _onClickAbout, child: new Text('About'))
        ]
      ),
      body: new Container(
        child: new Form(
          key: this._formKey,
          child: new ListView(
            children: fields
          ),
        )
      ),
    );
  }

  Widget _buildField(Map<String, Object> setting) {
    Widget field;
    switch(setting['inputType']) {
      case 'select':
        field = _buildSelectField(setting);
        break;
      case 'toggle':
        field = _buildSwitchField(setting);
        break;
      default:
        field = new Text('Unsupported type: ' + setting['inputType']);
        break;
    }
    return new Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        child: field
    );
  }

  Widget _buildSelectField(Map<String, Object> setting) {
    List values = setting['values'];
    List labels = setting['labels'];
    String name = setting['name'];
    dynamic value = _state.map[name];
    if (value.runtimeType == double) {
      value = value.round();
    }

    List<DropdownMenuItem<String>> menuItems = new List();
    values.forEach((dynamic item) {
      String value = item.toString();
      String label = (labels != null) ? labels[values.indexOf(item)] : value;
      menuItems.add(new DropdownMenuItem(child: new Text(label), value: value));
    });

    print("$name: " + value.toString() + ", values: $values");

    return Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Text(setting['name'])
          ),
          Expanded(
              flex: 1,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: value.toString(),
                      items: menuItems,
                      onChanged: _createSelectChangeHandler(setting['name'])
                  )
              )
          )
        ]
    );
  }

  Widget _buildSwitchField(Map<String, Object> setting) {
    String name = setting['name'];
    bool value = _state.map[name];

    return Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: new Text(setting['name'])
          ),
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Switch(value: value, onChanged: _createSwitchChangeHandler(name))
                  ]
              )
          )
        ]
    );
  }

  Function(String) _createSelectChangeHandler(String field) {
    return (String value) {
      bg.Config config = new bg.Config().set(field, value);
      bg.BackgroundGeolocation.setConfig(config).then((bg.State state) {
        setState(() {
          _state = state;
        });
      });
    };
  }

  Function(bool) _createSwitchChangeHandler(String field) {
    return (bool value) {
      bg.Config config = bg.Config().set(field, value);
      bg.BackgroundGeolocation.setConfig(config).then((bg.State state) {
        setState(() {
          _state = state;
        });
      });
    };
  }

  Widget _buildFieldSeparator(String label) {
    return Container(
        color: Color.fromRGBO(200, 200, 200, 0.5),
        padding: EdgeInsets.all(20.0),
        child: Text(label, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
    );
  }
}

const PLUGIN_SETTINGS = {
  'common': [
    // Geolocation
    {'name': 'desiredAccuracy', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'labels': ['NAVIGATION', 'HIGH', 'LOW', 'VERY_LOW', 'LOWEST'], 'values': [-2, -1, 10, 100, 1000], 'defaultValue': 0 },
    {'name': 'distanceFilter', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 10, 20, 50, 100, 500], 'defaultValue': 20 },
    {'name': 'disableElasticity', 'group': 'geolocation', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'elasticityMultiplier', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 1, 2, 3, 5, 10], 'defaultValue': 1},
    {'name': 'geofenceProximityRadius', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [1000, 1500, 2000, 5000, 10000, 100000], 'defaultValue': 1000 },
    {'name': 'stopAfterElapsedMinutes', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [-1, 0, 1, 2, 5, 10, 15], 'defaultValue': 0},
    {'name': 'desiredOdometerAccuracy', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [10, 20, 50, 100, 500], 'defaultValue': 100},
    // Activity Recognition
    {'name': 'activityRecognitionInterval', 'group': 'activity recognition', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 1000, 5000, 10000, 30000], 'defaultValue': 10000},
    {'name': 'stopTimeout', 'group': 'activity recognition', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 1, 5, 10, 15], 'defaultValue': 1},
    // HTTP & Persistence
    {'name': 'url', 'group': 'http', 'inputType': 'text', 'dataType': 'string', 'defaultValue': 'http://your.server.com/endpoint'},
    {'name': 'autoSync', 'group': 'http', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': true},
    {'name': 'autoSyncThreshold', 'group': 'http', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 5, 10, 25, 50, 100], 'defaultValue': 0},
    {'name': 'batchSync', 'group': 'http', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'maxBatchSize', 'group': 'http', 'dataType': 'integer', 'inputType': 'select', 'values': [-1, 50, 100, 250, 500], 'defaultValue': 250},
    {'name': 'maxRecordsToPersist', 'group': 'http', 'dataType': 'integer', 'inputType': 'select', 'values': [-1, 0, 1, 10, 100, 1000], 'defaultValue': -1},
    {'name': 'maxDaysToPersist', 'group': 'http', 'dataType': 'integer', 'inputType': 'select', 'values': [-1, 1, 2, 3, 4, 5, 6, 7], 'defaultValue': -1},
    // Application
    {'name': 'stopOnTerminate', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': true},
    {'name': 'startOnBoot', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'heartbeatInterval', 'group': 'application', 'dataType': 'integer', 'inputType': 'select', 'values': [-1, 60, (2*60), (5*60), (15*60)], 'defaultValue': 60},
    // Logging & Debug
    {'name': 'debug', 'group': 'debug', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': true},
    {'name': 'logLevel', 'group': 'debug', 'dataType': 'string', 'inputType': 'select', 'values': [0, 1, 2, 3, 4, 5], 'labels': ['OFF', 'ERROR', 'WARN', 'INFO', 'DEBUG', 'VERBOSE'], 'defaultValue': 'VERBOSE'},
    {'name': 'logMaxDays', 'group': 'debug', 'dataType': 'integer', 'inputType': 'select', 'values': [1, 2, 3, 4, 5, 6, 7], 'defaultValue': 3}
  ],
  'ios': [
    // Geolocation
    {'name': 'stationaryRadius', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 25, 50, 100, 500, 1000, 5000], 'defaultValue': 25 },
    {'name': 'activityType', 'group': 'geolocation', 'dataType': 'string', 'inputType': 'select', 'values': ['Other', 'AutomotiveNavigation', 'Fitness', 'OtherNavigation'], 'defaultValue': 'Other'},
    {'name': 'useSignificantChangesOnly', 'group': 'geolocation', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    // Application
    {'name': 'preventSuspend', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    // Activity Recognition
    {'name': 'disableStopDetection', 'group': 'activity recognition', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'stopDetectionDelay', 'group': 'activity recognition', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 1, 5, 10, 15], 'defaultValue': 0}
  ],
  'android': [
    // Geolocation
    {'name': 'locationUpdateInterval', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 1000, 5000, 10000, 30000, 60000], 'defaultValue': 5000},
    {'name': 'fastestLocationUpdateInterval', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [0, 1000, 5000, 10000, 30000, 60000], 'defaultValue': 1000},
    {'name': 'deferTime', 'group': 'geolocation', 'dataType': 'integer', 'inputType': 'select', 'values': [0, (10*1000), (30*1000), (60*1000), (5*60*1000)], 'defaultValue': 0},
    // Activity Recognition
    // Application
    {'name': 'enableHeadless', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': true},
    {'name': 'foregroundService', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'forceReloadOnMotionChange', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'forceReloadOnLocationChange', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'forceReloadOnGeofence', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'forceReloadOnHeartbeat', 'group': 'application', 'dataType': 'boolean', 'inputType': 'toggle', 'values': [true, false], 'defaultValue': false},
    {'name': 'notificationPriority', 'group': 'application', 'dataType': 'string', 'inputType': 'select', 'values': [0, 1, -1, 2, -2], 'labels': ['DEFAULT', 'HIGH', 'LOW', 'MAX', 'MIN'], 'defaultValue': 'DEFAULT'}
  ]
};