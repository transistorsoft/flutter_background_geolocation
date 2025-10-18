package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSActivityChangeCallback;
import com.transistorsoft.locationmanager.event.ActivityChangeEvent;
import com.transistorsoft.locationmanager.event.EventName;

import io.flutter.plugin.common.EventChannel;

public class ActivityChangeStreamHandler extends StreamHandler implements TSActivityChangeCallback {

    public ActivityChangeStreamHandler() {
        mEvent = EventName.ACTIVITYCHANGE;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = BackgroundGeolocation.getInstance(mContext).onActivityChange(this);
    }

    @Override
    public void onActivityChange(ActivityChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}