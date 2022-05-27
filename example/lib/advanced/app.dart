import 'package:flutter/material.dart';
import 'dart:async';

import 'home_view.dart';
import 'main_menu_button.dart';

class AdvancedApp extends StatefulWidget {
  static const String NAME = 'advanced';

  @override
  _AdvancedAppState createState() => new _AdvancedAppState();
}

class _AdvancedAppState extends State<AdvancedApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return new MaterialApp(
        theme: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(secondary:Colors.black),
            brightness: Brightness.light,
            bottomAppBarColor: Colors.amberAccent,
            hintColor: Colors.black12,
            primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              bodyColor: Colors.black,
            )),
        home:
            Scaffold(body: HomeView(), floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, floatingActionButton: MainMenuButton()));
  }
}
