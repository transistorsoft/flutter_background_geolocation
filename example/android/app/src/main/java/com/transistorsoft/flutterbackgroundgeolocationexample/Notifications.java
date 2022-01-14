package com.transistorsoft.flutterbackgroundgeolocationexample;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

public class Notifications {
    public static final int NOTIFICATION_ID_BACKGROUND_SERVICE = 1;

    private static final String CHANNEL_ID_BACKGROUND_SERVICE = "background_service";

    public void createNotificationChannels(@NonNull Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            final NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID_BACKGROUND_SERVICE,
                "Background Service",
                NotificationManager.IMPORTANCE_DEFAULT
            );
            final NotificationManager manager =
                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            manager.createNotificationChannel(channel);
        }
    }

    public Notification buildForegroundNotification(@NonNull  Context context) {
        return new NotificationCompat
            .Builder(context, CHANNEL_ID_BACKGROUND_SERVICE)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Background Service")
            .setContentText("Keeps app process on foreground.")
            .build();
    }
}