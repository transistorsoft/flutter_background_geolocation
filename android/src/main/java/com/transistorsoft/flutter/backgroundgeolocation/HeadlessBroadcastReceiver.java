package com.transistorsoft.flutter.backgroundgeolocation;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;


/**
 * Created by chris on 2018-01-23.
 */

public class HeadlessBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle event = intent.getExtras();
        if (event == null) { return; }
        new HeadlessTask(context.getApplicationContext(), event, new HeadlessTask.Callback() {
            @Override
            public void onComplete() {
                // Do nothing.  This is only required for JobService
            }
        });
    }
}