package com.timespeed.time_hello.util;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.SystemClock;
import android.text.TextUtils;
import android.widget.RemoteViews;

import com.timespeed.time_hello.MainActivity;
import com.timespeed.time_hello.R;
import com.timespeed.time_hello.model.CounterStatusModel;
import com.timespeed.time_hello.receiver.NotificationPublisher;

import java.text.SimpleDateFormat;
import java.util.Date;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;

public class LocalNotificationManager {
    static LocalNotificationManager mNotificationManager;
    private FlutterActivity flutterActivity;
    private NotificationManagerCompat notificationManager;
    NotificationChannel notificationChannel = null;

    //    PendingIntent pendingIntent;
    public static synchronized LocalNotificationManager getInstance() {
        if (mNotificationManager == null) {
            mNotificationManager = new LocalNotificationManager();
        }
        return mNotificationManager;
    }

    public void init(FlutterActivity flutterActivity) {
        this.flutterActivity = flutterActivity;
        notificationManager = NotificationManagerCompat.from(flutterActivity);
    }

    /**
     * 参考
     * https://stackoverflow.com/questions/29344971/java-lang-securityexception-too-many-alarms-500-registered-from-pid-10790-u
     */
    public void cancelAllAlarm() {
//        AlarmManager alarmManager = (AlarmManager) flutterActivity.getSystemService(Context.ALARM_SERVICE);
//
//        Intent updateServiceIntent = new Intent(flutterActivity, NotificationPublisher.class);
//        PendingIntent pendingUpdateIntent = PendingIntent.getService(flutterActivity, 0, updateServiceIntent, 0);
//
//        // Cancel alarms
//        try {
//            alarmManager.cancel(pendingUpdateIntent);
//        } catch (Exception e) {
//        }
        AlarmManager alarmManager = (AlarmManager) flutterActivity.getSystemService(Context.ALARM_SERVICE);

        for (int i = 0; i < 1000; i++) {
            try {
                Intent intent = new Intent("FOOFOOFOO");
                PendingIntent pendingIntent = PendingIntent.getBroadcast(flutterActivity, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT | PendingIntent.FLAG_IMMUTABLE);
                alarmManager.cancel(pendingIntent);

                long firstTime = SystemClock.elapsedRealtime() + 1000;
                alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, firstTime, pendingIntent);
            } catch(Exception e) {
                Log.e("cancelAllAlarm", "cancelAllAlarm: " + e.getMessage());
            }
        }
    }

    public void cancelAlarm(int id) {
        Intent notificationIntent = new Intent(flutterActivity, NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id);
//        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, getNotification(flutterActivity, id, title, content));
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ComponentName componentName = new ComponentName(flutterActivity.getPackageName(), "com.timespeed.time_hello.receiver.NotificationPublisher");
            notificationIntent.setComponent(componentName);
        }

//        第二個引數requestCode相同的話後面的定時器會將前面的定時器"覆蓋"掉，只會啟動最後一個定時器，
//        所以同一時間的定時器可以用同一個requestCode，不同時間的定時器用不同的requestCode。
        notificationIntent.setAction("com.timespeed.notification");
//        notificationIntent.putExtra("title", title);
//        notificationIntent.putExtra("content", content);
//        notificationIntent.putExtra("summaryText", summaryText);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(flutterActivity, id, notificationIntent, PendingIntent.FLAG_MUTABLE);
//        flutterActivity.sendBroadcast(notificationIntent);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy年-MM月dd日-HH时mm分ss秒");
        Date date = new Date(System.currentTimeMillis());
//        System.out.println(formatter.format(date));

//        formatter = new SimpleDateFormat("yyyy年-MM月dd日-HH时mm分ss秒");
//        date = new Date(whenMilliTimeStamp);
//        System.out.println(formatter.format(date));

        AlarmManager alarmManager = (AlarmManager) flutterActivity.getSystemService(Context.ALARM_SERVICE);

        alarmManager.cancel(pendingIntent);
    }

    public void showCounterNotificationFinalWithWhenTimeStamp(long whenMilliTimeStamp, int id, String title, String content, String summaryText2) {
        if (TextUtils.isEmpty(summaryText2)) summaryText2 = "";
        String finalSummaryText = summaryText2;
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
        Intent notificationIntent = new Intent(flutterActivity, NotificationPublisher.class);
        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION_ID, id);
//        notificationIntent.putExtra(NotificationPublisher.NOTIFICATION, getNotification(flutterActivity, id, title, content));
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ComponentName componentName = new ComponentName(flutterActivity.getPackageName(), "com.timespeed.time_hello.receiver.NotificationPublisher");
            notificationIntent.setComponent(componentName);
        }
        cancelAlarm(id);
//        第二個引數requestCode相同的話後面的定時器會將前面的定時器"覆蓋"掉，只會啟動最後一個定時器，
//        所以同一時間的定時器可以用同一個requestCode，不同時間的定時器用不同的requestCode。
        notificationIntent.setAction("com.timespeed.notification");
        notificationIntent.putExtra("title", title);
        notificationIntent.putExtra("content", content);
        notificationIntent.putExtra("summaryText", finalSummaryText);
        notificationIntent.putExtra("whenMilliTimeStamp", whenMilliTimeStamp);

        PendingIntent pendingIntent;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            pendingIntent = PendingIntent.getBroadcast(flutterActivity, id, notificationIntent, PendingIntent.FLAG_MUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);
        } else {
            pendingIntent = PendingIntent.getBroadcast(flutterActivity, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        }
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy年-MM月dd日-HH时mm分ss秒");
        Date date = new Date(whenMilliTimeStamp);
//        System.out.println(title + " " + whenMilliTimeStamp);

//        System.out.println(id);
//        System.out.println(formatter.format(date));
        AlarmManager alarmManager = (AlarmManager) flutterActivity.getSystemService(Context.ALARM_SERVICE);
        if (whenMilliTimeStamp > 1000000000) {
                alarmManager.set(AlarmManager.RTC_WAKEUP, whenMilliTimeStamp, pendingIntent);
        }
    }

    private void notify(Context context, int id, String title, String content) {
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
                new NotificationCompat.Builder(context.getApplicationContext(), "notify_001");
        mBuilder.setVibrate(l).setSilent(false);
        Intent ii = new Intent(context.getApplicationContext(), MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, ii, 0);

        NotificationCompat.BigTextStyle bigText = new NotificationCompat.BigTextStyle();
        bigText.bigText("1." + title);
        bigText.setBigContentTitle("2." + content);
        bigText.setSummaryText("3." + title);

        mBuilder.setContentIntent(pendingIntent);
        mBuilder.setSmallIcon(R.mipmap.ic_launcher);
        mBuilder.setContentTitle("4." + title);
        mBuilder.setContentText("5." + content);
        mBuilder.setPriority(Notification.PRIORITY_MAX);
        mBuilder.setStyle(bigText);

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


    public void showCounterNotificationFinalWithDelay(CounterStatusModel counterStatusModel, int delay) {
        showCounterNotificationFinalWithDelay(counterStatusModel, delay, 1);
    }

    /**
     * 没问题
     */
    public void showCounterNotificationFinalWithDelay(CounterStatusModel counterStatusModel, int delay, int id) {
        NotificationManager notificationManager = (NotificationManager) this.flutterActivity.getSystemService(this.flutterActivity.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationChannel = new NotificationChannel("" + id, "channel_name", NotificationManager.IMPORTANCE_HIGH);
            notificationManager.createNotificationChannel(notificationChannel);
        }
        RemoteViews expandedView = Utility.getRemoteViews(this.flutterActivity.getApplicationContext(), counterStatusModel);
        expandedView.setTextViewText(R.id.textview_title, TextUtils.isEmpty(counterStatusModel.getTitle()) ? "" : counterStatusModel.getTitle());
        long[] l = {0, 1000, 1000, 1000};
        //todo 临时注释
        Notification notificationWithDelay = new NotificationCompat.Builder(this.flutterActivity, "" + id)
                .setCustomBigContentView(expandedView)
                .setCustomContentView(expandedView)
                .setCustomHeadsUpContentView(expandedView)
                .setWhen(System.currentTimeMillis() + delay * 1000 + 500) //我觉得可以搞定时推送
                .setAutoCancel(false)
                .setSilent(false)
                .setVibrate(l)
                .setSmallIcon(R.mipmap.ic_launcher)
//                .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
                .build();
        notificationManager.notify(id, notificationWithDelay);
    }

    public void cancelNotificationWithId(int id) {
        notificationManager.cancel(id);
    }

    public void cancelAllNotification() {
        notificationManager.cancelAll();
    }

    public void cancelNotificationWithTag(String tag, int id) {
        notificationManager.cancel(tag, id);
    }


    /**
     * 没问题
     */
    public void showNotificationFinal(CounterStatusModel counterStatusModel) {
        NotificationManager notificationManager = (NotificationManager) this.flutterActivity.getSystemService(this.flutterActivity.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationChannel = new NotificationChannel("001", "channel_name", NotificationManager.IMPORTANCE_HIGH);
            notificationManager.createNotificationChannel(notificationChannel);
        }
        RemoteViews expandedView = Utility.getRemoteViews(this.flutterActivity.getApplicationContext(), counterStatusModel);
        expandedView.setTextViewText(R.id.textview_title, TextUtils.isEmpty(counterStatusModel.getTitle()) ? "" : counterStatusModel.getTitle());
        //todo 临时注释
        Notification notification = new NotificationCompat.Builder(this.flutterActivity, "001")
                .setCustomBigContentView(expandedView)
                .setCustomContentView(expandedView)
                .setSilent(true)
                .setCustomHeadsUpContentView(expandedView)
                .setWhen(System.currentTimeMillis()) //我觉得可以搞定时推送
                .setAutoCancel(false)
                .setVibrate(null)
                .setSmallIcon(R.mipmap.ic_launcher)
//                .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
                .build();
        notificationManager.notify(1, notification);
    }

    public void hideNotificationFinal() {
        if (notificationManager != null) {
            notificationManager.cancel(1);
        }
    }

    /**
     * 设置正常推送
     */
    public static void showNormalNotifcation(Context context, String title, String content) {
        //定义一个PendingIntent点击Notification后启动一个Activity
        NotificationManager manager = (NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);//NotificationManager实例对通知进行管理
        Notification notification = new Notification(R.drawable.ic_launcher, "通知", System.currentTimeMillis());//创建Notification对象
//        notification.setLatestEventInfo(this, "通知标题", "通知内容",null);
        //Uri soundUri=Uri.fromFile(new File("/system/media/audio/ringtones/Basic_tone.ogg"));
        //notification.sound=soundUri;
        notification.ledARGB = Color.GREEN;//控制通知的led灯颜色
        notification.ledOnMS = 1000;//通知灯的显示时间
        notification.ledOffMS = 1000;
        notification.flags = Notification.FLAG_SHOW_LIGHTS;
        manager.notify(1, notification);//调用NotificationManager的notify方法使通知显示
    }


    /**
     * 设置正常推送
     */
    public static void showNormalRemoteViewNotifcation(Context context, String title, String summary) {
        LocalNotificationManager.showNormalNotifcation(context, title, summary);


        NotificationManager notificationManager = (NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel("002", "channel_name", NotificationManager.IMPORTANCE_HIGH);
            notificationManager.createNotificationChannel(notificationChannel);
        }
//        RemoteViews collapsedView = new RemoteViews(getPackageName(),
//                R.layout.notification_expanded);
        RemoteViews expandedView = Utility.getNormalRemoteViews(context);
        expandedView.setTextViewText(R.id.textview_title, TextUtils.isEmpty(title) ? "" : title);
        expandedView.setTextViewText(R.id.subtitle, TextUtils.isEmpty(summary) ? "" : summary);

        //todo 临时注释
//        expandedView.setImageViewResource(R.id.image,R.drawable.ic_launcher);
//        expandedView.setOnClickPendingIntent(R.id.btn_play,new Intent(this, RemoteActivity.class));


        Notification notification = new NotificationCompat.Builder(context, "002")
                .setCustomBigContentView(expandedView)
                .setCustomContentView(expandedView)
                .setCustomHeadsUpContentView(expandedView)
                .setWhen(System.currentTimeMillis()) //我觉得可以搞定时推送
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setAutoCancel(false)
                .setSmallIcon(R.mipmap.ic_launcher)
//                .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
                .build();
        notificationManager.notify(2, notification);
    }
}