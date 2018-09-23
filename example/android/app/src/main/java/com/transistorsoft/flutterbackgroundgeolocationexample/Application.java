package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.util.Log;

import com.transistorsoft.flutter.backgroundgeolocation.HeadlessTask;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class Application  extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        HeadlessTask.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }
}
