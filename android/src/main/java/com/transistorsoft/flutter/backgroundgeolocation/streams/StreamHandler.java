package com.transistorsoft.flutter.backgroundgeolocation.streams;

import android.content.Context;

import com.transistorsoft.flutter.backgroundgeolocation.BackgroundGeolocationModule;
import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.logger.TSLog;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

class StreamHandler implements EventChannel.StreamHandler{
    protected Context mContext;
    protected EventChannel.EventSink mEventSink;
    private EventChannel mChannel;
    String mEvent;

    public StreamHandler register(Context context, BinaryMessenger messenger) {
        mContext = context;
        String path = BackgroundGeolocationModule.PLUGIN_ID + "/events/" + mEvent;
        TSLog.logger.debug(path);

        mChannel = new EventChannel(messenger, path);
        mChannel.setStreamHandler(this);
        return this;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        TSLog.logger.debug(mEvent);
        mEventSink = eventSink;
    }
    @Override
    public void onCancel(Object args) {
        BackgroundGeolocation.getInstance(mContext).removeListener(mEvent, this);
    }

}
