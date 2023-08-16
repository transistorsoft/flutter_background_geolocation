package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSGeofenceCallback;
import com.transistorsoft.locationmanager.event.GeofenceEvent;
import io.flutter.plugin.common.EventChannel;

public class GeofenceStreamHandler extends StreamHandler implements TSGeofenceCallback {

    public GeofenceStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_GEOFENCE;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onGeofence(this);
    }

    @Override
    public void onGeofence(GeofenceEvent event) {
        mEventSink.success(event.toMap());
    }
}