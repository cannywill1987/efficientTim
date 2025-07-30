package com.timespeed.time_hello.widgets;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.RemoteViews;

import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.util.Utility;


//@android.support.annotation.RequiresApi(api = Build.VERSION_CODES.CUPCAKE)
public class MyNote6WidgetProvider extends AppWidgetProvider {

    @Override
    public void onReceive(final Context context, Intent intent) {
        super.onReceive(context, intent);
        String action = intent.getAction();
        if (AppWidgetManager.ACTION_APPWIDGET_DELETED.equals(action)) {
            Bundle extras = intent.getExtras();
            if (extras != null && extras.containsKey(AppWidgetManager.EXTRA_APPWIDGET_ID)) {
                final int appWidgetId = extras.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID);
                this.onDeleted(context, new int[] { appWidgetId });
            }
        }else if (AppWidgetManager.ACTION_APPWIDGET_OPTIONS_CHANGED.equals(action)) {
            Bundle extras = intent.getExtras();
            if (extras != null && extras.containsKey(AppWidgetManager.EXTRA_APPWIDGET_ID)
                    && extras.containsKey(AppWidgetManager.EXTRA_APPWIDGET_OPTIONS)) {
                int appWidgetId = extras.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID);
                Bundle widgetExtras = extras.getBundle(AppWidgetManager.EXTRA_APPWIDGET_OPTIONS);
                this.onAppWidgetOptionsChanged(context, AppWidgetManager.getInstance(context),
                        appWidgetId, widgetExtras);
            }
        } else if (AppWidgetManager.ACTION_APPWIDGET_ENABLED.equals(action)) {
            this.onEnabled(context);
        } else if (AppWidgetManager.ACTION_APPWIDGET_DISABLED.equals(action)) {
            this.onDisabled(context);
            // 点击的是第三个按钮
        }
//        else if (action.equals(Params.ACTION_CLICK_NEXT)) {//MyAppWidget pause按钮点击
//            long time = intent.getLongExtra("time", System.currentTimeMillis());
//            AppWidgetManager.getInstance(context).updateAppWidget(new ComponentName(context, MyCalendar2WidgetProvider.class), Utility.getMyCalendarRemoteViews2(context, time));
//        }else if (action.equals(Params.ACTION_CLICK_PREV)) {//MyAppWidget pause按钮点击
//            long time = intent.getLongExtra("time", System.currentTimeMillis());
//            AppWidgetManager.getInstance(context).updateAppWidget(new ComponentName(context, MyCalendar2WidgetProvider.class), Utility.getMyCalendarRemoteViews2(context, time));
//        }
        else if (AppWidgetManager.ACTION_APPWIDGET_UPDATE.equals(action)) {
            AppWidgetManager.getInstance(context).updateAppWidget(new ComponentName(context, MyNote6WidgetProvider.class), Utility.getMyNoteView(context, "6"));
        }
//        AppWidgetManager.updateAppWidget();

    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        Log.d("MyAppWidgetProvider", "调用了onUpdate方法");
//        remoteViews.setImageViewResource(R.id.image, R.drawable.icon);
//        remoteViews.setTextViewText(R.id.textView2, "我是桌面小组件");
//        remoteViews.setOnClickPendingIntent(R.id.textView2, pendingIntent);
//        Intent intent = new Intent(context, MainActivity.class);
//        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
//        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.counter_notification_widget);
//        appWidgetManager.updateAppWidget(appWidgetIds, remoteViews);//用updateAppWidget来更新remoteViews的状态
        int count = appWidgetIds.length;
        CONSTANTS.appWidgetIds = appWidgetIds;
        for (int i = 0; i < count; i++) {
            int appWidgetId = appWidgetIds[i];
            onWidgetUpdate(context, appWidgetManager, appWidgetId);
        }
    }


    /**
     * 更新桌面小部件
     * @param context
     * @param appWidgetManager
     * @param appWidgetId
     */
    private void onWidgetUpdate(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        RemoteViews remoteViews = Utility.getMyNoteView(context, "6");
//        appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.listview4);
//        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, remoteViews);
        appWidgetManager.updateAppWidget(appWidgetId, remoteViews);
    }


    // 当 widget 被初次添加 或者 当 widget 的大小被改变时，被调用
    @Override
    public void onAppWidgetOptionsChanged(Context context,
                                          AppWidgetManager appWidgetManager, int appWidgetId,
                                          Bundle newOptions) {
        Log.d(CONSTANTS.LOG_TAG, "onAppWidgetOptionsChanged");
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId,
                newOptions);
    }

    // widget被删除时调用
    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        Log.d(CONSTANTS.LOG_TAG, "onDeleted(): appWidgetIds.length="+appWidgetIds.length);

        // 当 widget 被删除时，对应的删除set中保存的widget的id
//        for (int appWidgetId : appWidgetIds) {
//            idsSet.remove(Integer.valueOf(appWidgetId));
//        }
//        prtSet();
        super.onDeleted(context, appWidgetIds);
    }
    // 第一个widget被创建时调用
    @Override
    public void onEnabled(Context context) {
        Log.d(CONSTANTS.LOG_TAG, "onEnabled");
        super.onEnabled(context);
    }
    // 最后一个widget被删除时调用
    @Override
    public void onDisabled(Context context) {
        Log.d(CONSTANTS.LOG_TAG, "onDisabled");
        // 在最后一个 widget 被删除时，终止服务
        super.onDisabled(context);
    }

}
