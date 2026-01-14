package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSHeartbeatCallback;
import com.transistorsoft.locationmanager.event.EventName;
import com.transistorsoft.locationmanager.event.HeartbeatEvent;

import io.flutter.plugin.common.EventChannel;

public class HeartbeatStreamHandler extends StreamHandler implements TSHeartbeatCallback {

    public HeartbeatStreamHandler() {
        mEvent = EventName.HEARTBEAT;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = BackgroundGeolocation.getInstance(mContext).onHeartbeat(this);
    }

    @Override
    public void onHeartbeat(HeartbeatEvent event) {
        mEventSink.success(event.toMap());
    }
}