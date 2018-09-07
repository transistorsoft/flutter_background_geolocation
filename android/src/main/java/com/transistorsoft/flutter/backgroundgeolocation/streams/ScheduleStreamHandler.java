package com.transistorsoft.flutter.backgroundgeolocation.streams;


import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSScheduleCallback;
import com.transistorsoft.locationmanager.scheduler.ScheduleEvent;
import com.transistorsoft.locationmanager.util.Util;

import io.flutter.plugin.common.EventChannel;

public class ScheduleStreamHandler extends StreamHandler implements TSScheduleCallback, EventChannel.StreamHandler {

    public ScheduleStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_SCHEDULE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onSchedule(this);
    }

    @Override
    public void onSchedule(ScheduleEvent event) {
        mEventSink.success(Util.toMap(event.getState()));
    }
}