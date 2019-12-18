package com.transistorsoft.flutter.backgroundgeolocation;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterBackgroundGeolocationPlugin
 */
public class FLTBackgroundGeolocationPlugin implements FlutterPlugin, ActivityAware {

    /** Plugin registration. */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        BackgroundGeolocationModule module = BackgroundGeolocationModule.getInstance();
        module.onAttachedToEngine(registrar.context(), registrar.messenger());
        if (registrar.activity() != null) {
            module.setActivity(registrar.activity());
        }
    }

    // @deprecated Called by Application#onCreate
    public static void setPluginRegistrant(PluginRegistry.PluginRegistrantCallback callback) {
        HeadlessTask.setPluginRegistrant(callback);
    }

    public FLTBackgroundGeolocationPlugin() { }

    @Override
    public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding binding) {
        BackgroundGeolocationModule.getInstance().onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        BackgroundGeolocationModule.getInstance().onDetachedFromEngine();
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        BackgroundGeolocationModule.getInstance().setActivity(activityPluginBinding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // TODO: the Activity your plugin was attached to was
        // destroyed to change configuration.
        // This call will be followed by onReattachedToActivityForConfigChanges().
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
        // TODO: your plugin is now attached to a new Activity
        // after a configuration change.
    }

    @Override
    public void onDetachedFromActivity() {
        BackgroundGeolocationModule.getInstance().setActivity(null);
    }
}
