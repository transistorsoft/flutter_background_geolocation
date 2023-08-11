package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSLocationProviderChangeCallback;
import com.transistorsoft.locationmanager.event.LocationProviderChangeEvent;

import io.flutter.plugin.common.EventChannel;

public class ProviderChangeStreamHandler extends StreamHandler implements TSLocationProviderChangeCallback {

    public ProviderChangeStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_PROVIDERCHANGE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onLocationProviderChange(this);
    }

    @Override
    public void onLocationProviderChange(LocationProviderChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}