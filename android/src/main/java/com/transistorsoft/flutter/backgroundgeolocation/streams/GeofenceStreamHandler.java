package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSGeofenceCallback;
import com.transistorsoft.locationmanager.event.EventName;
import com.transistorsoft.locationmanager.event.GeofenceEvent;
import io.flutter.plugin.common.EventChannel;

public class GeofenceStreamHandler extends StreamHandler implements TSGeofenceCallback {

    public GeofenceStreamHandler() {
        mEvent = EventName.GEOFENCE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = BackgroundGeolocation.getInstance(mContext).onGeofence(this);
    }

    @Override
    public void onGeofence(GeofenceEvent event) {
        mEventSink.success(event.toMap());
    }
}