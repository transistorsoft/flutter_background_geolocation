package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.util.Log;

import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;
import com.transistorsoft.flutter.backgroundgeolocation.FLTBackgroundGeolocationPlugin;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class Application  extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();

        /* For testing Context.startForeground issue.  Simulate a delay launching app.
        try {
            Log.i("TSLocationManager", "*************************** SLEEPING START 20000ms");
            Thread.sleep(20000);
            Log.i("TSLocationManager", "*************************** SLEEPING DONE");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        */
        FLTBackgroundGeolocationPlugin.setPluginRegistrant(this);
        BackgroundFetchPlugin.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }
}
