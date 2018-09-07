package com.transistorsoft.flutter.backgroundgeolocation.streams;

import android.content.Context;

import com.transistorsoft.flutter.backgroundgeolocation.FLTBackgroundGeolocationPlugin;
import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;
import com.transistorsoft.locationmanager.logger.TSLog;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

class StreamHandler implements EventChannel.StreamHandler{
    protected Context mContext;
    protected EventChannel.EventSink mEventSink;
    String mEvent;

    public void register(PluginRegistry.Registrar registrar) {
        mContext = registrar.context();
        String path = FLTBackgroundGeolocationPlugin.PLUGIN_ID + "/events/" + mEvent;
        TSLog.logger.debug(path);

        new EventChannel(registrar.messenger(), path).setStreamHandler(this);
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
