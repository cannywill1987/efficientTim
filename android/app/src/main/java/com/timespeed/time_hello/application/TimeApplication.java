package com.timespeed.time_hello.application;

import android.app.Application;
import android.content.Context;
import android.util.Log;


//import com.alibaba.sdk.android.push.CloudPushService;
//import com.alibaba.sdk.android.push.CommonCallback;
//import com.alibaba.sdk.android.push.noonesdk.PushInitConfig;

import androidx.multidex.MultiDexApplication;
//import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
//import com.mob.MobSDK;
import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.crashHandler.CrashHandler;


import androidx.multidex.MultiDex;

public class TimeApplication extends MultiDexApplication {
    //    public FlutterEngine flutterEngine;
    private static final String TAG = "Init1111111111";

    @Override
    protected void attachBaseContext(Context context) {
        super.attachBaseContext(context);
        MultiDex.install(this);
        Log.d(TAG, "init cloudchannel success");
    }

    @Override
    public void onCreate() {
        super.onCreate();
//        initCrashHandler();
//        registerAliyun();

//        CloudPushService pushService = PushServiceFactory.getCloudPushService();
//        pushService.setLogLevel(CloudPushService.LOG_DEBUG);   //仅适用于Debug包，正式包不需要此行
//        pushService.register(this, new CommonCallback() {
//            @Override
//            public void onSuccess(String response) {
//                Log.d(TAG, "init cloudchannel success");
//            }
//
//            @Override
//            public void onFailed(String errorCode, String errorMessage) {
//                Log.d(TAG, "init cloudchannel failed -- errorcode:" + errorCode + " -- errorMessage:" + errorMessage);
//            }
//        });

//        PushInitConfig.Builder builder = new PushInitConfig.Builder();
//        builder.appKey("333716171");
//        builder.appSecret("f0eff7269254413fbc503833de335251");
//        PushServiceFactory.init(this);
//


//        // Instantiate a FlutterEngine.
//        flutterEngine = new FlutterEngine(this);
//
//        // Start executing Dart code to pre-warm the FlutterEngine.
//        flutterEngine.getDartExecutor().executeDartEntrypoint(
//                DartEntrypoint.createDefault()
//        );
//
//        // Cache the FlutterEngine to be used by FlutterActivity.
//        FlutterEngineCache
//                .getInstance()
//                .put("my_engine_id", flutterEngine);
    }


    public void initCrashHandler() {
        //别注释掉 测试需要的
//        if (!Params.isDebug) {
        CrashHandler.getInstance().init(getApplicationContext(), new CrashHandler.ICrashHandle() {

            @Override
            public void handleException(final Thread thread, final Throwable ex) {
                String errStr = Log.getStackTraceString(ex);
//                logger.error(errStr);
//                logger.writeMessageToFile("error", errStr);
            }
        });
//        }
    }

//    public void registerAliyun() {
//        PushServiceFactory.init(this);
//        initCloudChannel(this);
//        // 获取隐私政策签署状态
//        boolean sign = false;
//        if (sign) {
//            registerPush();
//        } else {
//            // 没签，等签署之后再调用registerPush()
//        }
////        MobSDK.init(this, "37349d1054389", "263a217e653718cfb65194d23e11dda1");
//    }

    /**
     * 初始化云推送通道
     *
//     * @param applicationContext
     */
//    private void initCloudChannel(Context applicationContext) {
//        PushServiceFactory.init(applicationContext);
//        CloudPushService pushService = PushServiceFactory.getCloudPushService();
//        Params.aliyunDeviceId = PushServiceFactory.getCloudPushService().getDeviceId();
//        pushService.setLogLevel(CloudPushService.LOG_DEBUG);   //仅适用于Debug包，正式包不需要此行
//        pushService.register(applicationContext, new CommonCallback() {
//            @Override
//            public void onSuccess(String response) {
//                Log.d(TAG, "init cloudchannel success" + pushService.getDeviceId());
//            }
//
//            @Override
//            public void onFailed(String errorCode, String errorMessage) {
//                Log.d(TAG, "init cloudchannel failed -- errorcode:" + errorCode + " -- errorMessage:" + errorMessage);
//            }
//        });
//    }
//
//    /**
//     * 建立推送通道
//     */
//    public void registerPush() {
//        CloudPushService pushService = PushServiceFactory.getCloudPushService();
//        pushService.register(getApplicationContext(), new CommonCallback() {
//            @Override
//            public void onSuccess(String response) {
//                Log.d(TAG, "register cloudchannel success");
//            }
//
//            @Override
//            public void onFailed(String errorCode, String errorMessage) {
//                Log.d(TAG, "register cloudchannel success");
//            }
//        });
//    }

    @Override
    public void onTerminate() {
        super.onTerminate();
    }
}