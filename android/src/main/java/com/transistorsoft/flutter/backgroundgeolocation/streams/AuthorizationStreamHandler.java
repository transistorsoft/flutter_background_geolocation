package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.callback.TSAuthorizationCallback;
import com.transistorsoft.locationmanager.config.TSAuthorization;
import com.transistorsoft.locationmanager.event.AuthorizationEvent;
import com.transistorsoft.locationmanager.http.HttpService;

import io.flutter.plugin.common.EventChannel;

public class AuthorizationStreamHandler extends StreamHandler implements TSAuthorizationCallback {

    public AuthorizationStreamHandler() {
        mEvent = TSAuthorization.NAME;
    }
    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        HttpService.getInstance(mContext).onAuthorization(this);
    }

    @Override
    public void onCancel(Object args) {
        HttpService.getInstance(mContext).removeListener(mEvent, this);
    }

    @Override
    public void onResponse(AuthorizationEvent response) {
        mEventSink.success(response.toMap());
    }
}