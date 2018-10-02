package com.transistorsoft.flutter.backgroundgeolocation;

import android.content.Context;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.event.HeadlessEvent;
import com.transistorsoft.locationmanager.logger.TSLog;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
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
    private static PluginRegistry.PluginRegistrantCallback sPluginRegistrantCallback;
    static private Long sRegistrationCallbackId;
    static private Long sClientCallbackId;

    private FlutterNativeView mBackgroundFlutterView;
    private MethodChannel mDispatchChannelChannel;
    private final AtomicBoolean mHeadlessTaskRegistered = new AtomicBoolean(false);

    private final List<HeadlessEvent> mEvents = new ArrayList<>();

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

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        TSLog.logger.debug("$ " + call.method);
        if (call.method.equalsIgnoreCase("initialized")) {
            synchronized(mHeadlessTaskRegistered) {
                mHeadlessTaskRegistered.set(true);
            }
            dispatch();
        } else {
            result.notImplemented();
        }
    }

    @Subscribe(threadMode=ThreadMode.MAIN)
    public void onHeadlessEvent(HeadlessEvent event) {
        String eventName = event.getName();
        TSLog.logger.debug("\uD83D\uDC80 [HeadlessTask " + eventName + "]");

        synchronized (mEvents) {
            mEvents.add(event);
            if (mBackgroundFlutterView == null) {
                initFlutterView(event.getContext());
            }
        }

        synchronized(mHeadlessTaskRegistered) {
            if (!mHeadlessTaskRegistered.get()) {
                // Queue up events while background isolate is starting
                TSLog.logger.debug("[HeadlessTask] waiting for client to initialize");
            } else {
                // Callback method name is intentionally left blank.
                dispatch();
            }
        }
    }

    // Send event to Client.
    private void dispatch() {
        synchronized (mEvents) {
            for (HeadlessEvent event : mEvents) {
                JSONObject response = new JSONObject();
                try {
                    response.put("callbackId", sClientCallbackId);
                    response.put("event", event.getName());
                    response.put("params", getEventObject(event));
                    mDispatchChannelChannel.invokeMethod("", response);
                } catch (JSONException e) {
                    TSLog.logger.error(TSLog.error(e.getMessage()));
                    e.printStackTrace();
                }
            }
            mEvents.clear();
        }
    }

    private Object getEventObject(HeadlessEvent event) {
        String name = event.getName();
        Object result = null;
        if (name.equals(BackgroundGeolocation.EVENT_TERMINATE)) {
            result = event.getTerminateEvent();
        } else if (name.equals(BackgroundGeolocation.EVENT_LOCATION)) {
            result = event.getLocationEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_MOTIONCHANGE)) {
            result = event.getMotionChangeEvent().getLocation().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_HTTP)) {
            result = event.getHttpEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_PROVIDERCHANGE)) {
            result = event.getProviderChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_PROVIDERCHANGE)) {
            result = event.getProviderChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_ACTIVITYCHANGE)) {
            result = event.getActivityChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_SCHEDULE)) {
            result = event.getScheduleEvent();
        } else if (name.equals(BackgroundGeolocation.EVENT_BOOT)) {
            result = event.getBootEvent();
        } else if (name.equals(BackgroundGeolocation.EVENT_GEOFENCE)) {
            result = event.getGeofenceEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_HEARTBEAT)) {
            result = event.getHeartbeatEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_CONNECTIVITYCHANGE)) {
            result = event.getConnectivityChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_POWERSAVECHANGE)) {
            result = event.getPowerSaveChangeEvent().isPowerSaveMode();
        } else if (name.equals(BackgroundGeolocation.EVENT_ENABLEDCHANGE)) {
            result = event.getEnabledChangeEvent();
        } else {
            TSLog.logger.warn(TSLog.warn("Unknown Headless Event: " + name));
        }
        return result;
    }

    private void initFlutterView(Context context) {
        FlutterCallbackInformation callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(sRegistrationCallbackId);
        if (callbackInfo == null) {
            TSLog.logger.error(TSLog.error("Fatal: failed to find callback"));
            return;
        }
        mBackgroundFlutterView = new FlutterNativeView(context, true);

        // Create the Transmitter channel
        mDispatchChannelChannel = new MethodChannel(mBackgroundFlutterView, FLTBackgroundGeolocationPlugin.PLUGIN_ID + "/headless", JSONMethodCodec.INSTANCE);
        mDispatchChannelChannel.setMethodCallHandler(this);

        sPluginRegistrantCallback.registerWith(mBackgroundFlutterView.getPluginRegistry());

        // Dispatch back to client for initialization.
        FlutterRunArguments args = new FlutterRunArguments();
        args.bundlePath = FlutterMain.findAppBundlePath(context);
        args.entrypoint = callbackInfo.callbackName;
        args.libraryPath = callbackInfo.callbackLibraryPath;
        mBackgroundFlutterView.runFromBundle(args);
    }
}
