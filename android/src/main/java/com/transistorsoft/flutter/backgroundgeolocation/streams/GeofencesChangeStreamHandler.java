package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSGeofencesChangeCallback;
import com.transistorsoft.locationmanager.event.GeofencesChangeEvent;
import com.transistorsoft.locationmanager.geofence.TSGeofenceManager;

import io.flutter.plugin.common.EventChannel;

public class GeofencesChangeStreamHandler extends StreamHandler implements TSGeofencesChangeCallback {

    public GeofencesChangeStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_GEOFENCES_CHANGE;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        TSGeofenceManager.getInstance(mContext).onGeofencesChange(this);
    }

    @Override
    public void onCancel(Object args) {
        TSGeofenceManager.getInstance(mContext).removeListener(mEvent, this);
    }

    @Override
    public void onGeofencesChange(GeofencesChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}