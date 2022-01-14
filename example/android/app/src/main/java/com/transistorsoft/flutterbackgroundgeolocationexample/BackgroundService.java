package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.app.Notification;
import android.app.Service;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.ApplicationInfoLoader;
import io.flutter.embedding.engine.loader.FlutterApplicationInfo;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;

public class BackgroundService extends Service {
    static private final String SHARED_PREFERENCES_NAME = "com.transistorsoft.flutterbackgroundgeolocationexample";
    static private final String KEY_CALLBACK_RAW_HANDLE = "callbackRawHandle";

    public static void startService (Context context, Long callbackRawHandle){
        final Intent intent = new Intent(context, BackgroundService.class);
        intent
            .putExtra(KEY_CALLBACK_RAW_HANDLE, callbackRawHandle);
        ContextCompat.startForegroundService(context, intent);
    }

    @Nullable
    private FlutterEngine flutterEngine = null;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("BackgroundService", "Creating");
        final Notification notification = new Notifications().buildForegroundNotification(this);
        startForeground(Notifications.NOTIFICATION_ID_BACKGROUND_SERVICE, notification);
    }


    @Override
    public int onStartCommand(@Nullable Intent intent, int flags, int startId) {
        assert intent != null;
        final long callbackRawHandle = intent.getLongExtra(KEY_CALLBACK_RAW_HANDLE, -1);
        if (callbackRawHandle != -1L) setCallbackRawHandle(callbackRawHandle);
        startFlutterNativeView();
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

     @Override
     @Nullable
     public IBinder onBind(Intent intent) {
        return null;
     }

    private void startFlutterNativeView() {
        if (flutterEngine != null) {
            return;
        }

        Log.i("BackgroundService", "Starting FlutterEngine");

        final long handle = getCallbackRawHandle();
        flutterEngine = new FlutterEngine(this);
        FlutterApplicationInfo info = ApplicationInfoLoader.load(this);
        DartExecutor executor = flutterEngine.getDartExecutor();
        String appBundlePath = info.flutterAssetsDir;
        AssetManager assets = this.getAssets();

        final FlutterCallbackInformation callbackInformation = FlutterCallbackInformation.lookupCallbackInformation(handle);

        DartExecutor.DartCallback dartCallback = new DartExecutor.DartCallback(assets, appBundlePath, callbackInformation);
        executor.executeDartCallback(dartCallback);
    }

    private void stopFlutterNativeView() {
        Log.i("BackgroundService", "Stopping FlutterEngine");
        assert flutterEngine != null;
        flutterEngine.destroy();
        flutterEngine = null;
    }

    private Long getCallbackRawHandle() {
        final SharedPreferences prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
        return prefs.getLong(KEY_CALLBACK_RAW_HANDLE, -1);
    }

    private void setCallbackRawHandle(Long handle) {
        final SharedPreferences prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
        prefs.edit().putLong(KEY_CALLBACK_RAW_HANDLE, handle).apply();
    }
}
