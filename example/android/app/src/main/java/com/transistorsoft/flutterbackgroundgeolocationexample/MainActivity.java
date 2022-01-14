package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  public void onCreate(@Nullable Bundle bundle) {
    super.onCreate(bundle);
    new Notifications().createNotificationChannels(this);
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    final BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
    final MethodChannel channel = new MethodChannel(messenger, "com.transistorsoft.flutterbackgroundgeolocationexample/background_service");
    channel.setMethodCallHandler(new BackgroundMethodCallHandler().setContext(this));
  }

  /**
   * This is required to solve Flutter bug booting my old Nexus 4 @4.4.4
   * https://github.com/flutter/flutter/issues/46172#issuecomment-569525397
   */
  @Override
  public void onFlutterUiDisplayed() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      reportFullyDrawn();
    }
  }

  private static class BackgroundMethodCallHandler implements MethodChannel.MethodCallHandler {
    private Context mContext;

    public BackgroundMethodCallHandler setContext(Context context) {
      mContext = context;
      return this;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
      if (call.method.equals("startService")) {
        Log.d("BackgroundMethodCallHandler", "Starting service");
        final long callbackRawHandle = ((long) call.arguments);
        BackgroundService.startService(mContext, callbackRawHandle);
        result.success(null);
      } else {
        result.notImplemented();
      }
    }
  }
}


