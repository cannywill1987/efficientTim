package com.timespeed.time_hello.util;

import android.app.NotificationChannel;

//import com.mob.MobSDK;

import io.flutter.embedding.android.FlutterActivity;

//import com.mob.secverify.PreVerifyCallback;
//import com.mob.secverify.ResultCallback;
//import com.mob.secverify.SecVerify;
//import com.mob.secverify.VerifyResultCallback;
//import com.mob.secverify.common.exception.VerifyException;
//import com.mob.secverify.datatype.VerifyResult;
import com.timespeed.time_hello.customInterface.OnLoginListener;
import com.timespeed.time_hello.customInterface.OnPreLoginListener;


//import com.mob.Consts;
//import com.mob.MobSDK;
//import io.flutter.embedding.android.FlutterActivity;
//
//import com.mob.confs.sharesdk.ShareSDKConfig;
//import com.mob.confs.sharesdk.ShareSDKDependency;

//import com.mob.secverify.SecVerify;



public class ShareSdkManager {
//    static ShareSdkManager mNotificationManager;
//    private FlutterActivity flutterActivity;
//    NotificationChannel notificationChannel = null;
//
//    public static synchronized ShareSdkManager getInstance() {
//        if (mNotificationManager == null) {
//            mNotificationManager = new ShareSdkManager();
//        }
//        return mNotificationManager;
//    }
//
//    //隐私授权结果
//    public void submitPolicyGrantResult(boolean grantResult) {
//        MobSDK.submitPolicyGrantResult(grantResult);
//    }
//
//    public void init(FlutterActivity flutterActivity) {
//        MobSDK.init(flutterActivity);
//        this.flutterActivity = flutterActivity;
//    }
//
//    public void wechatMobLogin() {
//        MobSDK.submitPolicyGrantResult(true);
////        SecVerify.
//    }
//
//    void preVerify(OnPreLoginListener callback) {
//        // 建议提前调用预登录接口，可以加快免密登录过程，提高用户的体验。
//        SecVerify.preVerify(new PreVerifyCallback() {
//            @Override
//            public void onComplete(Void data) {
//                // TODO处理成功的结果
//                if (callback != null) {
//                    callback.onComplete("");
//                }
//            }
//            @Override
//            public void onFailure(VerifyException e) {
//                // TODO处理失败的结果
//                // 获取错误码
//                if (callback != null) {
//                    callback.onFailure(e.getCode() + ":" + e.getMessage());
//                }
//            }
//        });
//    }
//
//    void verify(OnLoginListener onLoginListener) {
//        // 建议提前调用预登录接口，可以加快免密登录过程，提高用户的体验。
//        SecVerify.verify(new VerifyResultCallback() {
//            @Override
//            public void initCallback(VerifyCallCallback callback) {
//                callback.onCancel(new CancelCallback() {
//                    @Override
//                    public void handle() {
////                        content.setText("User cancel grant");
//                        onLoginListener.onCancel();
//                    }
//                });
//                callback.onOtherLogin(new OtherLoginCallback() {
//                    @Override
//                    public void handle() {
////                        content.setText("User request other login");
//                        onLoginListener.onOtherLogin();
//                    }
//                });
//                callback.onComplete(new ResultCallback.CompleteCallback<VerifyResult>() {
//                    @Override
//                    public void handle(VerifyResult result) {
////                        content.setText(result.toJSONString());
////                        tokenToPhone(result);
//                        if (result != null) {
//                            onLoginListener.onComplete(result.toJSONString());
//                        }
//                    }
//                });
//                callback.onFailure(new ResultCallback.ErrorCallback() {
//                    @Override
//                    public void handle(VerifyException t) {
////                        showExceptionMsg(t);
//                        onLoginListener.onOtherLogin();
//                    }
//                });
//            }
//        });
//    }
//
//    void verify() {
//        SecVerify.verify(new VerifyCallback() {
//            @Override
//            public void onOtherLogin() {
//                // 用户点击“其他登录方式”，处理自己的逻辑
//            }
//            @Override
//            public void onUserCanceled() {
//                // 用户点击“关闭按钮”或“物理返回键”取消登录，处理自己的逻辑
//            }
//            @Override
//            public void onComplete(VerifyResult data) {
//                // 获取授权码成功，将token信息传给应用服务端，再由应用服务端进行登录验证，此功能需由开发者自行实现
//                // opToken
//                String opToken = verifyResult.getOpToken();
//                // token
//                String token = verifyResult.getToken();
//                // 运营商类型，[CMCC:中国移动，CUCC：中国联通，CTCC：中国电信]
//                String operator = verifyResult.getOperator();
//            }
//            @Override
//            public void onFailure(VerifyException e) {
//                //TODO处理失败的结果
//            }
//        });
//    }

}