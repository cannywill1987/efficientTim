package com.timespeed.time_hello.Params;

public class Params {

    /**
     * 正式版发布一定要设成false
     * 并且在androidmanifest 注意把jpush 的 key换成生产
     */
    public static final boolean isDebug = false;
    public static final String APP_ID = "wxb74e3f117aec1616";
    public static final String APP_ID_QQ = "1112263382";



    public static String mBaseUrl = "https://smyapp.smyfinancial.com:8443";//生产环境
    public static String mMemberBaseUrl = "https://member.smyfinancial.com:8443";//生产环境


    public static String mH5BaseUrl = "https://www.smyfinancial.com/"; //生产环境H5域名
    public static String mH5StaticUrl = "https://static.smyfinancial.com/"; //生产环境static页面域名

    public static String aliyunDeviceId = ""; //生产环境static页面域名

    public final static String ACTION_CLICK_PREV = "com.timespeed.time_hello.prev";
    public final static String ACTION_CLICK_NEXT = "com.timespeed.time_hello.next";

    public final static String ACTION_CLICK_PLAY = "com.timespeed.time_hello.play";
    public final static String ACTION_CLICK_STOP = "com.timespeed.time_hello.stop";

    public final static String ACTION_CLICK_PAUSE = "com.timespeed.time_hello.pause";

    public final static String ACTION_CLICK_FINISH = "com.timespeed.time_hello.finish";

    public final static String SHAREPREFRENCE_KEY_CUR_MY_CALENDAR_KEY = "SHAREPREFRENCE_KEY_CUR_MY_CALENDAR_KEY";

    public static String BROADCAST_SHOW_WECHAT_GROUP_FOCUS = "BROADCAST_SHOW_WECHAT_GROUP_FOCUS";
    public static String BROADCAST_FROM_WECHAT_SHARE_SUCCESS = "BROADCAST_FROM_WECHAT_SHARE_SUCCESS";
    public static String BROADCAST_FROM_WECHAT_SHARE_JS_SUCCESS = "BROADCAST_FROM_WECHAT_SHARE_JS_SUCCESS";
    public static String BROADCAST_FROM_WECHAT_HIDE_DIALOG = "BROADCAST_FROM_WECHAT_HIDE_DIALOG";
    public static String BROADCAST_UPDATE_SMS_DYNAMIC_CODE = "BROADCAST_UPDATE_SMS_DYNAMIC_CODE";

    public final static String UPDATE_COUNTER_STATUS_ACTION = "UpdateCounterStatusAction"; //aliyun推送过来更新 桌面widget

    public static boolean isServiceRunning = false;
    public static boolean isMainActivityDestroyed = false;

    public static String sharePreferenceEngineInited = "sharePreferenceEngineInited"; //是否初始化sharePreferenceEngine
}