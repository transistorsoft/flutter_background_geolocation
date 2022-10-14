package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.Manifest;
import android.content.ComponentName;
import android.content.Intent;
import android.location.Location;
import android.os.StrictMode;
import android.util.Log;

import androidx.core.content.ContextCompat;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.TSConfig;
import com.transistorsoft.locationmanager.adapter.callback.TSBeforeInsertBlock;
import com.transistorsoft.locationmanager.device.DeviceSettings;
import com.transistorsoft.locationmanager.location.TSLocation;

import org.json.JSONObject;

import io.flutter.app.FlutterApplication;

public class Application  extends FlutterApplication {

    @Override
    public void onCreate() {
        ////
        // Strict mode.  Should be disabled on RELEASE.
        // NOTE:  This is NOT required for background_geolocation
        //

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

        super.onCreate();

        /**
         * Adding a custom beforeInsertBlock.  If your callback returns null, the insert into the plugin's SQLite db
         * will be cancelled.  If there is no record inserted into SQLite, there will be no HTTP request.
         *
        final TSConfig config = TSConfig.getInstance(this);
        BackgroundGeolocation.getInstance(this).setBeforeInsertBlock(new TSBeforeInsertBlock() {
            @Override
            public JSONObject onBeforeInsert(TSLocation tsLocation) {
                boolean doInsert = true;
                //
                // Your logic here
                //
                // For example, you could do something like this:
                //
                // Location location = tsLocation.getLocation();
                // if (location.getAccuracy() >= 10) {
                //     doInsert = false;
                // }
                //
                float odometer = config.getOdometer();
                return (doInsert) ? tsLocation.toJson() : null;
            }
        });
         *
         *
         */
    }
}

