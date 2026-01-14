package com.transistorsoft.flutter.backgroundgeolocation.streams;

import android.util.Log;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSLocationCallback;
import com.transistorsoft.locationmanager.event.EventName;
import com.transistorsoft.locationmanager.event.LocationEvent;
import com.transistorsoft.locationmanager.location.TSLocation;
import com.transistorsoft.locationmanager.logger.TSLog;

import org.json.JSONException;

import io.flutter.plugin.common.EventChannel;

public class LocationStreamHandler extends StreamHandler implements TSLocationCallback {

    public LocationStreamHandler() {
        mEvent = EventName.LOCATION;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = BackgroundGeolocation.getInstance(mContext).onLocation(this);
    }

    @Override
    public void onLocation(LocationEvent event) {
        mEventSink.success(event.toMap());
    }

    @Override
    public void onError(Integer error) {
        mEventSink.error(error.toString(), null, null);
    }
}