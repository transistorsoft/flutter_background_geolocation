import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart'
    as util;
import 'actions.dart' as actions;
import 'util/test.dart';

const INPUT_TYPE_SELECT = "select";
const INPUT_TYPE_TOGGLE = "toggle";
const INPUT_TYPE_TEXT = "text";

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bg.State? _state;

  // Categorized field-lists.
  final List<Map> _geolocationSettings = [];
  final List<Map> _activityRecognitionSettings = [];
  final List<Map> _httpSettings = [];
  final List<Map> _applicationSettings = [];
  final List<Map> _debugSettings = [];

  // Geofence test params.
  double _radius = 200.0;
  bool _notifyOnEntry = true;
  bool _notifyOnExit = true;
  bool _notifyOnDwell = false;
  int _loiteringDelay = 10000;

  @override
  void initState() {
    super.initState();

    // Build list of available settings by plaform.
    List<Map> settings = [];
    PLUGIN_SETTINGS['common']?.forEach((Map item) {
      settings.add(item);
    });

    if (defaultTargetPlatform == TargetPlatform.android) {
      PLUGIN_SETTINGS['android']?.forEach((Map item) {
        settings.add(item);
      });
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      PLUGIN_SETTINGS['ios']?.forEach((Map item) {
        settings.add(item);
      });
    }

    settings.where((Map item) {
      return item['group'] == 'geolocation';
    }).forEach((Map item) {
      _geolocationSettings.add(item);
    });

    settings.where((Map item) {
      return item['group'] == 'activity recognition';
    }).forEach((Map item) {
      _activityRecognitionSettings.add(item);
    });

    settings.where((Map item) {
      return item['group'] == 'http';
    }).forEach((Map item) {
      _httpSettings.add(item);
    });

    settings.where((Map item) {
      return item['group'] == 'application';
    }).forEach((Map item) {
      _applicationSettings.add(item);
    });

    settings.where((Map item) {
      return item['group'] == 'debug';
    }).forEach((Map item) {
      _debugSettings.add(item);
    });

    bg.BackgroundGeolocation.state.then((bg.State state) {
      setState(() {
        _state = state;
      });
    });

    bg.BackgroundGeolocation.geofences.then((geofences) {
      print("Geofences: $geofences");
    });

  }

  _onClickClose() {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("CLOSE"));
    Navigator.of(context).pop();
  }

  _onClickAbout() {
    // TODO
    print("[onClickAbout] - NO IMPLEMENTATION");
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("FLOURISH"));
  }

  _onSelectMenu(String action) async {
    switch (action) {
      case actions.Actions.RESET_ODOMETER:
        bg.BackgroundGeolocation.setOdometer(0.0);
        break;
      case actions.Actions.SYNC:
        actions.Actions.sync(context);
        break;
      case actions.Actions.DESTROY_LOCATIONS:
        actions.Actions.destroyLocations(context);
        break;
      case actions.Actions.EMAIL_LOG:
        actions.Actions.emailLog(context);
        break;
      case actions.Actions.DESTROY_LOG:
        actions.Actions.destroyLog(context);
        break;
      case actions.Actions.REMOVE_GEOFENCES:
        bg.BackgroundGeolocation.removeGeofences().then((bool success) {
          bg.BackgroundGeolocation.playSound(
              util.Dialog.getSoundId("MESSAGE_SENT"));
        });
        break;
      case 'power_manager':
        //bool didShow = await bg.DeviceSettings.showPowerManager(true);
        bg.DeviceSettings.showPowerManager()
            .then((bg.DeviceSettingsRequest request) {
          util.Dialog.confirm(context, "Power Manager",
              "Manufacturer: ${request.manufacturer}\nModel:${request.model}\nVersion:${request.version}\nSeen: ${request.seen}\n${request.lastSeenAt}",
              (bool confirm) {
            if (!confirm) {
              return;
            }
            bg.DeviceSettings.show(request);
          });
        }).catchError((dynamic error) {
          print(error);
          util.Dialog.alert(context, "Notice", error.message);
        });
        //print('- did show Power Manager Settings: $didShow');
        break;
      case 'ignore_battery_optimizations':
        bool isIgnoring =
            await bg.DeviceSettings.isIgnoringBatteryOptimizations;
        print('- isIgnoringBatteryOptimizations: $isIgnoring');
        bg.DeviceSettings.showIgnoreBatteryOptimizations()
            .then((bg.DeviceSettingsRequest request) {
          util.Dialog.confirm(context, "Ignore Battery Optimizations",
              "isIgnoring? $isIgnoring\nManufacturer: ${request.manufacturer}\nModel:${request.model}\nVersion:${request.version}\nSeen: ${request.seen}\n${request.lastSeenAt}",
              (bool confirm) {
            if (!confirm) {
              return;
            }
            bg.DeviceSettings.show(request);
          });
        }).catchError((dynamic error) {
          print(error);
          util.Dialog.alert(context, "Notice", error.message);
        });
        break;
      case 'about':
        _onClickAbout();
        break;
    }
  }

  _onClickAddGeofences() async {
    await bg.BackgroundGeolocation.addGeofences(Test.getFreewayDriveGeofences(
        _radius,
        _notifyOnEntry,
        _notifyOnExit,
        _notifyOnDwell,
        _loiteringDelay));
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("ADD_GEOFENCE"));
  }

  _onClickRemoveGeofences() async {
    await bg.BackgroundGeolocation.removeGeofences();
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("MESSAGE_SENT"));
  }

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
      return Scaffold(body: Text('Loading...'));
    }

    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.black,
            leading: IconButton(
                onPressed: _onClickClose,
                icon: Icon(Icons.close),
                color: Colors.black),
            title: const Text('Settings'),
            backgroundColor: Colors.amberAccent,
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              PopupMenuButton(
                  itemBuilder: (_) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                            value: actions.Actions.RESET_ODOMETER,
                            child: ListTile(
                                title: Text('Reset odometer'),
                                leading: Icon(Icons.av_timer))),
                        const PopupMenuItem<String>(
                            value: actions.Actions.SYNC,
                            child: ListTile(
                                title: Text('Sync'),
                                leading: Icon(Icons.cloud_upload))),
                        const PopupMenuItem<String>(
                            value: actions.Actions.DESTROY_LOCATIONS,
                            child: ListTile(
                                title: Text('Destroy locations'),
                                leading: Icon(Icons.delete))),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                            value: actions.Actions.EMAIL_LOG,
                            child: ListTile(
                                title: Text('Email log'),
                                leading: Icon(Icons.email))),
                        const PopupMenuItem<String>(
                            value: actions.Actions.DESTROY_LOG,
                            child: ListTile(
                                title: Text('Destroy log'),
                                leading: Icon(Icons.delete))),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                            value: actions.Actions.REMOVE_GEOFENCES,
                            child: ListTile(
                                title: Text('Remove geofences'),
                                leading: Icon(Icons.delete))),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                            value: "power_manager",
                            child: ListTile(
                                title: Text('Settings->Power Manager'),
                                leading: Icon(Icons.settings_power))),
                        const PopupMenuItem<String>(
                            value: "ignore_battery_optimizations",
                            child: ListTile(
                                title: Text(
                                    'Settings->Ignore Battery Optimizations'),
                                leading: Icon(Icons.battery_alert))),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                            value: "about",
                            child: ListTile(
                                title: Text('About'),
                                leading: Icon(Icons.help)))
                      ],
                  onSelected: _onSelectMenu)
            ]),
        body: CustomScrollView(
          slivers: <Widget>[
            _buildListHeader("Geolocation"),
            _buildList(_geolocationSettings),
            _buildListHeader("Activity Recognition"),
            _buildList(_activityRecognitionSettings),
            _buildListHeader("HTTP & Persistence"),
            _buildList(_httpSettings),
            _buildListHeader("Application"),
            _buildList(_applicationSettings),
            _buildListHeader("Debug"),
            _buildList(_debugSettings),
            _buildListHeader("Geofence Test (Freeway Drive)"),
            _buildGeofenceTestPanel()
          ],
        ));
  }

  SliverAppBar _buildListHeader(String title,
      [List<PopupMenuItem<String>>? menu]) {
    return SliverAppBar(
      title: Text(title),
      centerTitle: true,
      actions: (menu != null)
          ? [
              PopupMenuButton<String>(
                  onSelected: _onSelectMenu,
                  itemBuilder: (BuildContext context) => menu)
            ]
          : null,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Color.fromRGBO(230, 230, 230, 0.5),
      //backgroundColor: Colors.white,
      leading: Container(),
      snap: true,
      floating: true,
    );
  }

  Widget _buildList(List<Map> list) {
    return SliverFixedExtentList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return _buildField(list[index]);
      }, childCount: list.length),
      itemExtent: 60.0,
    );
  }

  Widget _buildField(Map<dynamic, dynamic> setting) {
    Object? name = setting['name'];
    Object? inputType = setting['inputType'];
    print('[buildField] - $name: $inputType');
    Widget field;
    switch (inputType) {
      case INPUT_TYPE_SELECT:
        field = _buildSelectField(setting);
        break;
      case INPUT_TYPE_TOGGLE:
        field = _buildSwitchField(setting);
        break;
      case INPUT_TYPE_TEXT:
        field = _buildTextField(setting);
        break;
      default:
        field = Text('field: $name - Unsupported inputType: $inputType');
        break;
    }
    return field;
  }

  Widget _buildSelectField(Map<dynamic, dynamic> setting) {
    List values = setting['values'];
    List? labels = setting['labels'];
    String name = setting['name'];

    dynamic value = _state != null ? _readConfigValue(_state!, name) : null;
    if (value is double) value = value.round();
    final currentValue = value?.toString();

    List<DropdownMenuItem<String>> menuItems = [];
    bool foundCurrentValue = false;
    for (var item in values) {
      final candidate = item.toString();
      if (candidate == currentValue) foundCurrentValue = true;
      String itemValue = item.toString();
      String itemLabel =
      (labels != null) ? labels[values.indexOf(item)] : itemValue;
      menuItems.add(
          DropdownMenuItem(value: itemValue, child: Text(itemLabel)));
    }

    // Ensure currently configured value exists as DropdownMenuItem or an exception blows up:
    if (!foundCurrentValue && currentValue != null) {
      menuItems.add(DropdownMenuItem(
          value: value.toString(),
          child: Text(value.toString())));
    }
    if (currentValue != null) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
          labelStyle: const TextStyle(color: Colors.blue, fontSize: 20.0),
          labelText: name
          // labelText set below:
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            value: currentValue,                 // ✅ use the guarded value
            items: menuItems,                    // List<DropdownMenuItem<String>>
            onChanged: _createSelectChangeHandler(setting),
          ),
        ),
      );
    }
    // safe fallback when there's no value:
    return const SizedBox.shrink();
  }

  Widget _buildSwitchField(Map setting) {
    final String name = setting['name'];
    final dynamic raw = _state != null ? _readConfigValue(_state!, name) : null;
    final bool boolValue = raw is bool ? raw : false;

    return InputDecorator(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(top: 0.0, left: 10.0, bottom: 0.0),
        labelStyle: TextStyle(color: Colors.blue),
        // no labelText here (avoids extra label space)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Label takes all remaining width
          Expanded(
            child: _buildLabel(name),
          ),
          // Fixed width for Switch
          SizedBox(
            width: 56,
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch.adaptive(
                value: boolValue,
                onChanged: _createSwitchChangeHandler(name),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(Map setting) {
    final String name = setting['name'];
    dynamic value = _state != null ? _readConfigValue(_state!, name) : null;

    return GestureDetector(
      onTap: () async {
        final newValue = await util.Dialog.prompt(
          context,
          title: "Edit $name",
          labelText: name,
          hintText: "",
          value: value,
        );
        if (newValue == null) return;

        // Build the right compound config for this field
        final bg.Config cfg = _buildConfigFor(name, newValue);

        bg.BackgroundGeolocation.setConfig(cfg).then((bg.State state) {
          if (!mounted) return;
          setState(() {
            _state = state;
          });
        });
      },
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.0),
          labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
          labelText: name
          // labelText set below
        ),
        child: Text(value?.toString() ?? ''),
      ),
    );
  }

  Text _buildLabel(String label) {
    return Text(label, style: TextStyle(color: Colors.blue, fontSize: 15.0));
  }

  ///
  /// Build geofence test panel for loading a series of geofences along iOS "Freeway Drive" route.
  ///
  Widget _buildGeofenceTestPanel() {
    List<DropdownMenuItem<String>> radiusItems = [];
    radiusItems
        .add(DropdownMenuItem(value: '100', child: Text('100 meters')));
    radiusItems
        .add(DropdownMenuItem(value: '150', child: Text('150 meters')));
    radiusItems
        .add(DropdownMenuItem(value: '200', child: Text('200 meters')));
    radiusItems
        .add(DropdownMenuItem(value: '500', child: Text('500 meters')));
    radiusItems
        .add(DropdownMenuItem(value: '1000', child: Text('1000 meters')));
    radiusItems
        .add(DropdownMenuItem(value: '5000', child: Text('5000 meters')));
    radiusItems
        .add(DropdownMenuItem(value: '10000', child: Text('10000 meters')));

    List<DropdownMenuItem<String>> loiteringDelayItems = [];
    loiteringDelayItems
        .add(DropdownMenuItem(value: '1000', child: Text('1000 ms')));
    loiteringDelayItems
        .add(DropdownMenuItem(value: '5000', child: Text('5000 ms')));
    loiteringDelayItems
        .add(DropdownMenuItem(value: '10000', child: Text('10000 ms')));
    loiteringDelayItems
        .add(DropdownMenuItem(value: '30000', child: Text('30000 ms')));
    loiteringDelayItems
        .add(DropdownMenuItem(value: '60000', child: Text('60000 ms')));

    return SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
              child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                      minWidth: 150.0,
                      color: Colors.red,
                      onPressed: _onClickRemoveGeofences,
                      child: Text('Remove Geofences',
                          style: TextStyle(color: Colors.white))),
                  MaterialButton(
                      minWidth: 150.0,
                      color: Colors.blue,
                      onPressed: _onClickAddGeofences,
                      child: Text('Add Geofences',
                          style: TextStyle(color: Colors.white)))
                ]),
            InputDecorator(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
                  labelText: "Radius",
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        isDense: true,
                        value: _radius.toInt().toString(),
                        items: radiusItems,
                        onChanged: (String? value) {
                          setState(() {
                            _radius = double.parse(value!);
                          });
                        }))),
            InputDecorator(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 0.0, left: 10.0, bottom: 0.0),
                  labelStyle: TextStyle(color: Colors.blue),
                  //labelText: name
                ),
                child: Row(children: <Widget>[
                  Expanded(flex: 3, child: _buildLabel("notifyOnEntry")),
                  Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Switch(
                                value: _notifyOnEntry,
                                onChanged: (bool value) {
                                  setState(() {
                                    _notifyOnEntry = value;
                                  });
                                })
                          ]))
                ])),
            InputDecorator(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 0.0, left: 10.0, bottom: 0.0),
                  labelStyle: TextStyle(color: Colors.blue),
                  //labelText: name
                ),
                child: Row(children: <Widget>[
                  Expanded(flex: 3, child: _buildLabel("notifyOnExit")),
                  Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Switch(
                                value: _notifyOnExit,
                                onChanged: (bool value) {
                                  setState(() {
                                    _notifyOnExit = value;
                                  });
                                })
                          ]))
                ])),
            InputDecorator(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 0.0, left: 10.0, bottom: 0.0),
                  labelStyle: TextStyle(color: Colors.blue),
                  //labelText: name
                ),
                child: Row(children: <Widget>[
                  Expanded(flex: 3, child: _buildLabel("notifyOnDwell")),
                  Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Switch(
                                value: _notifyOnDwell,
                                onChanged: (bool value) {
                                  setState(() {
                                    _notifyOnDwell = value;
                                  });
                                })
                          ]))
                ])),
            InputDecorator(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
                  labelText: "loiteringDelay (ms)",
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        isDense: true,
                        value: _loiteringDelay.toString(),
                        items: loiteringDelayItems,
                        onChanged: (String? value) {
                          setState(() {
                            _loiteringDelay = int.parse(value!);
                          });
                        }))),
          ]));
        }, childCount: 1),
        itemExtent: 330.0);
  }

  void Function(String?) _createSelectChangeHandler(Map setting) {
    String type = setting['dataType'];
    String name = setting['name'];
    switch (name) {
      case 'trackingMode':
        void onSuccess(bg.State state) {
          setState(() {
            _state = state;
          });
        }
        void onFailure(error) {
          print('[Error] failed to start the plugin: $error');
        }
        return (String? value) {
          int trackingMode = int.parse(value!);
          if (trackingMode == 1) {
            bg.BackgroundGeolocation.start()
                .then(onSuccess)
                .catchError(onFailure);
          } else {
            bg.BackgroundGeolocation.startGeofences()
                .then(onSuccess)
                .catchError(onFailure);
          }
        };
        break;
      default:
        return (String? value) {
          bg.Config config = bg.Config();
          print("select value: $name: $value");
          switch (type) {
            case 'integer':
              config.set(name, int.parse(value!));
              break;
            default:
              config.set(name, value);
              break;
          }
          bg.BackgroundGeolocation.setConfig(config).then((bg.State state) {
            setState(() {
              _state = state;
            });
          });
        };
    }
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
}

dynamic _readConfigValue(bg.State state, String name) {
  switch (name) {
  // ---- GEOLOCATION ----
    case 'distanceFilter':
      return state.geolocation.distanceFilter;
    case 'desiredAccuracy':
      return state.geolocation.desiredAccuracy?.id;
    case 'useSignificantChangesOnly':
      return state.geolocation.useSignificantChangesOnly;
    case 'disableElasticity':
      return state.geolocation.disableElasticity;
    case 'elasticityMultiplier':
      return state.geolocation.elasticityMultiplier;
    case 'geofenceProximityRadius':
      return state.geolocation.geofenceProximityRadius;
    case 'stopTimeout':
      return state.geolocation.stopTimeout;
    case 'activityType':
      return state.geolocation.activityType?.id;
  // ---- HTTP ----
    case 'url':
      return state.http.url;
    case 'autoSync':
      return state.http.autoSync;
    case 'disableAutoSyncOnCellular':
      return state.http.disableAutoSyncOnCellular;
    case 'autoSyncThreshold':
      return state.http.autoSyncThreshold;
  // ---- PERSISTENCE ----
    case 'maxRecordsToPersist':
      return state.persistence.maxRecordsToPersist;
    case 'maxDaysToPersist':
      return state.persistence.maxDaysToPersist;
    case 'persistMode':
      return state.persistence.persistMode?.id;
  // ---- APPLICATION ----
    case 'stopOnTerminate':
      return state.app.stopOnTerminate;
    case 'startOnBoot':
      return state.app.startOnBoot;
    case 'heartbeatInterval':
      return state.app.heartbeatInterval;
  // ---- LOGGER ----
    case 'debug':
      return state.logger.debug;
    case 'logLevel':
      return state.logger.logLevel;
    default:
    // fallback to flattened map for any unmapped legacy field
      return state.map[name];
  }
}

bg.Config _buildConfigFor(String name, dynamic value) {
  switch (name) {
  // -------------------------
  // GEOLOCATION
  // -------------------------
    case 'distanceFilter':
      return bg.Config(geolocation: bg.GeoConfig(distanceFilter: (value is num) ? value.toDouble() : double.parse(value)));
    case 'desiredAccuracy': // your dropdown values are ints
      return bg.Config(geolocation: bg.GeoConfig(desiredAccuracy: bg.DesiredAccuracy.from(value)));
    case 'useSignificantChangesOnly':
      return bg.Config(geolocation: bg.GeoConfig(useSignificantChangesOnly: value as bool));
    case 'disableElasticity':
      return bg.Config(geolocation: bg.GeoConfig(disableElasticity: value as bool));
    case 'elasticityMultiplier':
      return bg.Config(geolocation: bg.GeoConfig(elasticityMultiplier: (value is num) ? value.toDouble() : double.parse(value)));
    case 'geofenceProximityRadius':
      return bg.Config(geolocation: bg.GeoConfig(geofenceProximityRadius: int.parse('$value')));
    case 'stopAfterElapsedMinutes':
      return bg.Config(geolocation: bg.GeoConfig(stopAfterElapsedMinutes: int.parse('$value')));
    case 'locationAuthorizationRequest':
      return bg.Config(geolocation: bg.GeoConfig(locationAuthorizationRequest: value as String));
    case 'stationaryRadius':
      return bg.Config(geolocation: bg.GeoConfig(stationaryRadius: int.parse('$value')));
    case 'stopTimeout': // moved to GeoConfig
      return bg.Config(geolocation: bg.GeoConfig(stopTimeout: int.parse('$value')));
    case 'activityType':
      return bg.Config(geolocation: bg.GeoConfig(activityType: bg.ActivityType.from(value is int ? value : int.parse('$value'))));
    case 'showsBackgroundLocationIndicator':
      return bg.Config(geolocation: bg.GeoConfig(showsBackgroundLocationIndicator: value as bool));
    case 'locationUpdateInterval':
      return bg.Config(geolocation: bg.GeoConfig(locationUpdateInterval: int.parse('$value')));
    case 'fastestLocationUpdateInterval':
      return bg.Config(geolocation: bg.GeoConfig(fastestLocationUpdateInterval: int.parse('$value')));
    case 'deferTime':
      return bg.Config(geolocation: bg.GeoConfig(deferTime: int.parse('$value')));
    case 'geofenceModeHighAccuracy':
      return bg.Config(geolocation: bg.GeoConfig(geofenceModeHighAccuracy: value as bool));
    case 'disableLocationAuthorizationAlert':
      return bg.Config(geolocation: bg.GeoConfig(disableLocationAuthorizationAlert: value as bool));

  // -------------------------
  // ACTIVITY (leave only true activity-recognition fields here)
  // -------------------------
    case 'disableMotionActivityUpdates':
      return bg.Config(
        activity: bg.ActivityConfig(
          disableMotionActivityUpdates: value as bool,
        ),
      );
  // If you still expose activityRecognitionInterval/minimum confidence, route here.

  // -------------------------
  // HTTP
  // -------------------------
    case 'url':
      return bg.Config(http: bg.HttpConfig(url: value as String));
    case 'autoSync':
      return bg.Config(http: bg.HttpConfig(autoSync: value as bool));
    case 'disableAutoSyncOnCellular':
      return bg.Config(http: bg.HttpConfig(disableAutoSyncOnCellular: value as bool));
    case 'autoSyncThreshold':
      return bg.Config(http: bg.HttpConfig(autoSyncThreshold: int.parse('$value')));
    case 'batchSync':
      return bg.Config(http: bg.HttpConfig(batchSync: value as bool));
    case 'maxBatchSize':
      return bg.Config(http: bg.HttpConfig(maxBatchSize: int.parse('$value')));

  // -------------------------
  // PERSISTENCE
  // -------------------------
    case 'maxRecordsToPersist':
      return bg.Config(persistence: bg.PersistenceConfig(maxRecordsToPersist: int.parse('$value')));
    case 'maxDaysToPersist':
      return bg.Config(persistence: bg.PersistenceConfig(maxDaysToPersist: int.parse('$value')));
    case 'persistMode':
    // Your UI uses raw ints; map them to the enum if you’ve switched:
    // values [2, 1, -1, 0]  -> PersistMode.all, location, geofence, none
      final v = int.parse('$value');
      final mode = {
        2: bg.PersistMode.all,
        1: bg.PersistMode.location,
        -1: bg.PersistMode.geofence,
        0: bg.PersistMode.none,
      }[v]!;
      return bg.Config(persistence: bg.PersistenceConfig(persistMode: mode));

  // -------------------------
  // APPLICATION
  // -------------------------
    case 'stopOnTerminate':
      return bg.Config(app: bg.AppConfig(stopOnTerminate: value as bool));
    case 'startOnBoot':
      return bg.Config(app: bg.AppConfig(startOnBoot: value as bool));
    case 'heartbeatInterval':
      return bg.Config(app: bg.AppConfig(heartbeatInterval: double.parse('$value')));
    case 'preventSuspend': // iOS
      return bg.Config(app: bg.AppConfig(preventSuspend: value as bool));
    case 'enableHeadless': // Android
      return bg.Config(app: bg.AppConfig(enableHeadless: value as bool));

  // -------------------------
  // LOGGER
  // -------------------------
    case 'debug':
      return bg.Config(logger: bg.LoggerConfig(debug: value as bool));
    case 'logLevel':
      return bg.Config(
        logger: bg.LoggerConfig(
          logLevel: bg.LogLevel.from(value), // accepts String/int/enum
        ),
      );
    case 'logMaxDays':
      return bg.Config(logger: bg.LoggerConfig(logMaxDays: int.parse('$value')));

    default:
    // Fallback — preserves any old flat keys (will still work due to your State flattener)
      final c = bg.Config();
      c.set(name, value);
      return c;
  }
}

///
/// SIMPLE Hash of most of the plugin's available settings.
///
const PLUGIN_SETTINGS = {
  'common': [
    // Geolocation
    {
      'name': 'trackingMode',
      'group': 'geolocation',
      'dataType': 'string',
      'inputType': 'select',
      'labels': ['Location + Geofences', 'Geofences only'],
      'values': [1, 0],
      'defaultValue': 1
    },
    {
      'name': 'locationAuthorizationRequest',
      'group': 'geolocation',
      'dataType': 'string',
      'inputType': 'select',
      'labels': ['Always', 'WhenInUse', 'Any'],
      'values': ['Always', 'WhenInUse', 'Any'],
      'defaultValue': 'Always'
    },
    {
      'name': 'desiredAccuracy',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'labels': ['NAVIGATION', 'HIGH', 'MEDIUM', 'LOW', 'MINIMUM'],
      'values': [-2, -1, 10, 100, 1000],
      'defaultValue': 0
    },
    {
      'name': 'distanceFilter',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 10, 20, 50, 100, 500],
      'defaultValue': 20
    },
    {
      'name': 'disableElasticity',
      'group': 'geolocation',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    {
      'name': 'elasticityMultiplier',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 1, 2, 3, 5, 10],
      'defaultValue': 1
    },
    {
      'name': 'geofenceProximityRadius',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [1000, 1500, 2000, 5000, 10000, 100000],
      'defaultValue': 1000
    },
    {
      'name': 'stopAfterElapsedMinutes',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [-1, 0, 1, 2, 5, 10, 15],
      'defaultValue': 0
    },
    {
      'name': 'desiredOdometerAccuracy',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [10, 20, 50, 100, 500],
      'defaultValue': 100
    },
    {
      'name': 'useSignificantChangesOnly',
      'group': 'geolocation',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    // Activity Recognition
    {
      'name': 'stopTimeout',
      'group': 'activity recognition',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 1, 5, 10, 15],
      'defaultValue': 1
    },
    {
      'name': 'disableMotionActivityUpdates',
      'group': 'activity recognition',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    {
      'name': 'disableStopDetection',
      'group': 'activity recognition',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    // HTTP & Persistence
    {
      'name': 'url',
      'group': 'http',
      'inputType': 'text',
      'dataType': 'string',
      'defaultValue': 'http://your.server.com/endpoint'
    },
    {
      'name': 'autoSync',
      'group': 'http',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': true
    },
    {
      'name': 'disableAutoSyncOnCellular',
      'group': 'http',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    {
      'name': 'autoSyncThreshold',
      'group': 'http',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 5, 10, 25, 50, 100],
      'defaultValue': 0
    },
    {
      'name': 'batchSync',
      'group': 'http',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    {
      'name': 'maxBatchSize',
      'group': 'http',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [-1, 5, 10, 50, 100],
      'defaultValue': -1
    },
    {
      'name': 'maxRecordsToPersist',
      'group': 'http',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [-1, 0, 1, 3, 10, 100],
      'defaultValue': -1
    },
    {
      'name': 'maxDaysToPersist',
      'group': 'http',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [-1, 1, 2, 3, 5, 7, 14],
      'defaultValue': -1
    },
    {
      'name': 'persistMode',
      'group': 'http',
      'dataType': 'integer',
      'inputType': 'select',
      'labels': ['ALL', 'LOCATIONS', 'GEOFENCES', 'NONE'],
      'values': [2, 1, -1, 0],
      'defaultValue': 2
    },
    // Application
    {
      'name': 'stopOnTerminate',
      'group': 'application',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': true
    },
    {
      'name': 'startOnBoot',
      'group': 'application',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    {
      'name': 'heartbeatInterval',
      'group': 'application',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [-1, 60, (2 * 60), (5 * 60), (15 * 60)],
      'defaultValue': 60
    },
    // Logging & Debug
    {
      'name': 'debug',
      'group': 'debug',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': true
    },
    {
      'name': 'logLevel',
      'group': 'debug',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 1, 2, 3, 4, 5],
      'labels': ['OFF', 'ERROR', 'WARN', 'INFO', 'DEBUG', 'VERBOSE'],
      'defaultValue': 'VERBOSE'
    },
    {
      'name': 'logMaxDays',
      'group': 'debug',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [1, 2, 3, 4, 5, 6, 7],
      'defaultValue': 3
    }
  ],
  'ios': [
    // Geolocation
    {
      'name': 'stationaryRadius',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 25, 50, 100, 500, 1000, 5000],
      'defaultValue': 25
    },
    {
      'name': 'activityType',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [1, 2, 3, 4],
      'labels': [
        'OTHER',
        'AUTOMOTIVE_NAVIGATION',
        'FITNESS',
        'OTHER_NAVIGATION'
      ],
      'defaultValue': 'OTHER'
    },
    {
      'name': 'showsBackgroundLocationIndicator',
      'group': 'geolocation',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    // Application
    {
      'name': 'preventSuspend',
      'group': 'application',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    // Activity Recognition
    {
      'name': 'stopDetectionDelay',
      'group': 'activity recognition',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 1, 5, 10, 15],
      'defaultValue': 0
    }
  ],
  'android': [
    // Geolocation
    {
      'name': 'locationUpdateInterval',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 1000, 5000, 10000, 30000, 60000],
      'defaultValue': 5000
    },
    {
      'name': 'fastestLocationUpdateInterval',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [-1, 0, 1000, 5000, 10000, 30000, 60000],
      'defaultValue': 1000
    },
    {
      'name': 'deferTime',
      'group': 'geolocation',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, (10 * 1000), (30 * 1000), (60 * 1000), (5 * 60 * 1000)],
      'defaultValue': 0
    },
    {
      'name': 'geofenceModeHighAccuracy',
      'group': 'geolocation',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
    // Activity Recognition
    {
      'name': 'motionTriggerDelay',
      'group': 'activity recognition',
      'dataType': 'integer',
      'inputType': 'select',
      'values': [0, 10000, 30000, 60000],
      'defaultValue': 0
    },
    // Application
    {
      'name': 'enableHeadless',
      'group': 'application',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': true
    },
    {
      'name': 'notificationPriority',
      'group': 'application',
      'dataType': 'string',
      'inputType': 'select',
      'values': [0, 1, -1, 2, -2],
      'labels': ['DEFAULT', 'HIGH', 'LOW', 'MAX', 'MIN'],
      'defaultValue': 'DEFAULT'
    },
    {
      'name': 'disableLocationAuthorizationAlert',
      'group': 'application',
      'dataType': 'boolean',
      'inputType': 'toggle',
      'values': [true, false],
      'defaultValue': false
    },
  ]
};
