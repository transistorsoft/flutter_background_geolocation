package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSScheduleCallback;
import com.transistorsoft.locationmanager.logger.TSLog;
import com.transistorsoft.locationmanager.scheduler.ScheduleEvent;
import com.transistorsoft.locationmanager.util.Util;

import org.json.JSONException;

import io.flutter.plugin.common.EventChannel;

public class ScheduleStreamHandler extends StreamHandler implements TSScheduleCallback {

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
        try {
            mEventSink.success(Util.toMap(event.getState()));
        } catch (JSONException e) {
            TSLog.logger.error(e.getMessage(), e);
        }
    }
}