package com.transistorsoft.flutterbackgroundgeolocationexample;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSBeforeInsertBlock;
import com.transistorsoft.locationmanager.location.TSLocation;

import org.json.JSONObject;

import io.flutter.app.FlutterApplication;

public class Application  extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        // Adding a custom beforeInsertBlock.  If your callback returns null, the insert into the plugin's SQLite db
        // will be cancelled.  If there is no record inserted into SQLite, there will be no HTTP request.
        BackgroundGeolocation.getInstance(this).setBeforeInsertBlock(new TSBeforeInsertBlock() {
            @Override
            public JSONObject onBeforeInsert(TSLocation tsLocation) {
                boolean doInsert = true;
                //
                // Your logic here
                //
                return (doInsert) ? tsLocation.toJson() : null;
            }
        });
    }
}

