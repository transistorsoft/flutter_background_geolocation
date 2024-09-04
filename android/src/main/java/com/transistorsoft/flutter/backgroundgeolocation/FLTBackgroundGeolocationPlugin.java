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
    public FLTBackgroundGeolocationPlugin() { }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        BackgroundGeolocationModule.getInstance().onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        BackgroundGeolocationModule.getInstance().onDetachedFromEngine(binding.getBinaryMessenger());
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
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
