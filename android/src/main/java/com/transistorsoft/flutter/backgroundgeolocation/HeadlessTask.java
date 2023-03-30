package com.transistorsoft.flutter.backgroundgeolocation;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.util.Log;

import androidx.annotation.NonNull;

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

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.ApplicationInfoLoader;
import io.flutter.embedding.engine.loader.FlutterApplicationInfo;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.FlutterCallbackInformation;

public class HeadlessTask implements MethodChannel.MethodCallHandler, Runnable {
    private static final String KEY_REGISTRATION_CALLBACK_ID    = "registrationCallbackId";
    private static final String KEY_CLIENT_CALLBACK_ID          = "clientCallbackId";

    private static PluginRegistry.PluginRegistrantCallback sPluginRegistrantCallback;
    static private Long sRegistrationCallbackId;
    static private Long sClientCallbackId;

    private Context mContext;

    // Deprecated V2
    private MethodChannel mDispatchChannel;
    private static FlutterEngine sBackgroundFlutterEngine;

    private final AtomicBoolean mHeadlessTaskRegistered = new AtomicBoolean(false);
    private final List<HeadlessEvent> mEvents = new ArrayList<>();

    // Called by Application#onCreate.  Must be public.
    public static void setPluginRegistrant(PluginRegistry.PluginRegistrantCallback callback) {
        sPluginRegistrantCallback = callback;
    }

    // Called by FLTBackgroundGeolocationPlugin
    static boolean register(final Context context, final List<Object> callbacks) {
        BackgroundGeolocation.getThreadPool().execute(new RegistrationTask(context, callbacks));
        return true;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        TSLog.logger.debug("$ " + call.method);
        if (call.method.equalsIgnoreCase("initialized")) {
            mHeadlessTaskRegistered.set(true);
            dispatch();
        } else {
            result.notImplemented();
        }
    }

    @SuppressWarnings({"unused"})
    @Subscribe(threadMode=ThreadMode.MAIN)
    public void onHeadlessEvent(HeadlessEvent event) {
        mContext = event.getContext();
        String eventName = event.getName();
        TSLog.logger.debug("\uD83D\uDC80 [HeadlessTask " + eventName + "]");
        synchronized (mEvents) {
            mEvents.add(event);
        }

        BackgroundGeolocation.getThreadPool().execute(new TaskRunner(event));
    }

    @Override
    public void run() {
        dispatch();
    }

    // Send event to Client.
    private void dispatch() {
        if (sBackgroundFlutterEngine == null) {
            startBackgroundIsolate();
        }

        if (!mHeadlessTaskRegistered.get()) {
            // Queue up events while background isolate is starting
            TSLog.logger.debug("[HeadlessTask] waiting for client to initialize");
            return;
        }

        synchronized (mEvents) {
            for (HeadlessEvent event : mEvents) {
                JSONObject response = new JSONObject();
                try {
                    response.put("callbackId", sClientCallbackId);
                    response.put("event", event.getName());
                    response.put("params", getEventObject(event));
                    mDispatchChannel.invokeMethod("", response);
                } catch (JSONException | IllegalStateException e) {
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
            try {
                result = event.getLocationEvent().toJson();
            } catch (JSONException e) {
                TSLog.logger.error(e.getMessage(), e);
            }
        } else if (name.equals(BackgroundGeolocation.EVENT_MOTIONCHANGE)) {
            result = event.getMotionChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_HTTP)) {
            result = event.getHttpEvent().toJson();
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
        } else if (name.equals(BackgroundGeolocation.EVENT_GEOFENCES_CHANGE)) {
            result = event.getGeofencesChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_HEARTBEAT)) {
            result = event.getHeartbeatEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_CONNECTIVITYCHANGE)) {
            result = event.getConnectivityChangeEvent().toJson();
        } else if (name.equals(BackgroundGeolocation.EVENT_POWERSAVECHANGE)) {
            result = event.getPowerSaveChangeEvent().isPowerSaveMode();
        } else if (name.equals(BackgroundGeolocation.EVENT_ENABLEDCHANGE)) {
            result = event.getEnabledChangeEvent();
        } else if (name.equals(BackgroundGeolocation.EVENT_AUTHORIZATION)) {
            result = event.getAuthorizationEvent().toJson();
        } else if (name.equalsIgnoreCase(BackgroundGeolocation.EVENT_NOTIFICATIONACTION)) {
            result = event.getNotificationEvent();
        } else {
            TSLog.logger.warn(TSLog.warn("Unknown Headless Event: " + name));
        }
        return result;
    }

    private void startBackgroundIsolate() {
        if (sBackgroundFlutterEngine != null) {
            Log.w(BackgroundGeolocation.TAG, "Background isolate already started");
            return;
        }

        FlutterApplicationInfo info = ApplicationInfoLoader.load(mContext);
        String appBundlePath = info.flutterAssetsDir;

        AssetManager assets = mContext.getAssets();
        if (appBundlePath != null && !mHeadlessTaskRegistered.get()) {
            sBackgroundFlutterEngine = new FlutterEngine(mContext);
            DartExecutor executor = sBackgroundFlutterEngine.getDartExecutor();
            // Create the Transmitter channel
            mDispatchChannel = new MethodChannel(executor, BackgroundGeolocationModule.PLUGIN_ID + "/headless", JSONMethodCodec.INSTANCE);
            mDispatchChannel.setMethodCallHandler(this);

            FlutterCallbackInformation callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(sRegistrationCallbackId);

            if (callbackInfo == null) {
                TSLog.logger.error(TSLog.error("Fatal: failed to find callback: " + sRegistrationCallbackId));
                return;
            }
            DartExecutor.DartCallback dartCallback = new DartExecutor.DartCallback(assets, appBundlePath, callbackInfo);
            executor.executeDartCallback(dartCallback);

            // The pluginRegistrantCallback should only be set in the V1 embedding as
            // plugin registration is done via reflection in the V2 embedding.
            if (sPluginRegistrantCallback != null) {
                sPluginRegistrantCallback.registerWith(new ShimPluginRegistry(sBackgroundFlutterEngine));
            }
        }
    }
    /**
     * Persist callbacks in Background-thread.
     */
    static class RegistrationTask implements Runnable {
        private Context mContext;
        private List<Object> mCallbacks;

        RegistrationTask(Context context, List<Object>callbacks) {
            mContext = context;
            mCallbacks = callbacks;
        }

        @Override
        public void run() {
            SharedPreferences prefs = mContext.getSharedPreferences(HeadlessTask.class.getName(), Context.MODE_PRIVATE);

            // There is weirdness with the class of these callbacks (Integer vs Long) between assembleDebug vs assembleRelease.
            Object cb1 = mCallbacks.get(0);
            Object cb2 = mCallbacks.get(1);

            SharedPreferences.Editor editor = prefs.edit();
            if (cb1.getClass() == Long.class) {
                editor.putLong(KEY_REGISTRATION_CALLBACK_ID, (Long) cb1);
            } else if (cb1.getClass() == Integer.class) {
                editor.putLong(KEY_REGISTRATION_CALLBACK_ID, ((Integer) cb1).longValue());
            }

            if (cb2.getClass() == Long.class) {
                editor.putLong(KEY_CLIENT_CALLBACK_ID, (Long) cb2);
            } else if (cb2.getClass() == Integer.class) {
                editor.putLong(KEY_CLIENT_CALLBACK_ID, ((Integer) cb2).longValue());
            }
            editor.apply();

            sRegistrationCallbackId = prefs.getLong(KEY_REGISTRATION_CALLBACK_ID, -1);
            sClientCallbackId = prefs.getLong(KEY_CLIENT_CALLBACK_ID, -1);
        }
    }

    class TaskRunner implements Runnable {
        private HeadlessEvent mEvent;
        TaskRunner(HeadlessEvent event) {
            mEvent = event;
        }
        @Override
        public void run() {
            SharedPreferences prefs = mEvent.getContext().getSharedPreferences(HeadlessTask.class.getName(), Context.MODE_PRIVATE);
            sRegistrationCallbackId = prefs.getLong(KEY_REGISTRATION_CALLBACK_ID, -1);
            sClientCallbackId = prefs.getLong(KEY_CLIENT_CALLBACK_ID, -1);

            if ((sRegistrationCallbackId == -1) || (sClientCallbackId == -1)) {
                TSLog.logger.error(TSLog.error("Invalid Headless Callback ids.  Cannot handle headless event"));
                return;
            }

            BackgroundGeolocation.getUiHandler().post(HeadlessTask.this);
        }
    }
}
