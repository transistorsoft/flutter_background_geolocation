package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
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
}
