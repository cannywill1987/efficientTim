package com.timespeed.time_hello.crashHandler;/*
 * Copyright 2000-2020 YGSoft.Inc All Rights Reserved.
 */

import java.lang.Thread.UncaughtExceptionHandler;
import java.util.Date;
import java.util.HashMap;

//import com.samoyed.credit.activity.base.ActivityManager;
//import com.samoyed.credit.bean.ApplicationLoginInfo;
//import com.samoyed.credit.log.Logger;
//import com.samoyed.credit.ui.widget.dialog.SimpleDiloag;
//import com.samoyed.credit.ui.widget.dialog.SimpleDiloag.DialogSimpleInterface;
//import com.samoyed.credit.util.EventCollection;
//import com.samoyed.credit.util.EventName;
//import com.tencent.tinker.lib.tinker.TinkerApplicationHelper;
//import com.tencent.tinker.lib.util.TinkerLog;
//import com.tencent.tinker.entry.ApplicationLike;
//import com.tencent.tinker.loader.shareutil.ShareConstants;
//import com.tencent.tinker.loader.shareutil.ShareTinkerInternals;
//import com.tendcloud.tenddata.TCAgent;
//import com.tinker.repoter.PatchTinkerReporter;
//import com.tinker.util.TinkerManager;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Looper;
import android.os.SystemClock;
import android.text.TextUtils;
import android.widget.Toast;

import com.timespeed.time_hello.log.Logger;

/**
 * 全局异常捕捉 .<br>
 *
 * @version 1.0.0 2012-9-3<br>
 * @see
 * @since JDK 1.4.2.6
 */
public class CrashHandler implements UncaughtExceptionHandler {

    //tinker
    private static final long QUICK_CRASH_ELAPSE = 10 * 1000;
    public static final int MAX_CRASH_COUNT = 3;

    /**
     * mLogger .
     */
    Logger mLogger = new Logger(TAG);
    /**
     * TAG .
     */
    private static final String TAG = "CrashHandler";

    /**
     * 最小错误时间 .
     */
    private static final long MINERRORTIME = 10000;

    /**
     * 如果短时间内,规定的错误重复出现的次数多少次,则关闭程序 .
     */
    private static final long EXITERRORCONT = 3;

    /**
     * ICrashHandle .
     */
    ICrashHandle crashHandle;

    /**
     * 单例 .
     */
    private static CrashHandler INSTANCE;

    /**
     * UncaughtExceptionHandler .
     */
    UncaughtExceptionHandler mUncaughtExceptionHandler;
    /**
     * 是否正在处理强制退出 .
     */
    boolean isShowExit = false;
    /**
     * 上下文 .
     */
    private Context mContext;

    /**
     * 上一次发生错误的事件,以免堆栅错误 .
     */
    private long lastErrorTime;

    /**
     * 错误信息 .
     */
    HashMap<String, ErrorInfo> errorInfo = new HashMap<String, ErrorInfo>();

    /**
     * CrashHandler . <br>
     */
    private CrashHandler() {
    }

    /**
     * 单例 . <br>
     *
     * @return CrashHandler
     */
    public static CrashHandler getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new CrashHandler();
        }
        return INSTANCE;
    }

    /**
     * 初始化 . <br>
     *
     * @param ctx         上下文
     * @param crashHandle ICrashHandle
     */
    public void init(final Context ctx, final ICrashHandle crashHandle) {
        mContext = ctx;
        this.crashHandle = crashHandle;
        mUncaughtExceptionHandler = Thread.getDefaultUncaughtExceptionHandler();
        Thread.setDefaultUncaughtExceptionHandler(this);
    }

    /**
     * {@inheritDoc}
     *
     * @see UncaughtExceptionHandler# uncaughtException(java.lang.Thread, java.lang.Throwable)
     */
    @Override
    public void uncaughtException(final Thread thread, final Throwable ex) {
        if (thread == Looper.getMainLooper().getThread()) { // 如果是UI的线程.则要消息循环
            //	crashHandle.handleException(thread, ex);
            handleException(thread, ex);
            while (true) {
                try { // 消息循环处理,以后的MAIN错误就会到catch下.
                    mLogger.warn("消息循环");
                    Looper.loop();
                } catch (Throwable e) {
                    mLogger.warn("第二处理");
                    // crashHandle.handleException(thread, ex);
                    handleException(thread, ex);
                }
            }
        } else {
            mLogger.warn("not UIThread");
            handleException(thread, ex);
        }
        //捕捉tinker异常
//        tinkerFastCrashProtect();
    }

    /**
     * 处理异常.可以是默认处理或者传到外部处理,但针对到有对话框进度条的弹出.该如何处理 . <br>
     *
     * @param thread Thread
     * @param ex     Throwable
     */
    private void handleException(final Thread thread, final Throwable ex) {
        if (isShowExit || !checkError(thread, ex)) {
            if (crashHandle != null) {
                mLogger.warn("外部进行处理");
                crashHandle.handleException(thread, ex);
            } else if (!isShowExit) {
                mLogger.warn("默认处理");
                Toast.makeText(mContext, "程序异常,请取消重试!", Toast.LENGTH_SHORT).show();
            }
        }
    }

    /**
     * 清理 . <br>
     */
    private void clearValue() {
        isShowExit = false;
        errorInfo.clear();
        lastErrorTime = 0;
    }

    /**
     * 检查是否重复出现的错误,然后进行处理 . <br>
     *
     * @param thread Thread
     * @param ex     Throwable
     * @return true, 进行退出
     */
    private boolean checkError(final Thread thread, final Throwable ex) {
        //已经测试 可以用
//		SmyException exception = new SmyException(ex.getMessage() + "  用户手机号" + ApplicationLoginInfo.getInstance(mContext).getMobilePhoneNumber() + "", ex);
//        TinkerLog.i("Tinker.CrashHandler", "error message:" + ex.getMessage());
        final long nowTime = new Date().getTime();
        final String newError = getErrorString(ex);
        if (!TextUtils.isEmpty(newError) && nowTime - lastErrorTime < MINERRORTIME) {
            // 如果频繁出现错误的时间,再进行错误的统计
            if (errorInfo.containsKey(newError)) {
                final ErrorInfo errorinfo = errorInfo.get(newError);
                if (nowTime - errorinfo.getLastErrorTime() < MINERRORTIME) {
                    errorinfo.setErrorCount(errorinfo.getErrorCount() + 1);
                    if (errorinfo.getErrorCount() >= EXITERRORCONT) {
                        // 如果错误短期重复出现多次
                        new Thread(new Runnable() {

                            @Override
                            public void run() {
                                showExitDialog();
                            }
                        }).start();
                        mLogger.error("错误重复错误,让用户选择关闭程序");
                        isShowExit = true;
                        return true;
                    }
                }
            } else {
                final ErrorInfo errorinfo = new ErrorInfo();
                errorinfo.setLastErrorTime(nowTime);
                errorInfo.put(newError, errorinfo);
            }
        } else {
            mLogger.error("sendSMS error");
            lastErrorTime = nowTime;
            errorInfo.clear();

//			if(!Params.isDebug){
//            TinkerLog.i("Tinker.CrashHandler", "context is null?:" + mContext.getApplicationContext());
//            //异常时,mContext.getApplicationContext()可能为空，会报错
//            if (mContext.getApplicationContext() != null) {
//                TCAgent.onError(mContext, ex);//主动上报错误
//            }
//            try {
//                String phone = ApplicationLoginInfo.getInstance(mContext).getMaskMobile();
//                EventCollection.onCollection(mContext, EventName.exception, EventName.exception, phone, phone + ":" + ex.getMessage());
//            } catch (NullPointerException e) {
//                e.printStackTrace();
//            }
//			}
        }
        lastErrorTime = nowTime;
        return false;
    }

    /**
     * 显示错误提示 . <br>
     */

    private void showExitDialog() {
        Looper.prepare();
//        SimpleDiloag.oKCancelDialog(ActivityManager.getInstance().currentActivity(), "程序中断", "程序因为出现错误中断,是否重启程序?",
//                "重启", "退出", new DialogSimpleInterface() {
//
//                    @Override
//                    public void buttonCallBack(final int type) {
//                        isShowExit = false;
//                        if (type == DialogSimpleInterface.OK) {
//                            clearValue();
//                            Intent k = mContext.getPackageManager()
//                                    .getLaunchIntentForPackage(mContext.getPackageName());
//                            k.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//                            mContext.startActivity(k);
//                        } else {
//                            exitProgress();
//                        }
//                    }
//                });
        Looper.loop();
    }

    /**
     * 退出进程 . <br>
     */
    private void exitProgress() {
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(0);
    }

    /**
     * 组装错误信息 . <br>
     *
     * @param ex Throwable
     * @return 错误信息
     */
    public static String getErrorString(final Throwable ex) {
        if (ex != null) {
            final StringBuilder sb = new StringBuilder();
            final int lenth = ex.getStackTrace().length;
            for (int k = 0; k < lenth; k++) {
                sb.append(ex.getStackTrace()[k].toString()).append("\r\n");
            }
            return sb.toString();
        }
        return null;
    }

    /**
     * if tinker is load, and it crash more than MAX_CRASH_COUNT, then we just clean patch.
     */
//    private boolean tinkerFastCrashProtect() {
//        ApplicationLike applicationLike = TinkerManager.getSmyTinkerApplicationLike();
//        if (applicationLike == null || applicationLike.getApplication() == null) {
//            return false;
//        }
//        if (!TinkerApplicationHelper.isTinkerLoadSuccess(applicationLike)) {
//            return false;
//        }
//        final long elapsedTime = SystemClock.elapsedRealtime() - applicationLike.getApplicationStartElapsedTime();
//        //this process may not install tinker, so we use TinkerApplicationHelper api
//        if (elapsedTime < QUICK_CRASH_ELAPSE) {
//            String currentVersion = TinkerApplicationHelper.getCurrentVersion(applicationLike);
//            if (ShareTinkerInternals.isNullOrNil(currentVersion)) {
//                return false;
//            }
//
//            SharedPreferences sp = applicationLike.getApplication().getSharedPreferences(ShareConstants.TINKER_SHARE_PREFERENCE_CONFIG, Context.MODE_MULTI_PROCESS);
//            int fastCrashCount = sp.getInt(currentVersion, 0) + 1;
//            if (fastCrashCount >= MAX_CRASH_COUNT) {
//                PatchTinkerReporter.onFastCrashProtect();
//                TinkerApplicationHelper.cleanPatch(applicationLike);
//                TinkerLog.e(TAG, "tinker has fast crash more than %d, we just clean patch!", fastCrashCount);
//                return true;
//            } else {
//                sp.edit().putInt(currentVersion, fastCrashCount).commit();
//                TinkerLog.e(TAG, "tinker has fast crash %d times", fastCrashCount);
//            }
//        }
//
//        return false;
//    }

    /**
     * 异常处理接口 .<br>
     *
     * @version 1.0.0 2013-3-26<br>
     * @see
     * @since JDK 1.4.2.6
     */
    public interface ICrashHandle {
        /**
         * 异常处理 . <br>
         *
         * @param thread Thread
         * @param ex     Throwable
         */
        void handleException(final Thread thread, final Throwable ex);
    }

    /**
     * 错误信息 .<br>
     *
     * @version 1.0.0 2013-1-22<br>
     * @see
     * @since JDK 1.4.2.6
     */
    class ErrorInfo {
        /**
         * 出现错误的次数 .
         */
        private int errorCount = 1;
        /**
         * 出现错误的上次时间 .
         */
        private long lastErrorTime;

        /**
         * 获取errorCount.
         *
         * @return the errorCount
         */
        public int getErrorCount() {
            return errorCount;
        }

        /**
         * 设置 errorCount.
         *
         * @param errorCount the errorCount to set
         */
        public void setErrorCount(final int errorCount) {
            this.errorCount = errorCount;
        }

        /**
         * 获取lastErrorTime.
         *
         * @return the lastErrorTime
         */
        public long getLastErrorTime() {
            return lastErrorTime;
        }

        /**
         * 设置 lastErrorTime.
         *
         * @param lastErrorTime the lastErrorTime to set
         */
        public void setLastErrorTime(final long lastErrorTime) {
            this.lastErrorTime = lastErrorTime;
        }

    }
}
