package com.transistorsoft.flutter.backgroundgeolocation;

import android.content.Context;
import android.os.Bundle;

import com.transistorsoft.locationmanager.logger.TSLog;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;

import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;

public class HeadlessTask implements MethodChannel.MethodCallHandler {
    // Hard-coded time-limit for headless-tasks is 30000 @todo configurable?
    private static int TASK_TIMEOUT = 30000;
    private static PluginRegistry.PluginRegistrantCallback sPluginRegistrantCallback;
    private static Long sRegistrationCallbackId;
    private static Long sClientCallbackId;
    private static FlutterNativeView sBackgroundFlutterView;
    private static MethodChannel sDispatchChannelChannel;
    private static final AtomicBoolean sHeadlessTaskRegistered = new AtomicBoolean(false);

    private Callback mCallback;
    private Bundle mEvent;

    // Called by Application#onCreate
    public static void setPluginRegistrant(PluginRegistry.PluginRegistrantCallback callback) {
        sPluginRegistrantCallback = callback;
    }

    // Called by FLTBackgroundGeolocationPlugin
    static boolean register(List<Long> callbacks) {
        if (sRegistrationCallbackId != null) {
            return false;
        }
        sRegistrationCallbackId = callbacks.get(0);
        sClientCallbackId = callbacks.get(1);
        return true;
    }

    HeadlessTask(Context context, Bundle event, Callback callback) {
        String eventName = event.getString("event");
        TSLog.logger.debug("\uD83D\uDC80 [HeadlessTask " + hashCode() + "] event: " + eventName);

        FlutterMain.ensureInitializationComplete(context, null);

        mCallback = callback;
        mEvent = event;

        if (sBackgroundFlutterView == null) {
            FlutterCallbackInformation callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(sRegistrationCallbackId);
            if (callbackInfo == null) {
                TSLog.logger.error(TSLog.error("Fatal: failed to find callback"));
                finish();
                return;
            }
            sBackgroundFlutterView = new FlutterNativeView(context, true);

            // Create the Transmitter channel
            sDispatchChannelChannel = new MethodChannel(sBackgroundFlutterView, FLTBackgroundGeolocationPlugin.PLUGIN_ID + "/headless", JSONMethodCodec.INSTANCE);
            sDispatchChannelChannel.setMethodCallHandler(this);

            sPluginRegistrantCallback.registerWith(sBackgroundFlutterView.getPluginRegistry());

            // Dispatch back to client for initialization.
            FlutterRunArguments args = new FlutterRunArguments();
            args.bundlePath = FlutterMain.findAppBundlePath(context);
            args.entrypoint = callbackInfo.callbackName;
            args.libraryPath = callbackInfo.callbackLibraryPath;
            sBackgroundFlutterView.runFromBundle(args);
        }

        // Create the Receiver channel for receiving calls to #finsh
        String channelName = FLTBackgroundGeolocationPlugin.PLUGIN_ID + "/headless/" + hashCode();
        new MethodChannel(sBackgroundFlutterView, channelName, JSONMethodCodec.INSTANCE).setMethodCallHandler(this);

        synchronized(sHeadlessTaskRegistered) {
            if (!sHeadlessTaskRegistered.get()) {
                // Queue up geofencing events while background isolate is starting
                TSLog.logger.debug("[HeadlessTask] waiting for client to initialize");
            } else {
                // Callback method name is intentionally left blank.
                dispatchEvent();
            }
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        TSLog.logger.debug("$ " + call.method);
        if (call.method.equalsIgnoreCase("initialized")) {
            synchronized(sHeadlessTaskRegistered) {
                sHeadlessTaskRegistered.set(true);
            }
            dispatchEvent();
        } else if (call.method.equalsIgnoreCase("finish")) {
            finish();
        } else {
            result.notImplemented();
        }
    }

    // Client callbacks signal completion of jobs by calling #finish.
    public void finish() {
        TSLog.logger.debug("\uD83D\uDC80 [HeadlessTask " + hashCode() + "] ❌");
        mCallback.onComplete();
    }

    // Send event to Client.
    private void dispatchEvent() {
        JSONObject response = new JSONObject();
        try {
            response.put("taskId", String.valueOf(hashCode()));
            response.put("callbackId", sClientCallbackId);
            response.put("event", mEvent.getString("event"));
            response.put("params", new JSONObject(mEvent.getString("params")));
            sDispatchChannelChannel.invokeMethod("", response);
        } catch (JSONException e) {
            TSLog.logger.error(TSLog.error(e.getMessage()));
            e.printStackTrace();
        }
    }

    public interface Callback {
        void onComplete();
    }
}
