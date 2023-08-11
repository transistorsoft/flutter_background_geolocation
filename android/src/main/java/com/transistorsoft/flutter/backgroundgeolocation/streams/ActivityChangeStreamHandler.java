package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSActivityChangeCallback;
import com.transistorsoft.locationmanager.event.ActivityChangeEvent;

import io.flutter.plugin.common.EventChannel;

public class ActivityChangeStreamHandler extends StreamHandler implements TSActivityChangeCallback {

    public ActivityChangeStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_ACTIVITYCHANGE;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onActivityChange(this);
    }

    @Override
    public void onActivityChange(ActivityChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}