package com.timespeed.time_hello.service;

import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.model.CounterStatusModel;
import com.timespeed.time_hello.widgets.MyAppWidgetProvider;

/*
 * 用于监听APP被销毁时回调
 * https://stackoverflow.com/questions/19568315/how-to-handle-running-service-when-app-is-killed-by-swiping-in-android/26882533#26882533
 */
public class BackgroundService extends Service {

    @Override
    public void onCreate() {
        super.onCreate();
        Params.isServiceRunning = true;
    }

    @Override
    public void onDestroy(){
        // 中断线程，即结束线程。
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    /**
     * 用于监听APP被销毁时回调
     * @param rootIntent
     */
    @Override
    public void onTaskRemoved(Intent rootIntent) {
//        Utility.sendNoneStateBroadcastReceiver(this);
        CounterStatusModel counterStatusModel = new CounterStatusModel("", "", 7, true);
        //桌面应用
        Intent intentBroadCast = new Intent(this, MyAppWidgetProvider.class);
        intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        intentBroadCast.putExtra(CONSTANTS.BROADCAST_KEY, counterStatusModel);
        sendBroadcast(intentBroadCast);
        super.onTaskRemoved(rootIntent);
        stopSelf();
        Params.isServiceRunning = false;
    }

    /*
     * 服务开始时，即调用startService()时，onStartCommand()被执行。
     * onStartCommand() 这里的主要作用：
     * (01) 将 appWidgetIds 添加到队列sAppWidgetIds中
     * (02) 启动线程
     */
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);

        return START_STICKY;
    }

}
