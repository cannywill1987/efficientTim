package com.timespeed.time_hello.util;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;

import android.app.Activity;
import android.app.AppOpsManager;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import io.flutter.embedding.android.FlutterActivity;
//import com.alibaba.sdk.android.push.CloudPushService;
//import com.alibaba.sdk.android.push.CommonCallback;
//import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.fastjson.JSONObject;
import com.tencent.connect.share.QQShare;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;
import com.timespeed.time_hello.MainActivity;
import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.R;
import com.timespeed.time_hello.application.TimeApplication;
import com.timespeed.time_hello.customInterface.OnResultListener;
import com.timespeed.time_hello.enums.CounterStatusEnum2;
import com.timespeed.time_hello.model.CounterStatusModel;
import com.timespeed.time_hello.widgets.MyAppWidgetProvider;
import com.timespeed.time_hello.widgets.MyCalendar2WidgetProvider;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService1;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService2;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService3;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService4;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService5;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService6;
import com.timespeed.time_hello.widgets.MyCalendarRemoteViewsService7;
//import com.timespeed.time_hello.widgets.MyCalendarWidgetProvider;
import com.timespeed.time_hello.widgets.MyClockInRemoteViewsService2;
import com.timespeed.time_hello.widgets.MyQuadrantRemoteViewsService1;
import com.timespeed.time_hello.widgets.MyQuadrantRemoteViewsService2;
import com.timespeed.time_hello.widgets.MyQuadrantRemoteViewsService3;
import com.timespeed.time_hello.widgets.MyQuadrantRemoteViewsService4;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import androidx.core.app.NotificationManagerCompat;

public class Utility {
//    public boolean isNotificationEnabled(Context context) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//            NotificationChannel channel = notificationManager.getNotificationChannel("chat");
//            return channel.getImportance() != NotificationManager.IMPORTANCE_NONE;
//        } else {
//            return NotificationManagerCompat.from(context).areNotificationsEnabled();
//        }
//    }

    public static String getBrand() {
        String name = Build.MANUFACTURER;
        return name;
//        switch (name) {
//            case "HUAWEI":
//                break;
//            case "vivo":
//                break;
//            case "OPPO":
//                break;
//            case "Coolpad":
//                break;
//            case "Meizu":
//                break;
//            case "Xiaomi":
//                break;
//            case "samsung":
//                break;
//            case "Sony":
//                break;
//            case "LG":
//                break;
//            default:
//                break;
//        }
    }

    public static void initPushNotification(Context context) {
//        ((TimeApplication)context.getApplicationContext()).registerAliyun();
    }

    public static void initCrashHandler(Context context) {
        ((TimeApplication) context.getApplicationContext()).initCrashHandler();
    }

    public static Tencent shareToQQ(final Activity activity, String title, String subtitle, String url, String mIconUrl, final boolean isOn, OnResultListener onResultListener) {
        Tencent.setIsPermissionGranted(true);
        Tencent mTencent = Tencent.createInstance(Params.APP_ID_QQ, activity.getApplicationContext());
//		if(SharePreferenceUtil.getInstance(mActivity).isShareDialogShowed()) {
//			SharePreferenceUtil.getInstance(mActivity).setShareDialogShowed();
        final Bundle params = new Bundle();
        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
        params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
        params.putString(QQShare.SHARE_TO_QQ_SUMMARY, subtitle);
        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL, url);
        if (TextUtils.isEmpty(mIconUrl)) {
            mIconUrl = "http://a.hiphotos.baidu.com/baike/w%3D268/sign=96292e68bf389b5038ffe754bd34e5f1/9358d109b3de9c8271a0cdf96a81800a18d843fa.jpg";
        }
        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, mIconUrl);
        params.putString(QQShare.SHARE_TO_QQ_APP_NAME, "时间管理局ToDo");
        mTencent.shareToQQ(activity, params, new IUiListener() {

            @Override
            public void onCancel() {
//                Logs.i("Util","share to QQ cancel");
                if (onResultListener != null) {
                    onResultListener.onCancel();
                }
            }

            @Override
            public void onWarning(int i) {

            }

            @Override
            public void onComplete(Object arg0) {
                // TODO Auto-generated method stub
                if (onResultListener != null) {
                    onResultListener.onComplete(arg0.toString());
                }
//                activity.sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_SHARE_JS_SUCCESS));
//                if (SharePreferenceUtil.getInstance(activity).isShareDialogShowed()) {
//                    SharePreferenceUtil.getInstance(activity).setShareDialogShowed();
//                    Util.showWechatAddFocusRemindDialog(activity);
//                }
            }

            @Override
            public void onError(UiError arg0) {
//                Logs.i("Util","share to QQ error: " + arg0.errorMessage + " error code: " + arg0.errorCode);
                if (onResultListener != null) {
                    onResultListener.onFailure("share to QQ error: " + arg0.errorMessage + " error code: " + arg0.errorCode);
                }
            }

        });
//		}
        return mTencent;
    }

    /**
     * toWhere 0 微信朋友 1 微信朋友圈
     *
     * @param activity
     * @param towhere
     * @param shareurl
     * @param title
     * @param description
     * @param iconUrl
     * @param imageData
     */
    public static void shareToWeChat(final Activity activity, final int towhere, final String shareurl, final String title, final String description, final String iconUrl, String imageData, OnResultListener onResultListener) {
        if (TextUtils.isEmpty(imageData) || towhere == 0) {
//            final LoadingDialog loadingDialog = new LoadingDialog(activity);
//            loadingDialog.show();
            AsyncTask<String, Integer, Bitmap> execute = new AsyncTask<String, Integer, Bitmap>() {

                @Override
                protected Bitmap doInBackground(String... params) {
                    // TODO Auto-generated method stub
                    InputStream inputStream;
                    try {
                        inputStream = new URL(params[0]).openStream();
                        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
                        return bitmap;
                    } catch (Exception e) {
                        e.printStackTrace();
                        return null;
                    }
                }

                @Override
                protected void onPostExecute(Bitmap result) {
                    // TODO Auto-generated method stub
                    super.onPostExecute(result);
                    final IWXAPI wxApi = WXAPIFactory.createWXAPI(activity, Params.APP_ID);
                    wxApi.registerApp(Params.APP_ID);
                    WXMediaMessage msg = null;
                    if (!TextUtils.isEmpty(shareurl)) {
                        WXWebpageObject urlObject = new WXWebpageObject();
                        urlObject.webpageUrl = shareurl;
                        msg = new WXMediaMessage(urlObject);
                        if (result == null) {
                            msg.thumbData = FormatTools.getInstance().Drawable2Bytes(activity.getResources().getDrawable(R.drawable.app_icon));
                        } else {
                            msg.thumbData = Bitmap2Bytes(result);
                        }
                    } else {
                        if (result == null) return;
                        WXImageObject imageObject = new WXImageObject(Bitmap2Bytes(result));
                        msg = new WXMediaMessage();
                        msg.mediaObject = imageObject;
                    }

                    msg.title = title;
                    msg.description = description;
                    SendMessageToWX.Req req = new SendMessageToWX.Req();
                    req.transaction = String.valueOf(System.currentTimeMillis());

                    req.message = msg;
                    if (towhere == 0) {
                        req.scene = SendMessageToWX.Req.WXSceneSession;//分享给好友
                    } else {
                        req.scene = SendMessageToWX.Req.WXSceneTimeline;//朋友圈
                    }
                    wxApi.sendReq(req);
                    try {
                        Handler mHandler = new Handler() {
                            @Override
                            public void handleMessage(Message msg) {
                                if (onResultListener != null) {
                                    onResultListener.onComplete(null);
                                }
//                                loadingDialog.hide();
                            }
                        };
                        mHandler.sendEmptyMessageDelayed(0, 0);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }.execute(iconUrl);
        } else {
            IWXAPI wxApi = WXAPIFactory.createWXAPI(activity, Params.APP_ID);
            Bitmap bitmap = base64ToBitmap(imageData);
            if (bitmap == null) return;
            byte[] bytesBitmap = FormatTools.getInstance().Bitmap2Bytes(bitmap);
            if (bytesBitmap == null) return;
            WXImageObject imageObject = new WXImageObject(bytesBitmap);
            WXMediaMessage msg = new WXMediaMessage();
            msg.mediaObject = imageObject;
            msg.title = title;
            msg.description = description;
            SendMessageToWX.Req req = new SendMessageToWX.Req();
            req.transaction = String.valueOf(System.currentTimeMillis());

            req.message = msg;
            if (towhere == 0) {
                req.scene = SendMessageToWX.Req.WXSceneSession;//分享给好友
            } else {
                req.scene = SendMessageToWX.Req.WXSceneTimeline;//朋友圈
            }
            wxApi.sendReq(req);
        }
    }

    public static byte[] Bitmap2Bytes(Bitmap bm) {
        Bitmap rbm;
        rbm = Bitmap.createScaledBitmap(bm, 150, 150, true);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        rbm.compress(Bitmap.CompressFormat.PNG, 100, baos);
        return baos.toByteArray();
    }

    public static Bitmap base64ToBitmap(String base64Data) {
        byte[] bytes = Base64.decode(base64Data, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    }

    public static void turnOnPushChannel(OnResultListener onResultListener) {
//        CloudPushService pushService = PushServiceFactory.getCloudPushService();
//        pushService.turnOnPushChannel(new CommonCallback() {
//            @Override
//            public void onSuccess(String s) {
//                onResultListener.onComplete(s);
//            }
//
//            @Override
//            public void onFailed(String s, String s1) {
//                onResultListener.onFailure();
//            }
//        });
    }

    public static void turnOffPushChannel(OnResultListener onResultListener) {
//        CloudPushService pushService = PushServiceFactory.getCloudPushService();
//        pushService.turnOffPushChannel(new CommonCallback() {
//            @Override
//            public void onSuccess(String s) {
//                onResultListener.onComplete(s);
//            }
//
//            @Override
//            public void onFailed(String s, String s1) {
//                onResultListener.onFailure();
//            }
//        });
    }

    public static void openSetting(FlutterActivity context) {
        Intent intent = new Intent();

        if (Build.VERSION.SDK_INT >= 26) {

            intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");

            intent.putExtra("android.provider.extra.APP_PACKAGE", context.getPackageName());

        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

            intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");

            intent.putExtra("app_package", context.getPackageName());

            intent.putExtra("app_uid", context.getApplicationInfo().uid);

        } else if (Build.VERSION.SDK_INT == Build.VERSION_CODES.KITKAT) {
            intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.addCategory(Intent.CATEGORY_DEFAULT);
            intent.setData(Uri.parse("package:" + context.getPackageName()));
        }

        context.startActivityForResult(intent, 3);
    }

    /**
     * Returns whether notifications from the calling package are not blocked.
     */
    public static boolean areNotificationsEnabled(Context mContext) {
        if (Build.VERSION.SDK_INT >= 24) {
            return NotificationManagerCompat.from(mContext).areNotificationsEnabled();
        } else if (Build.VERSION.SDK_INT >= 19) {
            AppOpsManager appOps =
                    (AppOpsManager) mContext.getSystemService(Context.APP_OPS_SERVICE);
            ApplicationInfo appInfo = mContext.getApplicationInfo();
            String pkg = mContext.getApplicationContext().getPackageName();
            int uid = appInfo.uid;
            try {
                Class<?> appOpsClass = Class.forName(AppOpsManager.class.getName());
                Method checkOpNoThrowMethod = appOpsClass.getMethod("CHECK_OP_NO_THROW", Integer.TYPE,
                        Integer.TYPE, String.class);
                Field opPostNotificationValue = appOpsClass.getDeclaredField("OP_POST_NOTIFICATION");
                int value = (int) opPostNotificationValue.get(Integer.class);
                return ((int) checkOpNoThrowMethod.invoke(appOps, value, uid, pkg)
                        == AppOpsManager.MODE_ALLOWED);
            } catch (ClassNotFoundException | NoSuchMethodException | NoSuchFieldException
                    | InvocationTargetException | IllegalAccessException | RuntimeException e) {
                return true;
            }
        } else {
            return true;
        }
    }

    public static void sendNoneStateBroadcastReceiver(Context context) {
        CounterStatusModel counterStatusModel = new CounterStatusModel("", "", 7, true);
//        Log.e("tag", result.toString());
        //下拉推送
//        LocalNotificationManager.getInstance().showNotificationFinal(counterStatusModel);
        //桌面应用
        Intent intentBroadCast = new Intent(context, MyAppWidgetProvider.class);
        intentBroadCast.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        intentBroadCast.putExtra(CONSTANTS.BROADCAST_KEY, counterStatusModel);
        context.sendBroadcast(intentBroadCast);
    }

    public static void cancelNotification(Context context, int id) {
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.cancel(id);
    }

    public static RemoteViews getMyNoteView(Context context, String key) {
        RemoteViews remoteViews = null;
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.my_note);
        try {
            HashMap hashMap = SharePreferenceUtil.getInstance(context).getHashMap(CONSTANTS.SHAREPREFRENCE_WQB_NOTE + key);
            String content = (String) hashMap.get("content");
            long color = (long) hashMap.get("color");
            Utility.setImageViewResources(R.id.imageView_note, remoteViews, color);
            remoteViews.setTextViewText(R.id.textView_note, content);
//        remoteViews.setColor(R.id.textView_note, (int) (color - 0xFF000000));
            remoteViews.setTextViewText(R.id.textView_note_number, context.getResources().getText(R.string.note_with_num) + key);
        } catch (Exception e) {

        }
        return remoteViews;
    }


    public static void setImageViewResources(int id, RemoteViews rv, long color) {
//        String color = (json).getLong("color") != null ? Long.toHexString((json).getLong("color")) : null;
//        boolean isFinished = (json).getBoolean("isFinished");
        int image_select, image_bg;

        color = color - 0xff000000l;

        if (color == 0xfff2b1) {
            image_select =  R.drawable.bg_fff2b1_corner ;
        } else if (color == 0xf7d889) {
            image_select =  R.drawable.bg_f7d889_corner ;
        } else if (color == 0xd9fcd1) {
            image_select =  R.drawable.bg_d9fcd1_corner ;
        } else if (color == 0xd1e8fc) {
            image_select =  R.drawable.bg_d1e8fc_corner ;
        } else if (color == 0xe1ccff) {
            image_select =  R.drawable.bg_e1ccff_corner ;
        } else if (color == 0xf8c7c7) {
            image_select =  R.drawable.bg_f8c7c7_corner ;
        } else if (color == 0xed7573) {
            image_select =  R.drawable.bg_ed7573_corner ;
        } else if (color == 0xf1a068) {
            image_select =  R.drawable.bg_f1a068_corner ;
        } else if (color == 0xf1bf6b) {
            image_select =  R.drawable.bg_f1bf6b_corner ;
        } else if (color == 0xc9e478) {
            image_select =  R.drawable.bg_c9e478_corner ;
        } else if (color == 0x7bd497) {
            image_select =  R.drawable.bg_7bd497_corner ;
        } else if (color == 0xff88ff) {
            image_select =  R.drawable.bg_ff88ff_corner ;
        } else if (color == 0x6083f6) {
            image_select = R.drawable.bg_6083f6_corner ;
        } else {
            image_select =  R.drawable.bg_fff2b1_corner ;
        }

//        if (image_select != 0) {
//            rv.setImageViewResource(id, image_select);
//        }
        rv.setImageViewResource(id, image_select);
    }

    /**
     * 正常推送显示的样式
     *
     * @param context
     * @return
     */
    public static RemoteViews getNormalRemoteViews(Context context) {
        RemoteViews remoteViews = null;
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.normal_notification_widget);
        Intent intent1 = new Intent(context, MyAppWidgetProvider.class);
        intent1.setAction(Params.ACTION_CLICK_PLAY);
        PendingIntent pendingIntent1 = PendingIntent.getBroadcast(context, 0, intent1, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.btn_play, pendingIntent1);
        //点击背景启动app
        Intent intentStartMainActivity = new Intent(context, MainActivity.class);
        PendingIntent pendingIntentMainActivity = PendingIntent.getActivity(context, 0, intentStartMainActivity, 0);
        remoteViews.setOnClickPendingIntent(R.id.relativelayout_container, pendingIntentMainActivity);
        return remoteViews;
    }

    // <!-- 一月到12月中文缩写 -->
    // <string name="january">一月</string>
    // <string name="february">二月</string>
    // <string name="march">三月</string>
    // <string name="april">四月</string>
    // <string name="may">五月</string>
    // <string name="june">六月</string>
    // <string name="july">七月</string>
    // <string name="august">八月</string>
    // <string name="september">九月</string>
    // <string name="october">十月</string>
    // <string name="november">十一月</string>
    // <string name="december">十二月</string>
    public static String getCurMonthOfToday(Context context, long time) {
        String month = "";
        switch (new SimpleDateFormat("MM").format(new Date(time))) {
            case "01":
                month = context.getResources().getString(R.string.january);
                break;
            case "02":
                month = context.getResources().getString(R.string.february);
                break;
            case "03":
                month = context.getResources().getString(R.string.march);
                break;
            case "04":
                month = context.getResources().getString(R.string.april);
                break;
            case "05":
                month = context.getResources().getString(R.string.may);
                break;
            case "06":
                month = context.getResources().getString(R.string.june);
                break;
            case "07":
                month = context.getResources().getString(R.string.july);
                break;
            case "08":
                month = context.getResources().getString(R.string.august);
                break;
            case "09":
                month = context.getResources().getString(R.string.september);
                break;
            case "10":
                month = context.getResources().getString(R.string.october);
                break;
            case "11":
                month = context.getResources().getString(R.string.november);
                break;
            case "12":
                month = context.getResources().getString(R.string.december);
                break;
        }
        return month;
    }

    public static RemoteViews getNormalNotificationRemoteView(Context context) {
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.counter_notification_widget_violet);
        remoteViews.setViewVisibility(R.id.btn_play, View.GONE);
        remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
        remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
        remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);

        //点击背景启动app
        Intent intentStartMainActivity = new Intent(context, MainActivity.class);
        PendingIntent pendingIntentMainActivity = PendingIntent.getActivity(context, 0, intentStartMainActivity, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.relativelayout_container, pendingIntentMainActivity);
//        //点击背景启动app
//        Intent intentStartMainActivity = new Intent(context, MainActivity.class);
//        PendingIntent pendingIntentMainActivity = PendingIntent.getActivity(context, 0, intentStartMainActivity, 0);
//        remoteViews.setOnClickPendingIntent(R.id.relativelayout_container, pendingIntentMainActivity);
        return remoteViews;
    }

    //根据毫秒时间戳得动从日到星期六的毫秒时间戳
    public static ArrayList<Long> getArrayListFromToday(long time) {
        ArrayList<Long> list = new ArrayList();
        try {
            //time得到今天是星期几
            Date date = new Date(time);
//time得到今天是星期几 返回整形
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
            // return dayOfWeek;

            // date.getWeekday();
//            int dayOfWeek = Integer.parseInt(new SimpleDateFormat("E").format(new Date(time)));
            //得到今天的毫秒时间戳
            long todayTime = time - (dayOfWeek - 1) * 24 * 60 * 60 * 1000;
            for (int i = 0; i < 7; i++) {
                //得到这周从星期天到星期六的毫秒时间戳放到list中
                long time1 = todayTime + i * 24 * 60 * 60 * 1000;
                list.add(time1);
            }
        } catch (Exception e) {

        }
        return list;
    }

    public static void setImageViewResources(RemoteViews rv, String color, boolean isFinished) {
//        String color = (json).getLong("color") != null ? Long.toHexString((json).getLong("color")) : null;
//        boolean isFinished = (json).getBoolean("isFinished");
        int image_select, image_bg;
    
        switch (color) {
            case "fffff2b1":
                image_select = isFinished ? R.drawable.bg_fff2b1_corner : 0;
                image_bg = R.drawable.bg_fff2b1_corner_light;
                break;
            case "fff7d889":
                image_select = isFinished ? R.drawable.bg_f7d889_corner : 0;
                image_bg = R.drawable.bg_f7d889_corner_light;
                break;
            case "ffd9fcd1":
                image_select = isFinished ? R.drawable.bg_d9fcd1_corner : 0;
                image_bg = R.drawable.bg_d9fcd1_corner_light;
                break;
            case "ffd1e8fc":
                image_select = isFinished ? R.drawable.bg_d1e8fc_corner : 0;
                image_bg = R.drawable.bg_d1e8fc_corner_light;
                break;
            case "ffe1ccff":
                image_select = isFinished ? R.drawable.bg_e1ccff_corner : 0;
                image_bg = R.drawable.bg_e1ccff_corner_light;
                break;
            case "fff8c7c7":
                image_select = isFinished ? R.drawable.bg_f8c7c7_corner : 0;
                image_bg = R.drawable.bg_f8c7c7_corner_light;
                break;
            case "ffed7573":
                image_select = isFinished ? R.drawable.bg_ed7573_corner : 0;
                image_bg = R.drawable.bg_ed7573_corner_light;
                break;
            case "fff1a068":
                image_select = isFinished ? R.drawable.bg_f1a068_corner : 0;
                image_bg = R.drawable.bg_f1a068_corner_light;
                break;
            case "fff1bf6b":
                image_select = isFinished ? R.drawable.bg_f1bf6b_corner : 0;
                image_bg = R.drawable.bg_f1bf6b_corner_light;
                break;
            case "ffc9e478":
                image_select = isFinished ? R.drawable.bg_c9e478_corner : 0;
                image_bg = R.drawable.bg_c9e478_corner_light;
                break;
            case "ff7bd497":
                image_select = isFinished ? R.drawable.bg_7bd497_corner : 0;
                image_bg = R.drawable.bg_7bd497_corner_light;
                break;
            case "ffff88ff":
                image_select = isFinished ? R.drawable.bg_ff88ff_corner : 0;
                image_bg = R.drawable.bg_ff88ff_corner_light;
                break;
            case "ff6083f6":
                image_select = isFinished ? R.drawable.bg_6083f6_corner : 0;
                image_bg = R.drawable.bg_6083f6_corner_light;
                break;
            default:
                image_select = isFinished ? R.drawable.bg_ff7800_corner : 0;
                image_bg = R.drawable.bg_ff7800_corner_light;
                break;
        }
    
        if (image_select != 0) {
            rv.setImageViewResource(R.id.image_select, image_select);
        }
        rv.setImageViewResource(R.id.image_bg, image_bg);
    }

    public static String getLunarString(ArrayList array1, long curTime) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String curDateString = sdf.format(new Date(curTime));
        for (int i = 0; i < array1.size(); i++) {
            JSONObject item = (JSONObject) array1.get(i);
            long time = item.getLong("time");
            String lunar = item.getString("lunar");
            Date date = new Date(time);
            String timestampDate = sdf.format(date);
            if (curDateString.equals(timestampDate)) {
                return lunar;
            }
        }
        return "";
    }

    public static RemoteViews getMyCalendarRemoteViews2(Context context, long time) {
        ArrayList<Long> listTimeStamp = Utility.getArrayListFromToday(time);
        String lunar = null;
        ArrayList array4 = SharePreferenceUtil.getInstance(context).getModelsArray(CONSTANTS.BROADCAST_MYCAlendar_MODELS);

        RemoteViews remoteViews = null;
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.my_calendar_mission);
        try {
            Intent intentPrev = new Intent(context, MyCalendar2WidgetProvider.class);
            intentPrev.setAction(Params.ACTION_CLICK_PREV);
            //根据毫秒时间戳time得到一个星期前时间戳
            long prevTime = time - 7 * 24 * 60 * 60 * 1000;
            intentPrev.putExtra("time", prevTime);
            PendingIntent pendingIntentPrev = PendingIntent.getBroadcast(context, new Random().nextInt(), intentPrev, PendingIntent.FLAG_MUTABLE);
            remoteViews.setOnClickPendingIntent(R.id.btn_prev, pendingIntentPrev);
            Intent intentNext = new Intent(context, MyCalendar2WidgetProvider.class);
            intentNext.setAction(Params.ACTION_CLICK_NEXT);
            //根据毫秒时间戳time得到一个星期前时间戳
            long nextTime = time + 7 * 24 * 60 * 60 * 1000;
            intentNext.putExtra("time", nextTime);
//            intentPrev.putExtra("time", );
            PendingIntent pendingIntentNext = PendingIntent.getBroadcast(context, new Random().nextInt(), intentNext, PendingIntent.FLAG_MUTABLE);
            remoteViews.setOnClickPendingIntent(R.id.btn_next, pendingIntentNext);


            Intent intent1 = new Intent(context, MyCalendarRemoteViewsService1.class);
            intent1.putExtra("random", new Random().nextInt());
            intent1.putExtra("time1", listTimeStamp.get(0));
            intent1.setData(Uri.parse(intent1.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview1, intent1);

            remoteViews.setTextViewText(R.id.textView_lunar1, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(0)));
            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar1, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar1, View.VISIBLE);
            }
            //根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date1, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(0))));
            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(0))))) {
                remoteViews.setTextColor(R.id.textView_date1, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar1, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title1, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date1, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar1, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title1, context.getResources().getColor(R.color.black_40));
            }

            Intent intent2 = new Intent(context, MyCalendarRemoteViewsService2.class);
            intent2.putExtra("random", new Random().nextInt());
            intent2.putExtra("time2", listTimeStamp.get(2));
            intent2.setData(Uri.parse(intent2.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview2, intent2);
            //根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date2, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(1))));

            remoteViews.setTextViewText(R.id.textView_lunar2, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(1)));
            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar2, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar2, View.VISIBLE);
            }


            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(1))))) {
                remoteViews.setTextColor(R.id.textView_date2, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar2, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title2, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date2, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar2, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title2, context.getResources().getColor(R.color.black_40));
            }

            remoteViews.setTextViewText(R.id.textView_lunar2, Utility.getLunarString(array4 ,listTimeStamp.get(1)));
            Intent intent3 = new Intent(context, MyCalendarRemoteViewsService3.class);
            intent3.putExtra("random", new Random().nextInt());
            intent3.putExtra("time3", listTimeStamp.get(2));
            intent3.setData(Uri.parse(intent3.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview3, intent3);
//根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date3, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(2))));
            remoteViews.setTextViewText(R.id.textView_lunar3, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(2)));

            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar3, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar3, View.VISIBLE);
            }

            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(2))))) {
                remoteViews.setTextColor(R.id.textView_date3, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar3, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title3, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date3, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title3, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar3, context.getResources().getColor(R.color.black_40));
            }


            //设置颜色

            Intent intent4 = new Intent(context, MyCalendarRemoteViewsService4.class);
            intent4.putExtra("random", new Random().nextInt());
            intent4.putExtra("time4", listTimeStamp.get(3));
            intent4.setData(Uri.parse(intent4.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview4, intent4);
            //根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date4, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(3))));
            remoteViews.setTextViewText(R.id.textView_lunar4, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(3)));

            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar4, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar4, View.VISIBLE);
            }

            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(3))))) {
                remoteViews.setTextColor(R.id.textView_date4, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title4, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar4, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date4, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title4, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar4, context.getResources().getColor(R.color.black_40));
            }


            Intent intent5 = new Intent(context, MyCalendarRemoteViewsService5.class);
            intent5.putExtra("random", new Random().nextInt());
            intent5.putExtra("time5", listTimeStamp.get(4));
            intent5.setData(Uri.parse(intent5.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview5, intent5);
            //根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date5, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(4))));
            remoteViews.setTextViewText(R.id.textView_lunar5, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(5)));

            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar5, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar5, View.VISIBLE);
            }

            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(4))))) {
                remoteViews.setTextColor(R.id.textView_date5, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title5, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar5, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date5, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title5, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar5, context.getResources().getColor(R.color.black_40));
            }


            Intent intent6 = new Intent(context, MyCalendarRemoteViewsService6.class);
            intent6.putExtra("random", new Random().nextInt());
            intent6.putExtra("time6", listTimeStamp.get(5));
            intent6.setData(Uri.parse(intent6.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview6, intent6);
            //根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date6, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(5))));
            remoteViews.setTextViewText(R.id.textView_lunar6, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(5)));

            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar6, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar6, View.VISIBLE);
            }

            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(5))))) {
                remoteViews.setTextColor(R.id.textView_date6, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title6, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar6, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date6, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title6, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar6, context.getResources().getColor(R.color.black_40));
            }

            Intent intent7 = new Intent(context, MyCalendarRemoteViewsService7.class);
            intent7.putExtra("random", new Random().nextInt());
            intent7.putExtra("time7", listTimeStamp.get(6));
            intent7.setData(Uri.parse(intent7.toUri(Intent.URI_INTENT_SCHEME)));
            remoteViews.setRemoteAdapter(R.id.listview7, intent7);
            remoteViews.setTextViewText(R.id.textView_lunar7, lunar = Utility.getLunarString(array4 ,listTimeStamp.get(6)));

            if(TextUtils.isEmpty(lunar) == true) {
                remoteViews.setViewVisibility(R.id.textView_lunar7, View.GONE);
            } else {
                remoteViews.setViewVisibility(R.id.textView_lunar7, View.VISIBLE);
            }

            //根据time得到dd
            remoteViews.setTextViewText(R.id.textView_date7, new SimpleDateFormat("dd").format(new Date(listTimeStamp.get(6))));
            //如果是今天 设置成蓝色
            if (new SimpleDateFormat("yyyyMMdd").format(new Date()).equals(new SimpleDateFormat("yyyyMMdd").format(new Date(listTimeStamp.get(6))))) {
                remoteViews.setTextColor(R.id.textView_date7, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_title7, context.getResources().getColor(R.color.blue));
                remoteViews.setTextColor(R.id.textView_lunar7, context.getResources().getColor(R.color.blue));
            } else {
                remoteViews.setTextColor(R.id.textView_date7, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_title7, context.getResources().getColor(R.color.black_40));
                remoteViews.setTextColor(R.id.textView_lunar7, context.getResources().getColor(R.color.black_40));
            }


            //得到今天的年 最后两位数
            remoteViews.setTextViewText(R.id.textview_year, new SimpleDateFormat("yy").format(new Date(time)));
            remoteViews.setTextViewText(R.id.textview_month, Utility.getCurMonthOfToday(context, time));
        } catch (Exception e) {
            Log.i("error", e.toString());
        }
        return remoteViews;

    }

    public static RemoteViews getClockInRemoteViews2(Context context) {
        ArrayList array4 = SharePreferenceUtil.getInstance(context).getPriorityArray(CONSTANTS.BROADCAST_DATA4);

        RemoteViews remoteViews = null;
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.listview_clockin2);

        Intent intent4 = new Intent(context, MyClockInRemoteViewsService2.class);
//        intent4.setAction(Intent.ACTION_CACHE_CLEAN);

//        intent4.setComponent(new ComponentName(context, MyClockIn2WidgetProvider.class));

        intent4.putParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1, array4);
        intent4.putExtra(CONSTANTS.BROADCAST_PRIORIY, 4);
        intent4.putExtra("random", new Random().nextInt());
        intent4.setData(Uri.parse(intent4.toUri(Intent.URI_INTENT_SCHEME)));
        remoteViews.setRemoteAdapter(R.id.listview4, intent4);
//        Intent intentStartMainActivity = new Intent(context, MainActivity.class);
//        PendingIntent pendingIntentMainActivity = PendingIntent.getActivity(context, 0, intentStartMainActivity, PendingIntent.FLAG_MUTABLE);
//        remoteViews.setOnClickPendingIntent(R.id.relativelayout_container, pendingIntentMainActivity);
        return remoteViews;
    }

    public static RemoteViews getQuadrantRemoteViews(Context context) {
        ArrayList array1 = SharePreferenceUtil.getInstance(context).getPriorityArray(CONSTANTS.BROADCAST_DATA1);
        ArrayList array2 = SharePreferenceUtil.getInstance(context).getPriorityArray(CONSTANTS.BROADCAST_DATA2);
        ArrayList array3 = SharePreferenceUtil.getInstance(context).getPriorityArray(CONSTANTS.BROADCAST_DATA3);
        ArrayList array4 = SharePreferenceUtil.getInstance(context).getPriorityArray(CONSTANTS.BROADCAST_DATA4);
        RemoteViews remoteViews = null;
        remoteViews = new RemoteViews(context.getPackageName(), R.layout.listview_quadrant);
//        remoteViews.getViewId(R.id.listview1);
        Intent intent1 = new Intent(context, MyQuadrantRemoteViewsService1.class);
        intent1.putParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1, array1);
        intent1.putExtra(CONSTANTS.BROADCAST_PRIORIY, 1);
        intent1.putExtra("random", new Random().nextInt());
        intent1.setData(Uri.parse(intent1.toUri(Intent.URI_INTENT_SCHEME)));

        Intent intent2 = new Intent(context, MyQuadrantRemoteViewsService2.class);
        intent2.putParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1, array2);
        intent2.putExtra(CONSTANTS.BROADCAST_PRIORIY, 2);
        intent2.putExtra("random", new Random().nextInt());
        intent2.setData(Uri.parse(intent2.toUri(Intent.URI_INTENT_SCHEME)));

        Intent intent3 = new Intent(context, MyQuadrantRemoteViewsService3.class);
        intent3.putParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1, array3);
        intent3.putExtra(CONSTANTS.BROADCAST_PRIORIY, 3);
        intent3.putExtra("random", new Random().nextInt());
        intent3.setData(Uri.parse(intent3.toUri(Intent.URI_INTENT_SCHEME)));

        Intent intent4 = new Intent(context, MyQuadrantRemoteViewsService4.class);
        intent4.putParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1, array4);
        intent4.putExtra(CONSTANTS.BROADCAST_PRIORIY, 4);
        intent4.putExtra("random", new Random().nextInt());
        intent4.setData(Uri.parse(intent4.toUri(Intent.URI_INTENT_SCHEME)));
        remoteViews.setRemoteAdapter(R.id.listview1, intent1);
        remoteViews.setRemoteAdapter(R.id.listview2, intent2);
        remoteViews.setRemoteAdapter(R.id.listview3, intent3);
        remoteViews.setRemoteAdapter(R.id.listview4, intent4);
        Intent intentStartMainActivity = new Intent(context, MainActivity.class);
        PendingIntent pendingIntentMainActivity = PendingIntent.getActivity(context, 0, intentStartMainActivity, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.relativelayout_container, pendingIntentMainActivity);
        return remoteViews;
    }


    public static RemoteViews getRemoteViews(Context context, CounterStatusModel counterStatusModel) {
        if (counterStatusModel == null) {
            counterStatusModel = new CounterStatusModel();
        }
        int counterStatusEnumIndex = counterStatusModel.getStatus();
        RemoteViews remoteViews = null;
        if (counterStatusModel.getShouldShowRedFocusStatus() == true) {
            remoteViews = new RemoteViews(context.getPackageName(), R.layout.counter_notification_widget);
        } else {
            remoteViews = new RemoteViews(context.getPackageName(), R.layout.counter_notification_widget_blue);
        }
        if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.focusing.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == false) {
//                try {
//                    context.startService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = true;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
////                try {
////                    context.startService(new Intent(context, BackgroundService.class));
////                    Params.isServiceRunning = true;
////                } catch (Exception e) {
////                    Log.e(CONSTANTS.LOG_TAG, e.toString());
////                }
//            }
            remoteViews.setViewVisibility(R.id.btn_play, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.VISIBLE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
        } else if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.pausingFucusing.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
            remoteViews.setViewVisibility(R.id.btn_play, View.VISIBLE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.VISIBLE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
        } else if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.relaxing.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == false) {
//                try {
//                    context.startService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = true;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
//            if (Params.isServiceRunning == false) {
//                try {
//                    context.startService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = true;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }

            remoteViews.setViewVisibility(R.id.btn_play, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.VISIBLE);
        } else if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.waitingToFocus.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == false) {
//                try {
//                    context.startService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = true;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
//            if (Params.isServiceRunning == false) {
//                try {
//                    context.startService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = true;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
            remoteViews.setViewVisibility(R.id.btn_play, View.VISIBLE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
        } else if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.waitingToStartRelaxing.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
            remoteViews.setViewVisibility(R.id.btn_play, View.VISIBLE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
        } else if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.pausingRelaixing.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            }
            remoteViews.setViewVisibility(R.id.btn_play, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
        } else if (Params.isMainActivityDestroyed == false && true == CounterStatusEnum2.none.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(counterStatusEnumIndex))) {
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
//            if (Params.isServiceRunning == true) {
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
            remoteViews.setViewVisibility(R.id.btn_play, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
//            }
        } else if (true == CounterStatusEnum2.finishActivity.equals(CounterStatusEnum2.getCounterStatusEnumFromIndex(7))) { //页面销毁还原widget
            Params.isMainActivityDestroyed = true; //需要加在这里 因为调用太频繁
//            try {
//                context.stopService(new Intent(context, BackgroundService.class));
//                Params.isServiceRunning = false;
//            } catch (Exception e) {
//                Log.e(CONSTANTS.LOG_TAG, e.toString());
//            }
//                Params.isMainActivityDestroyed = true; //需要加在这里 因为调用太频繁
//                try {
//                    context.stopService(new Intent(context, BackgroundService.class));
//                    Params.isServiceRunning = false;
//                } catch (Exception e) {
//                    Log.e(CONSTANTS.LOG_TAG, e.toString());
//                }
            remoteViews.setViewVisibility(R.id.btn_play, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_pause, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_stop, View.GONE);
            remoteViews.setViewVisibility(R.id.btn_finish, View.GONE);
        }
        if (getBrand() != "HUAWEI") {
            //huawei要显示app名称
            remoteViews.setViewVisibility(R.id.ll, View.GONE);
        }

        Intent intent1 = new Intent(context, MyAppWidgetProvider.class);
        intent1.setAction(Params.ACTION_CLICK_PLAY);
        PendingIntent pendingIntent1 = PendingIntent.getBroadcast(context, 0, intent1, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.btn_play, pendingIntent1);

        Intent intent2 = new Intent(context, MyAppWidgetProvider.class);
        intent2.setAction(Params.ACTION_CLICK_STOP);
        PendingIntent pendingIntent2 = PendingIntent.getBroadcast(context, 1, intent2, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.btn_stop, pendingIntent2);

        Intent intent3 = new Intent(context, MyAppWidgetProvider.class);
        intent3.setAction(Params.ACTION_CLICK_PAUSE);
        PendingIntent pendingIntent3 = PendingIntent.getBroadcast(context, 2, intent3, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.btn_pause, pendingIntent3);

        Intent intent4 = new Intent(context, MyAppWidgetProvider.class);
        intent4.setAction(Params.ACTION_CLICK_FINISH);
        PendingIntent pendingIntent4 = PendingIntent.getBroadcast(context, 3, intent4, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.btn_finish, pendingIntent4);
        //点击背景启动app
        Intent intentStartMainActivity = new Intent(context, MainActivity.class);
        PendingIntent pendingIntentMainActivity = PendingIntent.getActivity(context, 0, intentStartMainActivity, PendingIntent.FLAG_MUTABLE);
        remoteViews.setOnClickPendingIntent(R.id.relativelayout_container, pendingIntentMainActivity);

        if (!TextUtils.isEmpty(counterStatusModel.getTitle())) {
            remoteViews.setTextViewText(R.id.textview_title, counterStatusModel.getTitle());
        }
        if (!TextUtils.isEmpty(counterStatusModel.getText())) {
            remoteViews.setTextViewText(R.id.subtitle, counterStatusModel.getText());
        }

        return remoteViews;
    }


    /**
     * 获取apk签名
     */
    public static String getSignature(Activity activity) {
        StringBuffer signStr = new StringBuffer();
        Signature[] signs = getRawSignature(activity, activity.getPackageName());
        if (signs != null && signs.length > 0) {
            for (Signature sign : signs) {
                String signMd5 = getMessageDigest(sign.toByteArray());
                signStr.append(signMd5);
            }
        }
        return signStr.toString();
    }

    private static Signature[] getRawSignature(Context context, String packageName) {
        if (!TextUtils.isEmpty(packageName)) {
            PackageManager pkgMgr = context.getPackageManager();
            try {
                PackageInfo info = pkgMgr.getPackageInfo(packageName, PackageManager.GET_SIGNATURES);
                if (info != null) {
                    return info.signatures;
                }
            } catch (PackageManager.NameNotFoundException e) {
                return null;
            }
        }
        return null;
    }

    private static String getMessageDigest(byte[] buffer) {
        char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        try {
            MessageDigest mdTemp = MessageDigest.getInstance("MD5");
            mdTemp.update(buffer);
            byte[] md = mdTemp.digest();
            int j = md.length;
            char[] str = new char[j * 2];
            int k = 0;
            for (byte byte0 : md) {
                int k2 = k + 1;
                str[k] = hexDigits[(byte0 >>> 4) & 15];
                k = k2 + 1;
                str[k2] = hexDigits[byte0 & 15];
            }
            return new String(str);
        } catch (Exception e) {
            return "";
        }
    }
}

