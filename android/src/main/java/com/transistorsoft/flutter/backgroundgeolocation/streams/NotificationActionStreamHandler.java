package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSNotificationActionCallback;
import com.transistorsoft.locationmanager.event.EventName;

import io.flutter.plugin.common.EventChannel;

public class NotificationActionStreamHandler extends StreamHandler implements TSNotificationActionCallback {

    public NotificationActionStreamHandler() {
        mEvent = EventName.NOTIFICATIONACTION;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = BackgroundGeolocation.getInstance(mContext).onNotificationAction(this);
    }

    @Override
    public void onClick(String action) {
        mEventSink.success(action);
    }
}