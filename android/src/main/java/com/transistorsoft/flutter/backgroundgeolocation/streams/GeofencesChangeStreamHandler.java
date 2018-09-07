package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSGeofencesChangeCallback;
import com.transistorsoft.locationmanager.event.GeofencesChangeEvent;

import io.flutter.plugin.common.EventChannel;

public class GeofencesChangeStreamHandler extends StreamHandler implements TSGeofencesChangeCallback, EventChannel.StreamHandler {

    public GeofencesChangeStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_GEOFENCES_CHANGE;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onGeofencesChange(this);
    }

    @Override
    public void onGeofencesChange(GeofencesChangeEvent event) {
        mEventSink.success(event.toMap());
    }
}