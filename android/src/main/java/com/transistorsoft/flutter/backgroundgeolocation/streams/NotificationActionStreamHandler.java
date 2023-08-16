package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSNotificationActionCallback;

import io.flutter.plugin.common.EventChannel;

public class NotificationActionStreamHandler extends StreamHandler implements TSNotificationActionCallback {

    public NotificationActionStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_NOTIFICATIONACTION;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onNotificationAction(this);
    }

    @Override
    public void onClick(String action) {
        mEventSink.success(action);
    }
}