package com.timespeed.time_hello.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
//import android.support.v4.app.NotificationManagerCompat;
import android.widget.Toast;

import androidx.core.app.NotificationManagerCompat;

public class NotificationReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        Toast.makeText(context, "Image clicked", Toast.LENGTH_SHORT).show();

        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.cancel(1);
    }
}