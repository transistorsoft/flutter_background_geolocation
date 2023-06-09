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
  @override
  State createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bg.State? _state = null;

  // Categorized field-lists.
  List<Map> _geolocationSettings = [];
  List<Map> _activityRecognitionSettings = [];
  List<Map> _httpSettings = [];
  List<Map> _applicationSettings = [];
  List<Map> _debugSettings = [];

  // Geofence test params.
  double _radius = 200.0;
  bool _notifyOnEntry = true;
  bool _notifyOnExit = true;
  bool _notifyOnDwell = false;
  int _loiteringDelay = 10000;

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
      return new Scaffold(body: new Text('Loading...'));
    }

    return new Scaffold(
        appBar: new AppBar(
            foregroundColor: Colors.black,
            leading: IconButton(
                onPressed: _onClickClose,
                icon: Icon(Icons.close),
                color: Colors.black),
            title: const Text('Settings'),
            backgroundColor: Theme.of(context).bottomAppBarColor,
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              new PopupMenuButton(
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
        body: new CustomScrollView(
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
    return new SliverAppBar(
      title: new Text(title),
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
    return new SliverFixedExtentList(
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
        field = new Text('field: $name - Unsupported inputType: $inputType');
        break;
    }
    return field;
  }

  Widget _buildSelectField(Map<dynamic, dynamic> setting) {
    List values = setting['values'];
    List? labels = setting['labels'];
    String name = setting['name'];

    dynamic value = _state?.map[name];
    if (value.runtimeType == double) {
      value = value.round();
    }

    List<DropdownMenuItem<String>> menuItems = [];
    bool foundCurrentValue = false;
    values.forEach((dynamic item) {
      if (item == value) {
        foundCurrentValue = true;
      }
      String itemValue = item.toString();
      String itemLabel =
          (labels != null) ? labels[values.indexOf(item)] : itemValue;
      menuItems.add(
          new DropdownMenuItem(child: new Text(itemLabel), value: itemValue));
    });
    // Ensure currently configured value exists as DropdownMenuItem or an exception blows up:
    if (!foundCurrentValue) {
      menuItems.add(new DropdownMenuItem(
          child: new Text(value.toString()), value: value.toString()));
    }
    return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
          labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
          labelText: name,
        ),
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
                isDense: true,
                value: value.toString(),
                items: menuItems,
                onChanged: _createSelectChangeHandler(setting))));
  }

  Widget _buildSwitchField(Map setting) {
    String name = setting['name'];
    bool value = _state?.map[name];
    return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0.0, left: 10.0, bottom: 0.0),
          labelStyle: TextStyle(color: Colors.blue),
          //labelText: name
        ),
        child: Row(children: <Widget>[
          Expanded(flex: 3, child: _buildLabel(name)),
          Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Switch(
                        value: value,
                        onChanged: _createSwitchChangeHandler(name))
                  ]))
        ]));
  }

  Widget _buildTextField(Map setting) {
    String name = setting['name'];
    String value = _state?.map[name];

    return GestureDetector(
        onTap: () async {
          value = await util.Dialog.prompt(context,
              title: "Edit $name", labelText: name, hintText: "", value: value);
          bg.Config config = bg.Config().set(name, value);
          bg.BackgroundGeolocation.setConfig(config).then((bg.State state) {
            setState(() {
              _state = state;
            });
          });
        },
        child: InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 10.0, top: 10.0, bottom: 20.0),
              labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0),
              labelText: name,
            ),
            child: Text(value)));
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
        .add(new DropdownMenuItem(child: Text('100 meters'), value: '100'));
    radiusItems
        .add(new DropdownMenuItem(child: Text('150 meters'), value: '150'));
    radiusItems
        .add(new DropdownMenuItem(child: Text('200 meters'), value: '200'));
    radiusItems
        .add(new DropdownMenuItem(child: Text('500 meters'), value: '500'));
    radiusItems
        .add(new DropdownMenuItem(child: Text('1000 meters'), value: '1000'));
    radiusItems
        .add(new DropdownMenuItem(child: Text('5000 meters'), value: '5000'));
    radiusItems
        .add(new DropdownMenuItem(child: Text('10000 meters'), value: '10000'));

    List<DropdownMenuItem<String>> loiteringDelayItems = [];
    loiteringDelayItems
        .add(new DropdownMenuItem(child: Text('1000 ms'), value: '1000'));
    loiteringDelayItems
        .add(new DropdownMenuItem(child: Text('5000 ms'), value: '5000'));
    loiteringDelayItems
        .add(new DropdownMenuItem(child: Text('10000 ms'), value: '10000'));
    loiteringDelayItems
        .add(new DropdownMenuItem(child: Text('30000 ms'), value: '30000'));
    loiteringDelayItems
        .add(new DropdownMenuItem(child: Text('60000 ms'), value: '60000'));

    return SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
              child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                      minWidth: 150.0,
                      child: Text('Remove Geofences',
                          style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: _onClickRemoveGeofences),
                  MaterialButton(
                      minWidth: 150.0,
                      child: Text('Add Geofences',
                          style: TextStyle(color: Colors.white)),
                      color: Colors.blue,
                      onPressed: _onClickAddGeofences)
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
        dynamic onSuccess = (bg.State state) {
          setState(() {
            _state = state;
          });
        };
        dynamic onFailure = (error) {
          print('[Error] failed to start the plugin: $error');
        };
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
          bg.Config config = new bg.Config();
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
      'labels': ['Always', 'WhenInUse'],
      'values': ['Always', 'WhenInUse'],
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
