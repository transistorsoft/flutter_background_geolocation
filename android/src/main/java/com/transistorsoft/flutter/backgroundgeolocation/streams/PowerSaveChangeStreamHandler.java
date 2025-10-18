package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSPowerSaveChangeCallback;
import com.transistorsoft.locationmanager.event.EventName;

import io.flutter.plugin.common.EventChannel;

public class PowerSaveChangeStreamHandler extends StreamHandler implements TSPowerSaveChangeCallback {

    public PowerSaveChangeStreamHandler() {
        mEvent = EventName.POWERSAVECHANGE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = BackgroundGeolocation.getInstance(mContext).onPowerSaveChange(this);
    }
    @Override
    public void onPowerSaveChange(Boolean isPowerSaveMode) {
        mEventSink.success(isPowerSaveMode);
    }
}