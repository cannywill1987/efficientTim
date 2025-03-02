package com.timespeed.time_hello.util;

import android.appwidget.AppWidgetManager;
import android.content.Intent;
import android.util.Log;

//import com.alibaba.fastjson.JSON;
//import com.alibaba.fastjson.JSONObject;
//import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
//import com.alibaba.fastjson.JSON;
//import com.alibaba.fastjson.JSONObject;
//import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.R;
import com.timespeed.time_hello.customInterface.OnResultListener;
import com.timespeed.time_hello.model.CounterStatusModel;
import com.timespeed.time_hello.widgets.MyAppWidgetProvider;
import com.timespeed.time_hello.widgets.MyCalendar2WidgetProvider;
import com.timespeed.time_hello.widgets.MyClockIn2WidgetProvider;
import com.timespeed.time_hello.widgets.MyNote2WidgetProvider;
import com.timespeed.time_hello.widgets.MyNote3WidgetProvider;
import com.timespeed.time_hello.widgets.MyNote4WidgetProvider;
import com.timespeed.time_hello.widgets.MyNote5WidgetProvider;
import com.timespeed.time_hello.widgets.MyNote6WidgetProvider;
import com.timespeed.time_hello.widgets.MyNote7WidgetProvider;
import com.timespeed.time_hello.widgets.MyNoteWidgetProvider;
import com.timespeed.time_hello.widgets.MyQuadrantWidgetProvider;

import android.os.Handler;

import java.util.ArrayList;
import java.util.HashMap;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CounterMethodChannelManager {
    static CounterMethodChannelManager mCounterMethodChannelManager;
    private MethodChannel methodChannel;
    private FlutterActivity flutterActivity;
    public final static String METHOD_CHANNEL = "com.efficienttime.counter";

    public static synchronized CounterMethodChannelManager getInstance() {
        if (mCounterMethodChannelManager == null) {
            mCounterMethodChannelManager = new CounterMethodChannelManager();
        }
        return mCounterMethodChannelManager;
    }

    public void init(FlutterActivity flutterActivity, FlutterEngine flutterEngine) {
        this.flutterActivity = flutterActivity;
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL);
        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                try {
                    switch (call.method) {
                        case "shareToWechat":
                            String imageData = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("imageData");
                            String mIconUrlWechat = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("iconUrl");
                            int toWhere = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(0)).get("toWhere"); //toWhere 0 微信朋友 1 微信朋友圈
                            String urlWechat = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("url");
                            String subtitleWechat = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("subtitle");
                            String titleWechat = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");

                            Utility.shareToWeChat(flutterActivity.getActivity(), toWhere, urlWechat, titleWechat, subtitleWechat, mIconUrlWechat, imageData, new OnResultListener() {
                                @Override
                                public void onComplete(Object data) {

                                }

                                @Override
                                public void onCancel() {

                                }

                                @Override
                                public void onFailure(Object msg) {

                                }
                            });
                            break;
                        case "Logs":
                            String TAG = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("TAG");
                            String msg = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("msg");
                            Log.d(TAG, msg);
                            break;
                        case "shareToQQ":
                            String mIconUrlQQ = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("iconUrl");
                            String urlQQ = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("url");
                            String subtitleQQ = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("subtitle");
                            String titleQQ = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");
                            boolean isOnQQ = ((HashMap<String, Boolean>) ((ArrayList) call.arguments).get(0)).get("isOn");
//                        boolean shouldShowRedFocusStatus = ((HashMap<String, Boolean>) ((ArrayList) call.arguments).get(0)).get("shouldShowRedFocusStatus");

                            Utility.shareToQQ(flutterActivity.getActivity(), titleQQ, subtitleQQ, urlQQ, mIconUrlQQ, isOnQQ, new OnResultListener() {

                                @Override
                                public void onComplete(Object data) {

                                }

                                @Override
                                public void onCancel() {

                                }

                                @Override
                                public void onFailure(Object msg) {

                                }
                            });
                            break;
                        case "storeWQBNoteMissionData":
                            String key = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("key");
                            String content = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("content");
                            String subtitle = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("subtitle");
                            long color = ((HashMap<String, Long>) ((ArrayList) call.arguments).get(0)).get("color");
//                            int priorityStatus = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(0)).get("priorityStatus");
                            SharePreferenceUtil.getInstance(flutterActivity).setHashMap(CONSTANTS.SHAREPREFRENCE_WQB_NOTE + key, ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)));
                            HashMap hashMap = SharePreferenceUtil.getInstance(flutterActivity).getHashMap(CONSTANTS.SHAREPREFRENCE_WQB_NOTE);
                            if (key.equals("1")) {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNoteWidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            } else if (key.equals("2"))     {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNote2WidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            } else if (key.equals("3")) {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNote3WidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            } else if (key.equals("4")) {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNote4WidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            } else if (key.equals("5")) {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNote5WidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            } else if (key.equals("6")) {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNote6WidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            } else if (key.equals("7")) {
                                Intent intentBroadCast = new Intent(flutterActivity, MyNote7WidgetProvider.class);
                                intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                            }
                            break;
                        case "storeFlomoMissionList":
                            ArrayList arrayFlomo = (ArrayList) call.arguments;

                            SharePreferenceUtil.getInstance(flutterActivity).setModelsArray(CONSTANTS.BROADCAST_FLOMO_MODELS, arrayFlomo);
                            //桌面应用
//                        Intent intentBroadCast2 = new Intent(flutterActivity, MyClockinWidgetProvider.class);
//                        intentBroadCast2.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
//                        flutterActivity.getActivity().sendBroadcast(intentBroadCast2);

                            Intent intentBroadCast4 = new Intent(flutterActivity, MyClockIn2WidgetProvider.class);
                            intentBroadCast4.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                            flutterActivity.getActivity().sendBroadcast(intentBroadCast4);
                            break;
                        case "storeMyCalendarMissionList":
                            ArrayList arrayMission = (ArrayList) call.arguments;

                            SharePreferenceUtil.getInstance(flutterActivity).setModelsArray(CONSTANTS.BROADCAST_MYCAlendar_MODELS, arrayMission);
                            //桌面应用
//                        Intent intentBroadCast2 = new Intent(flutterActivity, MyClockinWidgetProvider.class);
//                        intentBroadCast2.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
//                        flutterActivity.getActivity().sendBroadcast(intentBroadCast2);

//                        Intent intentBroadCast4 = new Intent(flutterActivity, MyClockIn2WidgetProvider.class);
//                        intentBroadCast4.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
//                        flutterActivity.getActivity().sendBroadcast(intentBroadCast4);

                            intentBroadCast4 = new Intent(flutterActivity, MyCalendar2WidgetProvider.class);
                            intentBroadCast4.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                            flutterActivity.getActivity().sendBroadcast(intentBroadCast4);
                            break;

                        case "storeMissionDataList":
                            String title1 = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");
                            String title2 = ((HashMap<String, String>) ((ArrayList) call.arguments).get(1)).get("title");
                            String title3 = ((HashMap<String, String>) ((ArrayList) call.arguments).get(2)).get("title");
                            String title4 = ((HashMap<String, String>) ((ArrayList) call.arguments).get(3)).get("title");

                            ArrayList array1 = ((HashMap<String, ArrayList>) ((ArrayList) call.arguments).get(0)).get("datas");
                            ArrayList array2 = ((HashMap<String, ArrayList>) ((ArrayList) call.arguments).get(1)).get("datas");
                            ArrayList array3 = ((HashMap<String, ArrayList>) ((ArrayList) call.arguments).get(2)).get("datas");
                            ArrayList array4 = ((HashMap<String, ArrayList>) ((ArrayList) call.arguments).get(3)).get("datas");


                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityTitle(CONSTANTS.BROADCAST_TITlE1, title1);
                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityTitle(CONSTANTS.BROADCAST_TITlE2, title2);
                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityTitle(CONSTANTS.BROADCAST_TITlE3, title3);
                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityTitle(CONSTANTS.BROADCAST_TITlE4, title4);

                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityArray(CONSTANTS.BROADCAST_DATA1, array1);
                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityArray(CONSTANTS.BROADCAST_DATA2, array2);
                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityArray(CONSTANTS.BROADCAST_DATA3, array3);
                            SharePreferenceUtil.getInstance(flutterActivity).setPriorityArray(CONSTANTS.BROADCAST_DATA4, array4);

                            //桌面应用
                            Intent intentBroadCast3 = new Intent(flutterActivity, MyQuadrantWidgetProvider.class);
                            intentBroadCast3.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                            flutterActivity.getActivity().sendBroadcast(intentBroadCast3);

//                        //桌面应用
//                        intentBroadCast3 = new Intent(flutterActivity, MyCalendarWidgetProvider.class);
//                        intentBroadCast3.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
//                        flutterActivity.getActivity().sendBroadcast(intentBroadCast3);


                            break;
                        case "turnOnPushChannel":
//                        Utility.turnOnPushChannel(new OnResultListener() {
//                            @Override
//                            public void onComplete(String data) {
//                                result.success("{\"success\": true, \"data\": \""+data+"\"}");//返回结果给Dart
//                            }
//
//                            @Override
//                            public void onComplete(Object data) {
//
//                            }
//
//                            @Override
//                            public void onCancel() {
//
//                            }
//
//                            @Override
//                            public void onFailure(Object msg) {
//
//                            }
//
////                            @Override
////                            public void onCancel() {
////
////                            }
////
////                            @Override
////                            public void onFailure(Object msg) {
////
////                            }
////
////                            @Override
////                            public void onFailure() {
////                                result.success("{\"success\": false}");//返回结果给Dart
////                            }
////
////                            @Override
////                            public void onFailure(String msg) {
////
////                            }
//                        });
                            break;
                        case "turnOffPushChannel":
                            Utility.turnOffPushChannel(new OnResultListener() {
                                @Override
                                public void onComplete(Object data) {

                                }

                                @Override
                                public void onCancel() {

                                }

                                @Override
                                public void onFailure(Object msg) {

                                }

//                            @Override
//                            public void onComplete(String data) {
//                                result.success("{\"success\": true, \"data\": \""+data+"\"}");//返回结果给Dart
//                            }
//
//                            @Override
//                            public void onFailure() {
//                                result.success("{\"success\": false}");//返回结果给Dart
//                            }
                            });
                            break;

                        case "shareSdkSubmitPolicyGrantResult":
//                        ShareSdkManager.getInstance().submitPolicyGrantResult(true);
                            break;
                        case "preSecVerify": //sharesdk 预登陆
                            result.success("{\"success\": false, \"message\": \"\" }");//返回结果给Dart
//                        ShareSdkManager.getInstance().preVerify(new OnPreLoginListener() {
//                            @Override
//                            public void onComplete(String data) {
//                                result.success("{\"success\": true, \"data\": \""+data+"\"}");//返回结果给Dart
//                            }
//                            @Override
//                            public void onFailure(String e) {
//                                result.success("{\"success\": false, \"message\": \""+e+"\" }");//返回结果给Dart
//                            }
//                        });
                            break;
                        case "secVerify": //sharesdk秒登录
//                        ShareSdkManager.getInstance().verify(new OnLoginListener() {
//                            @Override
//                            public void onComplete(String data) {
//                                result.success("{\"success\": true, \"code\":\"0000\", \"data\": "+data+"}");//返回结果给Dart
//                            }
//
//                            @Override
//                            public void onFailure() {
//                                result.success("{\"success\": false}");//返回结果给Dart
//                            }
//
//                            @Override
//                            public void onCancel() {
//                                result.success("{\"success\": true, \"code\":\"0001\"}");//返回结果给Dart
//                            }
//
//                            @Override
//                            public void onOtherLogin() {
//                                result.success("{\"success\": true, \"code\":\"0002\"}");//返回结果给Dart
//                            }
//                        });
                            break;
                        case "getAliyunDeviceId":
//                        result.success(Params.aliyunDeviceId = PushServiceFactory.getCloudPushService().getDeviceId());//返回结果给Dart
                            break;
                        case "getAppName":
                            result.success(flutterActivity.getString(R.string.main_app_name));//返回结果给Dart
                            break;
                        case "getBrand":
                            result.success(Utility.getBrand());//返回结果给Dart
                            break;
                        case "hideAliyunStatusBar":
                            new Thread(new Runnable() {

                                @Override
                                public void run() {
                                    try {
                                        LocalNotificationManager.getInstance().hideNotificationFinal();
                                    } catch (Exception e) {
                                        System.out.println(e);
                                    }
                                }
                            }).start();

                            break;
                        case "initPushNotification": //同意协议后初始化推送
                                LocalNotificationManager.getInstance().init(this);
//                            try {
//                                Utility.initCrashHandler(flutterActivity);
//                            } catch (Exception e) {
//
//                            }
                            result.success(true);//返回结果给Dart
                            break;
                        case "cancelPushCounterNotification": //取消计时
                            new Thread(new Runnable() {

                                @Override
                                public void run() {
                                    try {
                                        String id = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("id");
                                        LocalNotificationManager.getInstance().cancelNotificationWithId(Integer.parseInt(id));
                                        LocalNotificationManager.getInstance().cancelAlarm(Integer.parseInt(id));
                                    } catch (Exception e) {
                                        Log.e("error", e.toString());
                                    }
                                }
                            }).start();

//                        Utility.initPushNotification(flutterActivity);
//                        result.success(true);//返回结果给Dart
                            break;
                        case "openSetting":
                            Utility.openSetting(flutterActivity);
                            break;
                        case "isNotificationOn":
                            result.success(Utility.areNotificationsEnabled(flutterActivity));//返回结果给Dart
                            break;
//                    case "isNotificationEnabled": //关闭所有推送
//                        boolean isNotificationEnabled = Utility.isNotificationEnabled();
//                        result.success("{\"success\": " + isNotificationEnabled + ", \"code\":\"0001\"}");//返回结果给Dart
//                        break;
                        case "cancelAllPendingNotification": //关闭所有推送
                            new Thread(new Runnable() {

                                @Override
                                public void run() {
                                    try {
                                        LocalNotificationManager.getInstance().cancelAllAlarm();
                                    } catch (Exception e) {
                                        Log.e("error", e.toString());
                                    }
                                }
                            }).start();
//                        ArrayList list2 = (ArrayList) call.arguments;
//                        for(int i = 0; i < list2.size(); i++) {
//                            String textPushNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("content");
//                            String titlePushNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("title");
//                            String summaryText = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("summaryText");
//                            long when = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(i)).get("when");
//                            String _id = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("id");
//                            LocalNotificationManager.getInstance().showCounterNotificationFinalWithWhenTimeStamp(when * 1000, Integer.parseInt(_id), titlePushNotification, textPushNotification, summaryText);
//                            LocalNotificationManager.getInstance().cancelAlarm(Integer.parseInt(_id));
//                        }
                            result.success("{\"success\": true, \"code\":\"0001\"}");//返回结果给Dart
                            break;
//                        LocalNotificationManager.getInstance().cancelAllAlarm();
//                    adb shell dumpsys alarm 可以查看所有alarm
                        case "pushListNotificationWithWhen": //用于技术
                            new Thread(new Runnable() {

                                @Override
                                public void run() {
                                    try {
                                        LocalNotificationManager.getInstance().cancelAllAlarm();
                                        ArrayList list = (ArrayList) call.arguments;
                                        for (int i = 0; i < list.size(); i++) {
                                            String textPushNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("content");
                                            String titlePushNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("title");
                                            String summaryText = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("summaryText");
                                            long when = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(i)).get("when");
                                            String _id = ((HashMap<String, String>) ((ArrayList) call.arguments).get(i)).get("id");
//                            String subId = _id.length() > 10 ? _id.substring(0, 10) : _id;
                                            LocalNotificationManager.getInstance().showCounterNotificationFinalWithWhenTimeStamp(when * 1000, Integer.parseInt(_id), titlePushNotification, textPushNotification, summaryText);
                                        }
                                    } catch (Exception e) {
                                        Log.e("error", e.toString());
                                    }
                                }
                            }).start();
                            break;
                        case "pushNotificationWithWhen": //用于技术
                            new Thread(new Runnable() {

                                @Override
                                public void run() {
                                    try {
                                        String textPushNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("content");
                                        String titlePushNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");
                                        String summaryText = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("summaryText");
                                        long when = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(0)).get("when");
                                        String _id = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("id");
//                        String subId = _id.length() > 10 ? _id.substring(0, 10) : _id;
                                        LocalNotificationManager.getInstance().showCounterNotificationFinalWithWhenTimeStamp(when * 1000, Integer.parseInt(_id), titlePushNotification, textPushNotification, summaryText);
                                    } catch (Exception e) {
                                        Log.e("error", e.toString());
                                    }
                                }
                            }).start();

                            break;
                        case "pushCounterNotification":
//                        String textPushCounterNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("text");
//                        String titlePushCounterNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");
////                        String actionPushCounterNotification = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("action");
//                        String _id2 = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("id");
//
//                        String extendsParams = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("extendsParams");
//                        JSONObject jsonObject = JSON.parseObject(extendsParams);
//
//                        boolean shouldShowRedFocusStatusCounterNotification = jsonObject.getBoolean("shouldShowRedFocusStatus");
//                        int statusCounterNotification = jsonObject.getInteger("status");
//                        boolean shouldShowRedFocus = jsonObject.getBoolean("shouldShowRedFocusStatus");
//                        int delay = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(0)).get("delay");
//                        CounterStatusModel counterStatusModelCounterNotification = new CounterStatusModel(titlePushCounterNotification, textPushCounterNotification, statusCounterNotification, shouldShowRedFocusStatusCounterNotification, delay);
//                        LocalNotificationManager.getInstance().showCounterNotificationFinalWithDelay(counterStatusModelCounterNotification, delay, Integer.parseInt(_id2));
                            break;
                        default:
                            new Thread(new Runnable() {

                                @Override
                                public void run() {
                                    try {
                                        String text = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("text");
                                        String title = ((HashMap<String, String>) ((ArrayList) call.arguments).get(0)).get("title");
                                        int status = ((HashMap<String, Integer>) ((ArrayList) call.arguments).get(0)).get("status");
                                        boolean shouldShowRedFocusStatus = ((HashMap<String, Boolean>) ((ArrayList) call.arguments).get(0)).get("shouldShowRedFocusStatus");
                                        CounterStatusModel counterStatusModel = new CounterStatusModel(title, text, status, shouldShowRedFocusStatus);
                                        Log.e("tag", result.toString());
                                        //下拉推送
                                        LocalNotificationManager.getInstance().showNotificationFinal(counterStatusModel);
                                        //桌面应用
                                        Intent intentBroadCast = new Intent(flutterActivity, MyAppWidgetProvider.class);
                                        intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                                        intentBroadCast.putExtra(CONSTANTS.BROADCAST_KEY, counterStatusModel);
                                        flutterActivity.getActivity().sendBroadcast(intentBroadCast);
                                    } catch (Exception e) {
                                        System.out.println(e);
                                    }
                                }
                            }).start();


//
                    }
                } catch (Exception e) {

                }
            }
        });
    }

    public void settingResult(int resultCode) {
        //延迟两秒跳转
        new Handler().postDelayed(new Runnable() {

            @Override
            public void run() {
                //argument不能放布尔类型
                methodChannel.invokeMethod("settingResult", null);
            }
        }, 500);
//        new Handler().postDelayed(new Runnable(){
//            @Override
//            public void run() {
//                methodChannel.invokeMethod("settingResult", resultCode);
//            }
//        }, 100);

    }


    public void getAliyunDeviceId() {
        methodChannel.invokeMethod("getAliyunDeviceId", Params.aliyunDeviceId);
    }


    public void handleStatusBarStartBtn() {
        methodChannel.invokeMethod("handleStatusBarStartBtn", null);
    }

    public void handleStatusBarPauseBtn() {
        methodChannel.invokeMethod("handleStatusBarPauseBtn", null);
    }

    public void handleStatusBarStopBtn() {
        methodChannel.invokeMethod("handleStatusBarStopBtn", null);
    }

    public void handleStatusBarDoneBtn() {
        methodChannel.invokeMethod("handleStatusBarDoneBtn", null);
    }


}