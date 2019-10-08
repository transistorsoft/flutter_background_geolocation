package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.os.StrictMode;

import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;
import com.transistorsoft.flutter.backgroundgeolocation.FLTBackgroundGeolocationPlugin;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class Application  extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        // Strict mode.  Should be disabled on RELEASE.
        /*
        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
                .detectDiskReads()
                .detectDiskWrites()
                .detectAll()
                .penaltyLog()
                .build());

        StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()
                .detectLeakedSqlLiteObjects()
                .detectLeakedClosableObjects()
                .penaltyLog()
                .penaltyDeath()
                .build());
        */
        super.onCreate();

        FLTBackgroundGeolocationPlugin.setPluginRegistrant(this);
        BackgroundFetchPlugin.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }
}
