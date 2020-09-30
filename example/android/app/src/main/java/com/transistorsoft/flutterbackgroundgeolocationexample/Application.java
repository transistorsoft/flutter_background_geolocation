package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.content.Context;
import android.util.Log;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSBeforeInsertBlock;
import com.transistorsoft.locationmanager.location.TSLocation;
import com.transistorsoft.locationmanager.logger.TSLog;

import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;

import io.flutter.app.FlutterApplication;

public class Application  extends FlutterApplication {
    @Override
    public void onCreate() {
        ////
        // Strict mode.  Should be disabled on RELEASE.
        // NOTE:  This is NOT required for background_geolocation
        //
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

    }




}

