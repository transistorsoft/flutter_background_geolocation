package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSConnectivityChangeCallback;
import com.transistorsoft.locationmanager.event.ConnectivityChangeEvent;

import io.flutter.plugin.common.EventChannel;

public class ConnectivityChangeStreamHandler extends StreamHandler implements TSConnectivityChangeCallback {

    public ConnectivityChangeStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_CONNECTIVITYCHANGE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onConnectivityChange(this);
    }
    @Override
    public void onConnectivityChange(ConnectivityChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}
