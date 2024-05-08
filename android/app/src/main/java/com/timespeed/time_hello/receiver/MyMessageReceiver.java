package com.timespeed.time_hello.receiver;

import android.app.Notification;
import android.app.NotificationChannel;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
import android.widget.RemoteViews;

//import com.alibaba.sdk.android.push.MessageReceiver;
//import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.R;
import com.timespeed.time_hello.model.CounterStatusModel;
import com.timespeed.time_hello.util.LocalNotificationManager;
import com.timespeed.time_hello.widgets.MyAppWidgetProvider;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import androidx.core.app.NotificationCompat;

/**
 * 阿里云推送 demo
 * https://help.aliyun.com/document_detail/48038.htm?spm=a2c4g.11186623.0.0.49ae363fjfYbly
 */
// extends MessageReceiver
public class MyMessageReceiver {
   // 消息接收部分的LOG_TAG
   public static final String REC_TAG = "receiver";
//   @Override
   public void onNotification(Context context, String title, String summary, Map<String, String> extraMap) {
      // TODO处理推送通知
////      extraMap[''];
//      String action = (String) extraMap.get("action");
//      Log.e("MyMessageReceiver", "Receive notification, title: " + title + ", summary: " + summary + ", extraMap: " + extraMap);
//
//      switch (action) {
//         case Params.UPDATE_COUNTER_STATUS_ACTION:
////      String text = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("text");
////      String title = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");
//            Integer status = Integer.parseInt(extraMap.get("status"));
//            Boolean shouldShowRedFocusStatus = Boolean.parseBoolean(extraMap.get("shouldShowRedFocusStatus"));
//            CounterStatusModel counterStatusModel = new CounterStatusModel(title, summary, status, shouldShowRedFocusStatus);
//            //下拉推送
//            LocalNotificationManager.getInstance().showNotificationFinal(counterStatusModel);
//            //桌面应用
//            Intent intentBroadCast = new Intent(context, MyAppWidgetProvider.class);
//            intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
//            intentBroadCast.putExtra(CONSTANTS.BROADCAST_KEY, counterStatusModel);
//            context.sendBroadcast(intentBroadCast);
//            break;
//         default:
//            showNotification(context, title, summary);
//            break;
//      }

   }
//   @Override
//   public void onMessage(Context context, CPushMessage cPushMessage) {
//      showNotification(context, cPushMessage.getTitle(), cPushMessage.getContent());
//      Log.e("MyMessageReceiver", "onMessage, messageId: " + cPushMessage.getMessageId() + ", title: " + cPushMessage.getTitle() + ", content:" + cPushMessage.getContent());
//   }
//   @Override
//   public void onNotificationOpened(Context context, String title, String summary, String extraMap) {
//      Log.e("MyMessageReceiver", "onNotificationOpened, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
//   }
//   @Override
//   protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
//      Log.e("MyMessageReceiver", "onNotificationClickedWithNoAction, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
//   }
//   @Override
//   protected void onNotificationReceivedInApp(Context context, String title, String summary, Map<String, String> extraMap, int openType, String openActivity, String openUrl) {
//      Log.e("MyMessageReceiver", "onNotificationReceivedInApp, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap + ", openType:" + openType + ", openActivity:" + openActivity + ", openUrl:" + openUrl);
//   }
//   @Override
//   protected void onNotificationRemoved(Context context, String messageId) {
//      Log.e("MyMessageReceiver", "onNotificationRemoved");
//   }
//
//   /**
//    * 没问题
//    */
//   public void showNotification(Context context, String title, String summary) {
//      LocalNotificationManager.showNormalRemoteViewNotifcation(context, title, summary);


//      android.app.NotificationManager notificationManager = (android.app.NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);
//      if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//         NotificationChannel notificationChannel = new NotificationChannel("002", "channel_name", android.app.NotificationManager.IMPORTANCE_HIGH);
//         notificationManager.createNotificationChannel(notificationChannel);
//      }
////        RemoteViews collapsedView = new RemoteViews(getPackageName(),
////                R.layout.notification_expanded);
//      RemoteViews expandedView = Utility.getNormalRemoteViews(context);
//      expandedView.setTextViewText(R.id.textview_title, TextUtils.isEmpty(title) ? "" : title);
//      expandedView.setTextViewText(R.id.subtitle, TextUtils.isEmpty(summary) ? "" : summary);
//
//      //todo 临时注释
////        expandedView.setImageViewResource(R.id.image,R.drawable.ic_launcher);
////        expandedView.setOnClickPendingIntent(R.id.btn_play,new Intent(this, RemoteActivity.class));
//
//
//      Notification notification = new NotificationCompat.Builder(context, "002")
//              .setCustomBigContentView(expandedView)
//              .setCustomContentView(expandedView)
//              .setCustomHeadsUpContentView(expandedView)
//              .setWhen(System.currentTimeMillis()) //我觉得可以搞定时推送
//              .setPriority(NotificationCompat.PRIORITY_MAX)
//              .setAutoCancel(false)
//              .setSmallIcon(R.mipmap.ic_launcher)
////                .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
//              .build();
//      notificationManager.notify(2, notification);
//   }
}