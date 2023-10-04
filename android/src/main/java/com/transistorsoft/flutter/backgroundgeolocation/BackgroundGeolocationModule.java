package com.transistorsoft.flutter.backgroundgeolocation;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.transistorsoft.xms.g.common.ExtensionApiAvailability;

import com.transistorsoft.flutter.backgroundgeolocation.streams.*;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.TSConfig;
import com.transistorsoft.locationmanager.adapter.callback.TSBackgroundTaskCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSEmailLogCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGeofenceExistsCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGetCountCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGetGeofenceCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGetGeofencesCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGetLocationsCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSGetLogCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSInsertLocationCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSLocationCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSPlayServicesConnectErrorCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSRequestPermissionCallback;
import com.transistorsoft.locationmanager.adapter.callback.TSSyncCallback;
import com.transistorsoft.locationmanager.config.TSAuthorization;
import com.transistorsoft.locationmanager.config.TransistorAuthorizationToken;
import com.transistorsoft.locationmanager.data.LocationModel;
import com.transistorsoft.locationmanager.data.SQLQuery;
import com.transistorsoft.locationmanager.device.DeviceInfo;
import com.transistorsoft.locationmanager.device.DeviceSettingsRequest;
import com.transistorsoft.locationmanager.event.TerminateEvent;
import com.transistorsoft.locationmanager.geofence.TSGeofence;
import com.transistorsoft.locationmanager.location.TSCurrentPositionRequest;
import com.transistorsoft.locationmanager.location.TSLocation;
import com.transistorsoft.locationmanager.location.TSWatchPositionRequest;
import com.transistorsoft.locationmanager.logger.TSLog;
import com.transistorsoft.locationmanager.scheduler.TSScheduleManager;
import com.transistorsoft.locationmanager.util.Sensors;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class BackgroundGeolocationModule  implements MethodChannel.MethodCallHandler, Application.ActivityLifecycleCallbacks {
    private static BackgroundGeolocationModule sInstance;

    static BackgroundGeolocationModule getInstance() {
        if (sInstance == null) {
            sInstance = getInstanceSynchronized();
        }
        return sInstance;
    }

    static synchronized BackgroundGeolocationModule getInstanceSynchronized() {
        if (sInstance == null) sInstance = new BackgroundGeolocationModule();
        return sInstance;
    }

    public static final String PLUGIN_ID                  = "com.transistorsoft/flutter_background_geolocation";
    private static final String METHOD_CHANNEL_NAME         = PLUGIN_ID + "/methods";

    private static final String ACTION_RESET             = "reset";
    private static final String ACTION_READY             = "ready";

    private static final String ACTION_REGISTER_HEADLESS_TASK = "registerHeadlessTask";
    private static final String ACTION_GET_STATE         = "getState";
    private static final String ACTION_START_SCHEDULE    = "startSchedule";
    private static final String ACTION_STOP_SCHEDULE     = "stopSchedule";
    private static final String ACTION_LOG               = "log";
    private static final String ACTION_REQUEST_SETTINGS  = "requestSettings";
    private static final String ACTION_SHOW_SETTINGS     = "showSettings";
    private static final String ACTION_REGISTER_PLUGIN   = "registerPlugin";
    private static final String ACTION_REQUEST_TEMPORARY_FULL_ACCURACY = "requestTemporaryFullAccuracy";

    private static final String JOB_SERVICE_CLASS         = "com.transistorsoft.flutter.backgroundgeolocation.HeadlessTask";

    private boolean mIsInitialized  = false;
    private boolean mReady          = false;
    private final AtomicBoolean mIsAttachedToEngine = new AtomicBoolean(false);

    private MethodChannel mMethodChannel;
    private final List<EventChannel.StreamHandler> mStreamHandlers = new ArrayList<>();

    private Context mContext;
    private Activity mActivity;
    private BinaryMessenger mMessenger;

    void onAttachedToEngine(Context context, final BinaryMessenger messenger) {
        mMessenger = messenger;
        mContext = context;
        mIsAttachedToEngine.set(true);
        mMethodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
        mMethodChannel.setMethodCallHandler(this);
    }

    void onDetachedFromEngine() {
        mIsAttachedToEngine.set(false);
    }

    void setActivity(@Nullable final Activity activity) {
        if (activity != null) {
            if (mActivity != null) {
                if (mActivity.hashCode() == activity.hashCode()) return;
                mActivity.getApplication().unregisterActivityLifecycleCallbacks(this);
            }
            activity.getApplication().registerActivityLifecycleCallbacks(this);

            mReady = false;
            mIsInitialized = false;

            synchronized (mStreamHandlers) {
                mStreamHandlers.add(new LocationStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new MotionChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new ActivityChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new GeofencesChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new GeofenceStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new HeartbeatStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new HttpStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new ScheduleStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new ConnectivityChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new EnabledChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new ProviderChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new PowerSaveChangeStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new NotificationActionStreamHandler().register(mContext, mMessenger));
                mStreamHandlers.add(new AuthorizationStreamHandler().register(mContext, mMessenger));
            }

            BackgroundGeolocation.getThreadPool().execute(new Runnable() {
                @Override public void run() {
                    BackgroundGeolocation adapter = BackgroundGeolocation.getInstance(activity);
                    adapter.setActivity(activity);
                    adapter.removeListeners();

                    TSConfig config = TSConfig.getInstance(mContext.getApplicationContext());
                    config.useCLLocationAccuracy(true);

                    config.updateWithBuilder()
                            .setHeadlessJobService(JOB_SERVICE_CLASS)
                            .commit();
                }
            });
        } else if (mActivity != null) {
            Application app = mActivity.getApplication();
            if (app != null) {
                app.unregisterActivityLifecycleCallbacks(this);
            }
            synchronized (mStreamHandlers) {
                for (EventChannel.StreamHandler handler : mStreamHandlers) {
                    handler.onCancel(null);
                }
                mStreamHandlers.clear();
            }
            BackgroundGeolocation.getInstance(mContext).onActivityDestroy();
        }
        mActivity = activity;
    }

    public static void setPluginRegistrant(PluginRegistry.PluginRegistrantCallback callback) {
        HeadlessTask.setPluginRegistrant(callback);
    }

    private void initializeLocationManager(Activity activity) {
        mIsInitialized = true;

        if (activity == null) {
            return;
        }
        // Handle play-services connect errors.
        BackgroundGeolocation.getInstance(mContext).onPlayServicesConnectError((new TSPlayServicesConnectErrorCallback() {
            @Override
            public void onPlayServicesConnectError(int errorCode) {
                handlePlayServicesConnectError(errorCode);
            }
        }));
    }

    // Shows Google Play Services error dialog prompting user to install / update play-services.
    private void handlePlayServicesConnectError(Integer errorCode) {
        if (mActivity == null) {
            return;
        }
        ExtensionApiAvailability.getInstance().getErrorDialog(mActivity, errorCode, 1001).show();
    }

    @SuppressWarnings("unchecked")
    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equalsIgnoreCase(ACTION_READY)) {
            Map<String, Object> params = (Map<String, Object>) call.arguments;
            ready(params, result);
        } else if (call.method.equals(ACTION_GET_STATE)) {
            getState(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_START)) {
            start(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_STOP)) {
            stop(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_START_GEOFENCES)) {
            startGeofences(result);
        } else if (call.method.equalsIgnoreCase(ACTION_START_SCHEDULE)) {
            startSchedule(result);
        } else if (call.method.equalsIgnoreCase(ACTION_STOP_SCHEDULE)) {
            stopSchedule(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_START_BACKGROUND_TASK)) {
            startBackgroundTask(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_FINISH)) {
            stopBackgroundTask((int) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(ACTION_RESET)) {
            reset(call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_SET_CONFIG)) {
            setConfig((Map) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_CHANGE_PACE)) {
            changePace(call, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_CURRENT_POSITION)) {
            getCurrentPosition((Map) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_WATCH_POSITION)) {
            watchPosition((Map) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_STOP_WATCH_POSITION)) {
            stopWatchPosition(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_LOCATIONS)) {
            getLocations(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_INSERT_LOCATION)) {
            insertLocation((Map) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_COUNT)) {
            getCount(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_DESTROY_LOCATIONS)) {
            destroyLocations(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_DESTROY_LOCATION)) {
            destroyLocation((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_SYNC)) {
            sync(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_ODOMETER)) {
            getOdometer(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_SET_ODOMETER)) {
            setOdometer((Double) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_ADD_GEOFENCE)) {
            addGeofence((Map) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_ADD_GEOFENCES)) {
            addGeofences((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_REMOVE_GEOFENCE)) {
            removeGeofence((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_REMOVE_GEOFENCES)) {
            removeGeofences(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_GEOFENCES)) {
            getGeofences(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_GEOFENCE)) {
            getGeofence((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GEOFENCE_EXISTS)) {
            geofenceExists((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(TSLog.ACTION_LOG)) {
            log((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(TSLog.ACTION_GET_LOG)) {
            getLog((Map) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(TSLog.ACTION_EMAIL_LOG)) {
            emailLog((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(TSLog.ACTION_UPLOAD_LOG)) {
            uploadLog((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_DESTROY_LOG)) {
            destroyLog(result);
        } else if (call.method.equalsIgnoreCase(ACTION_LOG)) {
            Map<String, String> args = (Map) call.arguments;
            log(args.get("level"), args.get("message"), result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_SENSORS)) {
            getSensors(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_IS_POWER_SAVE_MODE)) {
            isPowerSaveMode(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_IS_IGNORING_BATTERY_OPTIMIZATIONS)) {
            isIgnoringBatteryOptimizations(result);
        } else if (call.method.equalsIgnoreCase(ACTION_REQUEST_SETTINGS)) {
            requestSettings((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(ACTION_SHOW_SETTINGS)) {
            showSettings((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(DeviceInfo.ACTION_GET_DEVICE_INFO)) {
            getDeviceInfo(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_PLAY_SOUND)) {
            playSound((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(ACTION_REGISTER_HEADLESS_TASK)) {
            registerHeadlessTask((List<Object>) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_GET_PROVIDER_STATE)) {
            getProviderState(result);
        } else if (call.method.equalsIgnoreCase(BackgroundGeolocation.ACTION_REQUEST_PERMISSION)) {
            requestPermission((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(ACTION_REQUEST_TEMPORARY_FULL_ACCURACY)) {
            requestTemporaryFullAccuracy((String) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(ACTION_REGISTER_PLUGIN)) {
            // No implementation; iOS only.
            result.success(true);
        } else if (call.method.equalsIgnoreCase(TransistorAuthorizationToken.ACTION_GET)) {
            getTransistorToken((List) call.arguments, result);
        } else if (call.method.equalsIgnoreCase(TransistorAuthorizationToken.ACTION_DESTROY)) {
            destroyTransistorToken((String) call.arguments, result);
        } else {
            result.notImplemented();
        }
    }

    // experimental Flutter Headless (NOT READY)
    private void registerHeadlessTask(List<Object> callbacks, MethodChannel.Result result) {
        if (HeadlessTask.register(mContext, callbacks)) {
            result.success(true);
        } else {
            result.error("Failed to registerHeadlessTask.  Callback IDs: " + callbacks.toString(), null, null);
        }
    }

    private void getState(MethodChannel.Result result) {
        resultWithState(result);
    }

    @SuppressWarnings("unchecked")
    private void ready(Map<String, Object> params, final MethodChannel.Result result) {

        boolean reset = (!params.containsKey("reset")) || (boolean) params.get("reset");
        TSConfig config = TSConfig.getInstance(mContext);

        if (mReady) {
            if (reset) {
                TSLog.logger.warn(TSLog.warn("#ready already called.  Redirecting to #setConfig"));
                setConfig(params, result);
            } else {
                TSLog.logger.warn(TSLog.warn("#ready already called.  Config ignored since reset:false"));
                resultWithState(result);
            }
            return;
        }

        mReady = true;

        if (config.isFirstBoot()) {
            if (!applyConfig(params, result)) {
                return;
            }
        } else {
            if (reset) {
                config.reset();
                if (!applyConfig(params, result)) {
                    return;
                }
            } else if (params.containsKey(TSAuthorization.NAME)) {
                Map options = (Map) params.get(TSAuthorization.NAME);
                if (options != null) {
                    config.updateWithBuilder()
                            .setAuthorization(new TSAuthorization((Map<String,Object>)options))
                            .commit();
                }
            }
        }
        BackgroundGeolocation.getInstance(mContext).ready(new TSCallback() {
            @Override public void onSuccess() { resultWithState(result); }
            @Override public void onFailure(String error) {
                result.error(error, null, null);
            }
        });
    }

    private void start(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).start(new TSCallback() {
            @Override public void onSuccess() { resultWithState(result); }
            @Override public void onFailure(String error) {
                result.error(error, null, null);
            }
        });
    }

    private void setConfig(Map<String, Object> config, MethodChannel.Result result) {
        if (!applyConfig(config, result)) return;
        resultWithState(result);
    }

    @SuppressWarnings("unchecked")
    private void reset(Object args, MethodChannel.Result result) {
        TSConfig config = TSConfig.getInstance(mContext);
        config.reset();

        if (args != null) {
            if (args.getClass() == HashMap.class) {
                Map<String, Object> params = (HashMap) args;

                if (!applyConfig(params, result)) return;
            }
        }
        resultWithState(result);
    }

    private void startGeofences(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).startGeofences(new TSCallback() {
            @Override public void onSuccess() { resultWithState(result); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void startSchedule(MethodChannel.Result result) {
        if (BackgroundGeolocation.getInstance(mContext).startSchedule()) {
            resultWithState(result);
        } else {
            result.error("Failed to start schedule.  Did you configure a #schedule?", null, null);
        }
    }

    private void stopSchedule(MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).stopSchedule();
        resultWithState(result);
    }

    private void stop(final MethodChannel.Result result) {
        final BackgroundGeolocation bgGeo = BackgroundGeolocation.getInstance(mContext);
        bgGeo.stop(new TSCallback() {
            @Override public void onSuccess() {
                resultWithState(result);
            }
            @Override public void onFailure(String error) {
                result.error(error, null, null);
            }
        });
    }

    private void changePace(MethodCall call, final MethodChannel.Result result) {
        final boolean isMoving = (boolean) call.arguments;
        BackgroundGeolocation.getInstance(mContext).changePace(isMoving, new TSCallback() {
            @Override public void onSuccess() {
                result.success(isMoving);
            }
            @Override public void onFailure(String error) {
                result.error(error.toString(), null, null);
            }
        });
    }

    @SuppressWarnings("unchecked")
    private void getCurrentPosition(Map<String, Object> options, final MethodChannel.Result result) {
        TSCurrentPositionRequest.Builder builder = new TSCurrentPositionRequest.Builder(mContext);

        builder.setCallback(new TSLocationCallback() {
            @Override public void onLocation(TSLocation tsLocation) {
                try {
                    result.success(tsLocation.toMap());
                } catch (JSONException e) {
                    TSLog.logger.error(e.getMessage(), e);
                }
            }
            @Override public void onError(Integer errorCode) {
                result.error(errorCode.toString(), null, null);
            }
        });

        if (options.containsKey("samples"))         { builder.setSamples((int) options.get("samples")); }
        if (options.containsKey("persist"))         { builder.setPersist((boolean) options.get("persist")); }
        if (options.containsKey("timeout"))         { builder.setTimeout((int) options.get("timeout")); }
        if (options.containsKey("maximumAge"))      { builder.setMaximumAge(((Integer) options.get("maximumAge")).longValue()); }
        if (options.containsKey("desiredAccuracy")) { builder.setDesiredAccuracy((int) options.get("desiredAccuracy")); }
        if (options.containsKey("extras")) {
            Object extras = options.get("extras");
            if ((extras != null) && (extras.getClass() == HashMap.class)) {
                try {
                    builder.setExtras(mapToJson((HashMap) extras));
                } catch (JSONException e) {
                    result.error(e.getMessage(), null, null);
                    e.printStackTrace();
                    return;
                }
            }
        }

        BackgroundGeolocation.getInstance(mContext).getCurrentPosition(builder.build());
    }

    @SuppressWarnings("unchecked")
    private void watchPosition(Map<String, Object> options, final MethodChannel.Result result) {
        TSWatchPositionRequest.Builder builder = new TSWatchPositionRequest.Builder(mContext);

        builder.setCallback(new TSLocationCallback() {
            @Override public void onLocation(TSLocation tsLocation) {
                try {
                    result.success(tsLocation.toMap());
                } catch (JSONException e) {
                    TSLog.logger.error(e.getMessage(), e);
                }
            }
            @Override public void onError(Integer error) {
                result.error(error.toString(), null, null);
            }
        });

        if (options.containsKey("interval")) {
            builder.setInterval((long) options.get("interval"));
        }
        if (options.containsKey("persist")) {
            builder.setPersist((boolean) options.get("persist"));
        }
        if (options.containsKey("desiredAccuracy")) {
            builder.setDesiredAccuracy((int) options.get("desiredAccuracy"));
        }
        if (options.containsKey("extras")) {
            try {
                builder.setExtras(mapToJson((Map) options.get("extras")));
            } catch (JSONException e) {
                result.error(e.getMessage(), null, null);
            }
        }
        BackgroundGeolocation.getInstance(mContext).watchPosition(builder.build());
    }

    private void stopWatchPosition(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).stopWatchPosition(new TSCallback() {
            @Override
            public void onSuccess() {
                result.success(true);
            }

            @Override
            public void onFailure(String error) {
                result.error(error, null, null);
            }
        });
    }

    private void getLocations(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).getLocations(new TSGetLocationsCallback() {
            @Override public void onSuccess(List<LocationModel> records) {
                JSONArray rs = new JSONArray();
                for (LocationModel location : records) {
                    rs.put(location.json);
                }
                try {
                    result.success(toList(rs));
                } catch (JSONException e) {
                    result.error(e.getMessage(), null, null);
                }
            }
            @Override public void onFailure(Integer error) { result.error(error.toString(), null, null); }
        });
    }

    private void insertLocation(Map<String, Object> params, final MethodChannel.Result result) {
        JSONObject json;
        try {
            json = mapToJson(params);
        } catch (JSONException e) {
            result.error(e.getMessage(), null, null);
            e.printStackTrace();
            return;
        }
        BackgroundGeolocation.getInstance(mContext).insertLocation(json, new TSInsertLocationCallback() {
            @Override public void onSuccess(String uuid) { result.success(uuid); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void getCount(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).getCount(new TSGetCountCallback() {
            @Override public void onSuccess(Integer count) { result.success(count); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void destroyLocations(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).destroyLocations(new TSCallback() {
            @Override public void onSuccess() { result.success(true); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void destroyLocation(final String uuid, final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).destroyLocation(uuid, new TSCallback() {
            @Override public void onSuccess() {
                result.success(true);
            }
            @Override public void onFailure(String error) {
                result.error(error, error, null);
            }
        });
    }

    private void sync(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).sync(new TSSyncCallback() {
            @Override public void onSuccess(List<LocationModel> records) {
                try {
                    JSONArray rs = new JSONArray();
                    for (LocationModel location : records) {
                        rs.put(location.json);
                    }
                    result.success(toList(rs));
                } catch (JSONException e) {
                    result.error(e.getMessage(), null, null);
                }
            }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void getOdometer(MethodChannel.Result result) {
        result.success(BackgroundGeolocation.getInstance(mContext).getOdometer().doubleValue());
    }

    private void setOdometer(Double odometer, final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).setOdometer(odometer.floatValue(), new TSLocationCallback() {
            @Override public void onLocation(TSLocation location) {
                try {
                    result.success(location.toMap());
                } catch (JSONException e) {
                    TSLog.logger.error(e.getMessage(), e);
                }
            }
            @Override public void onError(Integer errorCode) {
                result.error(errorCode.toString(), null, null);
            }
        });
    }

    private void addGeofence(Map<String, Object> params, final MethodChannel.Result result) {
        try {
            BackgroundGeolocation.getInstance(mContext).addGeofence(buildGeofence(params), new TSCallback() {
                @Override public void onSuccess() { result.success(true); }
                @Override public void onFailure(String error) { result.error(error, null, null); }
            });
        } catch (TSGeofence.Exception e) {
            result.error(e.getMessage(), null, null);
        }
    }

    private void addGeofences(List<Map<String, Object>> data, final MethodChannel.Result result) {
        List<TSGeofence> geofences = new ArrayList<>();
        for (int n=0;n<data.size();n++) {
            try {
                geofences.add(buildGeofence(data.get(n)));
            } catch (TSGeofence.Exception e) {
                result.error(e.getMessage(), null, null);
                return;
            }
        }

        BackgroundGeolocation.getInstance(mContext).addGeofences(geofences, new TSCallback() {
            @Override public void onSuccess() {
                result.success(true);
            }
            @Override public void onFailure(String error) {
                result.error(error, null, null);
            }
        });
    }

    private void removeGeofence(String identifier, final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).removeGeofence(identifier, new TSCallback() {
            @Override public void onSuccess() { result.success(true);
            }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void removeGeofences(final MethodChannel.Result result) {
        List<String> identifiers = new ArrayList<>();
        BackgroundGeolocation.getInstance(mContext).removeGeofences(identifiers, new TSCallback() {
            @Override public void onSuccess() { result.success(true); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void getGeofences(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).getGeofences(new TSGetGeofencesCallback() {
            @Override public void onSuccess(List<TSGeofence> geofences) {
                try {
                    List<Map<String, Object>> rs = new ArrayList<>();
                    for (TSGeofence geofence : geofences) {
                        rs.add(geofenceToMap(geofence));
                    }
                    result.success(rs);
                } catch (JSONException e) {
                    e.printStackTrace();
                    result.error(e.getMessage(), null, null);
                }
            }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void getGeofence(String identifier, final MethodChannel.Result result) {
        if (identifier == null) {
            result.error("Invalid geofence identifier: " + identifier, null, null);
            return;
        }
        BackgroundGeolocation.getInstance(mContext).getGeofence(identifier, new TSGetGeofenceCallback() {
            @Override public void onSuccess(TSGeofence geofence) {
                try {
                    result.success(geofenceToMap(geofence));
                } catch (JSONException e) {
                    e.printStackTrace();
                    result.error(e.getMessage(), null, null);
                }
            }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void geofenceExists(String identifier, final MethodChannel.Result result) {
        if (identifier == null) {
            result.error("Invalid geofence identifier: " + identifier, null, null);
            return;
        }
        BackgroundGeolocation.getInstance(mContext).geofenceExists(identifier, new TSGeofenceExistsCallback() {
            @Override public void onResult(boolean exists) {
                result.success(exists);
            }
        });
    }

    private static Map<String, Object> geofenceToMap(TSGeofence geofence) throws JSONException {
        Map<String, Object> data = new HashMap<>();
        data.put("identifier", geofence.getIdentifier());
        data.put("latitude", geofence.getLatitude());
        data.put("longitude", geofence.getLongitude());
        data.put("radius", geofence.getRadius());
        data.put("notifyOnEntry", geofence.getNotifyOnEntry());
        data.put("notifyOnExit", geofence.getNotifyOnExit());
        data.put("notifyOnDwell", geofence.getNotifyOnDwell());
        data.put("loiteringDelay", geofence.getLoiteringDelay());
        if (geofence.getExtras() != null) {
            data.put("extras", jsonToMap(geofence.getExtras()));
        }
        data.put("vertices", geofence.getVertices());
        return data;
    }

    @SuppressWarnings("unchecked")
    private static TSGeofence buildGeofence(Map<String, Object> config) throws TSGeofence.Exception {
        TSGeofence.Builder builder = new TSGeofence.Builder();

        if (config.containsKey("identifier"))       { builder.setIdentifier((String) config.get("identifier")); }
        if (config.get("latitude") != null)         { builder.setLatitude((Double) config.get("latitude")); }
        if (config.get("longitude") != null)        { builder.setLongitude((Double) config.get("longitude")); }
        if (config.get("radius") != null) {
            Double radius = (Double) config.get("radius");
            builder.setRadius(radius.floatValue());
        }
        if (config.get("vertices") != null) {
            builder.setVertices((List<List<Double>>) config.get("vertices"));
        }
        if (config.containsKey("notifyOnEntry"))    { builder.setNotifyOnEntry((boolean) config.get("notifyOnEntry")); }
        if (config.containsKey("notifyOnExit"))     { builder.setNotifyOnExit((boolean) config.get("notifyOnExit")); }
        if (config.containsKey("notifyOnDwell"))    { builder.setNotifyOnDwell((boolean) config.get("notifyOnDwell")); }
        if (config.containsKey("loiteringDelay"))   { builder.setLoiteringDelay((int) config.get("loiteringDelay")); }
        try {
            if (config.containsKey("extras")) {
                builder.setExtras(mapToJson((HashMap) config.get("extras")));
            }
        } catch (JSONException e) {
            throw new TSGeofence.Exception(e.getMessage());
        }
        return builder.build();
    }

    private void startBackgroundTask(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).startBackgroundTask(new TSBackgroundTaskCallback() {
            @Override public void onStart(int taskId) { result.success(taskId); }
            @Override public void onCancel(int taskId) { } // NO IMPLEMENTATION
        });
    }

    private void stopBackgroundTask(int taskId, MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).stopBackgroundTask(taskId);
        result.success(taskId);
    }

    private void log(List<String> args, MethodChannel.Result result) {
        String level = args.get(0);
        String message = args.get(1);
        TSLog.log(level, message);
        result.success(true);
    }

    private void getLog(Map params, final MethodChannel.Result result) {
        SQLQuery query = SQLQuery.fromMap(params);
        TSLog.getLog(query, new TSGetLogCallback() {
            @Override public void onSuccess(String log) { result.success(log); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void emailLog(List<Object> args, final MethodChannel.Result result) {
        if (mActivity == null) {
            result.error("Activity is null", null, null);
            return;
        }

        String email = (String) args.get(0);
        Map params = (Map) args.get(1);

        SQLQuery query = SQLQuery.fromMap(params);

        TSLog.emailLog(mActivity, email, query, new TSEmailLogCallback() {
            @Override public void onSuccess() { result.success(true); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void uploadLog(List<Object> args, final MethodChannel.Result result) {
        String url = (String) args.get(0);
        Map params = (Map) args.get(1);

        SQLQuery query = SQLQuery.fromMap(params);

        TSLog.uploadLog(mContext, url, query, new TSCallback() {
            @Override public void onSuccess() { result.success(true); }
            @Override public void onFailure(String s) { result.error(s, null, null); }
        });
    }

    private void destroyLog(final MethodChannel.Result result) {
        TSLog.destroyLog(new TSCallback() {
            @Override public void onSuccess() { result.success(true); }
            @Override public void onFailure(String error) { result.error(error, null, null); }
        });
    }

    private void log(String level, String message, MethodChannel.Result result) {
        TSLog.log(level, message);
        result.success(true);
    }

    private void getSensors(MethodChannel.Result result) {
        Sensors sensors = Sensors.getInstance(mContext);
        Map<String, Object> params = new HashMap<>();
        params.put("platform", "android");
        params.put("accelerometer", sensors.hasAccelerometer());
        params.put("magnetometer", sensors.hasMagnetometer());
        params.put("gyroscope", sensors.hasGyroscope());
        params.put("significant_motion", sensors.hasSignificantMotion());
        result.success(params);
    }

    private void isPowerSaveMode(MethodChannel.Result result) {
        result.success(BackgroundGeolocation.getInstance(mContext).isPowerSaveMode());
    }

    private void isIgnoringBatteryOptimizations(MethodChannel.Result result) {
        result.success(BackgroundGeolocation.getInstance(mContext).isIgnoringBatteryOptimizations());
    }

    private void requestSettings(List<Object> args, MethodChannel.Result result) {
        String action = (String) args.get(0);

        DeviceSettingsRequest request = BackgroundGeolocation.getInstance(mContext).requestSettings(action);
        if (request != null) {
            result.success(request.toMap());
        } else {
            result.error("0", "Failed to find " + action + " screen for device " + Build.MANUFACTURER + " " + Build.MODEL + "@" + Build.VERSION.RELEASE, null);
        }
    }

    private void showSettings(List<Object> args, MethodChannel.Result result) {
        String action = (String) args.get(0);
        boolean didShow = BackgroundGeolocation.getInstance(mContext).showSettings(action);
        if (didShow) {
            result.success(didShow);
        } else {
            result.error("0", "Failed to find " + action + " screen for device " + Build.MANUFACTURER + " " + Build.MODEL + "@" + Build.VERSION.RELEASE, null);
        }
    }

    private void getDeviceInfo(MethodChannel.Result result) {
        result.success(DeviceInfo.getInstance(mContext).toMap());
    }

    private void getProviderState(MethodChannel.Result result) {
        result.success(BackgroundGeolocation.getInstance(mContext).getProviderState().toMap());
    }

    private void requestPermission(final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).requestPermission(new TSRequestPermissionCallback() {
            @Override public void onSuccess(int status) { result.success(status); }
            @Override public void onFailure(int status) { result.error("DENIED", null, status); }
        });
    }

    private void requestPermission(final String permission, final MethodChannel.Result result) {
        if (permission == null) {
            requestPermission(result);
            return;
        }
        // NOT YET IMPLEMENTED.  For future implementation of requesting individual permissions.
        BackgroundGeolocation.getInstance(mContext).requestPermission(permission, new TSRequestPermissionCallback() {
            @Override public void onSuccess(int status) { result.success(status); }
            @Override public void onFailure(int status) { result.error("DENIED", null, status); }
        });
    }

    private void requestTemporaryFullAccuracy(String purpose, final MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).requestTemporaryFullAccuracy(purpose, new TSRequestPermissionCallback() {
            @Override public void onSuccess(int accuracyAuthorization) {
                result.success(accuracyAuthorization);
            }
            @Override public void onFailure(int accuracyAuthorization) {
                result.success(accuracyAuthorization);
            }
        });
    }

    private void getTransistorToken(List<String>args, final MethodChannel.Result result) {
        String orgname = args.get(0);
        String username = args.get(1);
        String url = args.get(2);

        TransistorAuthorizationToken.findOrCreate(mContext, orgname, username, url, new TransistorAuthorizationToken.Callback() {
            @Override public void onSuccess(TransistorAuthorizationToken token) {
                result.success(token.toMap());
            }
            @Override public void onFailure(String error) {
                result.error(error, error, null);
            }
        });
    }

    private void destroyTransistorToken(String url, final MethodChannel.Result result) {
        TransistorAuthorizationToken.destroyTokenForUrl(mContext, url, new TSCallback() {
            @Override
            public void onSuccess() {
                result.success(true);
            }

            @Override
            public void onFailure(String error) {
                result.error(error, error, null);
            }
        });
    }

    private void playSound(String name, MethodChannel.Result result) {
        BackgroundGeolocation.getInstance(mContext).startTone(name);
        result.success(true);
    }

    ////
    // Utility Methods
    //
    @SuppressWarnings("unchecked")
    private static JSONObject mapToJson(Map<String, Object> map) throws JSONException {
        JSONObject jsonData = new JSONObject();
        for (String key : map.keySet()) {
            Object value = map.get(key);
            if (value instanceof Map<?, ?>) {
                value = mapToJson((Map<String, Object>) value);
            } else if (value instanceof List<?>) {
                value = listToJson((List<Object>) value);
            }
            jsonData.put(key, value);
        }
        return jsonData;
    }

    @SuppressWarnings("unchecked")
    private static JSONArray listToJson(List<Object> list) throws JSONException {
        JSONArray jsonData = new JSONArray();
        for (Object value : list) {
            if (value instanceof Map<?, ?>) {
                value = mapToJson((Map<String, Object>) value);
            } else if (value instanceof List<?>) {
                value = listToJson((List<Object>) value);
            }
            jsonData.put(value);
        }
        return jsonData;
    }

    private static Map<String, Object> jsonToMap(JSONObject json) throws JSONException {
        Map<String, Object> retMap = new HashMap<>();

        if(json != JSONObject.NULL) {
            retMap = toMap(json);
        }
        return retMap;
    }

    private static Map<String, Object> toMap(JSONObject object) throws JSONException {
        Map<String, Object> map = new HashMap<>();

        Iterator<String> keysItr = object.keys();
        while(keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);

            if(value instanceof JSONArray) {
                value = toList((JSONArray) value);
            }

            else if(value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }

    private static List<Object> toList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<>();
        for(int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if(value instanceof JSONArray) {
                value = toList((JSONArray) value);
            }

            else if(value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            list.add(value);
        }
        return list;
    }

    private Map<String, Object> setHeadlessJobService(Map<String, Object> config) {
        config.put("headlessJobService", JOB_SERVICE_CLASS);
        return config;
    }

    private boolean applyConfig(Map<String, Object> params, MethodChannel.Result result) {
        TSConfig config = TSConfig.getInstance(mContext);

        try {
            config.updateWithJSONObject(mapToJson(setHeadlessJobService(params)));
        } catch (JSONException e) {
            result.error(e.getMessage(), null, null);
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private void resultWithState(MethodChannel.Result result) {
        try {
            result.success(jsonToMap(TSConfig.getInstance(mContext).toJson()));
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(e.getMessage(), null, null);
        }
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) { }

    @Override
    public void onActivityPaused(Activity activity) {
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (!activity.equals(mActivity)) {
            return;
        }
        TSScheduleManager.getInstance(activity).cancelOneShot(TerminateEvent.ACTION);
    }
    @Override
    public void onActivityStarted(Activity activity) {
        if (!mIsInitialized) {
            initializeLocationManager(activity);
        }
    }
    @Override
    public void onActivityStopped(Activity activity) {
        if (!activity.equals(mActivity)) {
            return;
        }
        TSConfig config = TSConfig.getInstance(activity);
        if (config.getEnabled()) {
            TSScheduleManager.getInstance(activity).oneShot(TerminateEvent.ACTION, 10000, true, false);
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) { }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }
}
