package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.os.StrictMode;
import android.util.Log;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.TSConfig;
import com.transistorsoft.locationmanager.adapter.callback.TSBeforeInsertBlock;
import com.transistorsoft.locationmanager.location.TSLocation;

import org.json.JSONException;
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
                //.penaltyDeath()
                .build());

        super.onCreate();

        /**
         * Adding a custom beforeInsertBlock.  If your callback returns null, the insert into the plugin's SQLite db
         * will be cancelled.  If there is no record inserted into SQLite, there will be no HTTP request.
         *
        final TSConfig config = TSConfig.getInstance(this);
        BackgroundGeolocation.getInstance(this).setBeforeInsertBlock(tsLocation -> {
            boolean doInsert = true;
            // Create some fake app logic to insert or not based upon if time is even or odd.
            long time = tsLocation.getLocation().getTime();
            if ((time % 2) > 0) {
                doInsert = false;
            }
            Log.d(BackgroundGeolocation.TAG, "*** [BackgroundGeolocation beforeInsertBlock] doInsert? " + doInsert);

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
            if (doInsert) {
                try {
                    return tsLocation.toJson();
                } catch (JSONException e) {
                    // Should never happen.
                    return null;
                }
            } else {
                return null;
            }
        });
         *
         *
         */

    }
}

