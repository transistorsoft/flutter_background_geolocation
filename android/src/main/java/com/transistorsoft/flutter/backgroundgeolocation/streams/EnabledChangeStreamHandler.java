package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSEnabledChangeCallback;

import io.flutter.plugin.common.EventChannel;

public class EnabledChangeStreamHandler extends StreamHandler implements TSEnabledChangeCallback {

    public EnabledChangeStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_ENABLEDCHANGE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onEnabledChange(this);
    }

    @Override
    public void onEnabledChange(boolean enabled) {
        mEventSink.success(enabled);
    }
}