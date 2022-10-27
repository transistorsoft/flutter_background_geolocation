package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSLocationCallback;
import com.transistorsoft.locationmanager.location.TSLocation;

import io.flutter.plugin.common.EventChannel;

public class LocationStreamHandler extends StreamHandler implements TSLocationCallback, EventChannel.StreamHandler {

    public LocationStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_LOCATION;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onLocation(this);
    }

    @Override
    public void onLocation(TSLocation tsLocation) {
        mEventSink.success(tsLocation.toMap());
    }

    @Override
    public void onError(Integer error) {
        mEventSink.error(error.toString(), null, null);
    }
}