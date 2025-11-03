package com.timespeed.time_hello.receiver;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;

import com.timespeed.time_hello.MainActivity;
import com.timespeed.time_hello.R;

import java.text.SimpleDateFormat;
import java.util.Locale;

import androidx.core.app.NotificationCompat;
import io.flutter.Log;

public class NotificationPublisher extends BroadcastReceiver {
    public static String NOTIFICATION_ID = "notification_id";
    public static String NOTIFICATION = "notification";

    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            Notification notification = intent.getParcelableExtra(NOTIFICATION);
            String title = intent.getStringExtra("title");
            String content = intent.getStringExtra("content");
            String summaryText = intent.getStringExtra("summaryText");
            long whenMilliTimeStamp = intent.getLongExtra("whenMilliTimeStamp", 0);
//            Log.i("1231111111111111111", "title:" + title + " whenMilliTimeStamp:" + whenMilliTimeStamp + ",System.currentTimeMillis():" + System.currentTimeMillis() + " result:" + (whenMilliTimeStamp > 0 && (System.currentTimeMillis() - 10 * 1000) < whenMilliTimeStamp && (System.currentTimeMillis() + 10 * 1000) > whenMilliTimeStamp));
            int id = intent.getIntExtra(NOTIFICATION_ID, 0);
//        if (whenMilliTimeStamp > 0 && (System.currentTimeMillis() - 10 * 1000) <whenMilliTimeStamp && (System.currentTimeMillis() + 10 * 1000) > whenMilliTimeStamp ) {
            if (whenMilliTimeStamp > 0 && (System.currentTimeMillis() - 1 * 60 * 1000) < whenMilliTimeStamp) {
                notify(context, id, title, content, summaryText, whenMilliTimeStamp);
            }
        } catch (Exception e) {

        }
//        showNotification(context);
//        notificationManager.notify(id, getNotification(context, id, "title", "content"));
    }

    private void notify(Context context, int id, String title, String content, String summaryText, long whenMilliTimeStamp) {
        long[] l = {0, 1000, 1000, 1000};
//        NotificationCompat.Builder builder = new NotificationCompat.Builder(context)
//                .setChannelId(id + "")
//                .setSmallIcon(R.mipmap.ic_launcher)
//                .setShowWhen(true)
//                .setSilent(false)
//                .setVibrate(l)
//                .setSmallIcon(R.mipmap.ic_launcher)
//                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher))
//                .setContentTitle(title)
//                .setContentText(content);


        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(context.getApplicationContext(), "" + id);
        mBuilder.setVibrate(l).setSilent(false);
        Intent ii = new Intent(context.getApplicationContext(), MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, id, ii, PendingIntent.FLAG_MUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.BigTextStyle bigText = new NotificationCompat.BigTextStyle();
        //头部
        bigText.setSummaryText(summaryText);
        //title
//        bigText.setBigContentTitle(content);
//        //title下面的内容
//        bigText.bigText(title);

        mBuilder.setContentIntent(pendingIntent);
        mBuilder.setSmallIcon(R.mipmap.ic_launcher);
        //好像没什么用
        mBuilder.setContentTitle(title);
        mBuilder.setContentText(content);
        mBuilder.setPriority(Notification.PRIORITY_MAX);
        mBuilder.setStyle(bigText);
//        mBuilder.setShowWhen(true);
        mBuilder.setWhen(whenMilliTimeStamp + 1000);

        NotificationManager mNotificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

// === Removed some obsoletes
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String channelId = "" + id;
            NotificationChannel channel = new NotificationChannel(
                    channelId,
                    title,
                    NotificationManager.IMPORTANCE_HIGH);
            mNotificationManager.createNotificationChannel(channel);
            mBuilder.setChannelId(channelId);
        }

        mNotificationManager.notify(id, mBuilder.build());
//        return builder.build();
    }
}
