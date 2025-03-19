package com.timespeed.time_hello;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;


//import com.mob.flutter.secverify.SecverifyPlugin;
import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.service.BackgroundService;
import com.timespeed.time_hello.util.LocalNotificationManager;
import com.timespeed.time_hello.util.CounterMethodChannelManager;
//import com.timespeed.time_hello.util.MethodChannelManager;
import com.timespeed.time_hello.util.SharePreferenceUtil;
import com.timespeed.time_hello.util.Utility;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    Intent i;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 注册SecVerify Flutter插件
        CounterMethodChannelManager.getInstance().init(this, getFlutterEngine());
//        MethodChannelManager.getInstance().init(this, getFlutterEngine());
//        startService(i = new Intent(this, BackgroundService.class));
        Params.isMainActivityDestroyed = false;
//        String signature = Utility.getSignature(this);
//        Log.i("signature", "signature:" + signature);
        // 检查是否已经被授权
//        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.SET_ALARM) == PackageManager.PERMISSION_GRANTED) {
//            // 已经被授权，执行相关操作
//        } else {
//            // 未被授权，请求权限
//            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.SET_ALARM}, 123);
//        }

//        if (Utility.getBrand() == "HUAWEI") {
//            // 打开SDK日志开关
//            HiAnalyticsTools.enableLog();
//            HiAnalyticsInstance instance = HiAnalytics.getInstance(this);
//        }


    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        if(SharePreferenceUtil.getInstance(this).getBoolean(Params.sharePreferenceEngineInited, false) == true) {
            GeneratedPluginRegistrant.registerWith(flutterEngine);
//            SharePreferenceUtil.getInstance(this).setBoolean(Params.sharePreferenceEngineInited, true);
//        }
//        SecverifyPlugin.registerWith(flutterEngine);

        super.configureFlutterEngine(flutterEngine);
    }

    @Override
    protected void onResume() {
        super.onResume();
//        sendBroadcast(new Intent());
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        CounterMethodChannelManager.getInstance().settingResult(resultCode);
        if (requestCode == 3 && resultCode == RESULT_OK) {

            // SearchAddressInfo info = (SearchAddressInfo) data.getParcelableExtra("position");
//            String position = data.getStringExtra("position");
//            mTvClockInAddress.setText(position);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Utility.sendNoneStateBroadcastReceiver(this);
        if (i != null) {
            stopService(i);
            i = null;
        }
    }

}
