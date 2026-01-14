package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.callback.TSGeofencesChangeCallback;
import com.transistorsoft.locationmanager.event.EventName;
import com.transistorsoft.locationmanager.event.GeofencesChangeEvent;
import com.transistorsoft.locationmanager.geofence.TSGeofenceManager;

import io.flutter.plugin.common.EventChannel;

public class GeofencesChangeStreamHandler extends StreamHandler implements TSGeofencesChangeCallback {

    public GeofencesChangeStreamHandler() {
        mEvent = EventName.GEOFENCESCHANGE;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        mSubscription = TSGeofenceManager.getInstance(mContext).onGeofencesChange(this);
    }

    @Override
    public void onGeofencesChange(GeofencesChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}