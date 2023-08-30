import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart'
    as util;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import './config/env.dart';

class RegistrationView extends StatefulWidget {
  @override
  State createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  static const USERNAME_REGEXP = r"^[a-zA-Z0-9_-]*$";

  bg.DeviceInfo? _deviceInfo;
  String? _deviceId;
  String? _orgname;
  String? _username;

  final _formKey = GlobalKey<FormState>();
  final _orgnameController = TextEditingController();
  final _usernameController = TextEditingController();

  void initState() {
    super.initState();

    _initPlatformState();
  }

  void _initPlatformState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? orgname = prefs.getString('orgname');
    String? username = prefs.getString('username');
    setState(() {
      _orgname = (orgname != null) ? orgname : '';
      _username = (username != null) ? username : '';
    });

    bg.DeviceInfo.getInstance().then((bg.DeviceInfo info) {
      setState(() {
        _deviceId = "${info.manufacturer} ${info.model}";
        _deviceInfo = info;
      });
    });
  }

  void _onClickClose() {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("CLOSE"));
    Navigator.pop(context, null);
  }

  void _onClickSave() async {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("CLOSE"));
    //Navigator.of(context).pop();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState?.save();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("orgname", _orgname!);
    await prefs.setString("username", _username!);

    await bg.TransistorAuthorizationToken.destroy(ENV.TRACKER_HOST);

    bg.TransistorAuthorizationToken token =
        await bg.TransistorAuthorizationToken.findOrCreate(
            _orgname!, _username!, ENV.TRACKER_HOST);

    bg.BackgroundGeolocation.setConfig(
        bg.Config(transistorAuthorizationToken: token));


    Map result = {"orgname": _orgname, "username": _username};
    Navigator.pop(context, result);
  }

  bool _usernameIsValid(String username) {
    return (username != null) &&
        new RegExp(USERNAME_REGEXP).hasMatch(username) &&
        (username.length > 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_orgname == null || _deviceInfo == null) {
      return new Scaffold(body: new Text('Loading...'));
    }

    _orgnameController.value = TextEditingValue(
        text: _orgname!,
        selection: TextSelection.collapsed(offset: _orgname!.length));
    _usernameController.value = TextEditingValue(
        text: _username!,
        selection: TextSelection.collapsed(offset: _username!.length));

    return new Scaffold(
      appBar: new AppBar(
          leading: IconButton(
              onPressed: _onClickClose,
              icon: Icon(Icons.close),
              color: Colors.black),
          title: const Text('Device Registration', textAlign: TextAlign.right),
          foregroundColor: Colors.black,
          backgroundColor: Colors.amberAccent,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            TextButton(
                onPressed: _onClickSave,
                child: Text("REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                )
          ]),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("$_deviceId",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
              TextFormField(
                controller: _orgnameController,
                validator: (value) {
                  if (!_usernameIsValid(value!)) {
                    return 'Invalid organization name.';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _orgname = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    _orgname = value!;
                  });
                },
                //autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Organization name',
                    hintText: 'eg. Company name'),
              ),
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (!_usernameIsValid(value!)) {
                    return 'Invalid username.';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    _username = value!;
                  });
                },
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'eg. Github username or initials'),
              ),
              Card(
                  margin: EdgeInsets.only(top: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                            "Please provide an Organization name and User identifier to register your device with the Demo Server."),
                        const Text(""),
                        const Text(
                            "You will access your results at the following url:"),
                        Text("${ENV.TRACKER_HOST}/$_orgname",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
