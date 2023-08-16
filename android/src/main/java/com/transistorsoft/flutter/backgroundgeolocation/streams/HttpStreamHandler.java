package com.transistorsoft.flutter.backgroundgeolocation.streams;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.adapter.callback.TSHttpResponseCallback;
import com.transistorsoft.locationmanager.http.HttpResponse;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class HttpStreamHandler extends StreamHandler implements TSHttpResponseCallback {

    public HttpStreamHandler() {
        mEvent = BackgroundGeolocation.EVENT_HTTP;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        super.onListen(args, eventSink);
        BackgroundGeolocation.getInstance(mContext).onHttp(this);
    }

    @Override
    public void onHttpResponse(HttpResponse response) {
        Map<String, Object> event = new HashMap<>();
        event.put("success", response.isSuccess());
        event.put("status", response.status);
        event.put("responseText", response.responseText);
        mEventSink.success(event);
    }
}