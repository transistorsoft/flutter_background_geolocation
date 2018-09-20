package com.transistorsoft.flutter.backgroundgeolocation;

import android.content.Context;
import android.os.Bundle;

import com.transistorsoft.locationmanager.logger.TSLog;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;

import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;

public class HeadlessTask {
    // Hard-coded time-limit for headless-tasks is 30000 @todo configurable?
    private static int TASK_TIMEOUT = 30000;

    private static MethodChannel sChannel;
    private static FlutterNativeView sSharedFlutterView;
    private static long sCallbackId;
    private String mAppBundlePath;
    private static Callback sCallback;
    private static PluginRegistry.PluginRegistrantCallback sPluginRegistrantCallback;

    public Bundle mEvent;

    static boolean setSharedFlutterView(FlutterNativeView view) {
        if (sSharedFlutterView != null && sSharedFlutterView != view) {
            TSLog.logger.info(TSLog.info("[HeadlessTask] setSharedFlutterView tried to overwrite an existing FlutterNativeView"));
            return false;
        }
        sSharedFlutterView = view;
        return true;
    }

    static void register(Context context, long callbackId, MethodChannel channel) {
        /* TODO FlutterRunArguments doesn't seem ready for this.
        sCallbackId = callbackId;
        sChannel = channel;

        FlutterMain.ensureInitializationComplete(context, null);
        String mAppBundlePath = FlutterMain.findAppBundlePath(context);
        FlutterCallbackInformation cb = FlutterCallbackInformation.lookupCallbackInformation(callbackId);
        if (cb == null) {
            TSLog.logger.debug("HeadlessTask#register: Fatal: failed to find callback");
            return;
        }
        sSharedFlutterView = new FlutterNativeView(context.getApplicationContext(), true);
        if (mAppBundlePath != null ) {
            TSLog.logger.debug("HeadlessTask#register: Registered HeadlessTask");

            FlutterRunArguments args = new FlutterRunArguments();
            args.bundlePath = mAppBundlePath;
            args.entrypoint = cb.callbackName;
            args.libraryPath = cb.callbackLibraryPath;
            sSharedFlutterView.runFromBundle(args);

            sPluginRegistrantCallback.registerWith(sSharedFlutterView.getPluginRegistry());
        }
        */
    }

    HeadlessTask(Context context, Bundle event, Callback callback) {
        sCallback = callback;
        mEvent = event;

        String eventName = event.getString("event");

        TSLog.logger.debug("\uD83D\uDC80 [HeadlessTask] event: " + eventName + " (TODO: Flutter headless callback implementation)");

        // TODO want to execute a headless Dart callback here.  Not yet sure how
        //sChannel.invokeMethod("", new Object[]{sCallbackId});

        try {
            JSONObject params = new JSONObject(event.getString("params"));
            TSLog.logger.debug(params.toString());
            finish();
        } catch (JSONException e) {
            TSLog.logger.error(TSLog.error(e.getMessage()));
            finish();
            e.printStackTrace();
        }
    }

    public Bundle getEvent() {
        return mEvent;
    }

    public void finish() {
        sCallback.onComplete();
    }

    public interface Callback {
        void onComplete();
    }

}
