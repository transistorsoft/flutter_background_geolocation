package com.transistorsoft.flutter.backgroundgeolocation;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

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
        // The Activity is being recreated and this engine outlives it: onReattachedToActivityForConfigChanges() follows
        // with the new instance.  Nothing to tear down — the native SDK tells a recreation from a termination itself.
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
        BackgroundGeolocationModule.getInstance().reattachActivity(activityPluginBinding.getActivity());
    }

    @Override
    public void onDetachedFromActivity() {
        // Deliberately not passed on to the native SDK as setActivity(null): a real destroy has already reached it through
        // its own lifecycle callbacks (they run before this), and when the engine detaches from an Activity that lives
        // on (add-to-app), clearing it would lose the SDK's detection of that Activity's eventual termination.
        BackgroundGeolocationModule.getInstance().setActivity(null);
    }
}
