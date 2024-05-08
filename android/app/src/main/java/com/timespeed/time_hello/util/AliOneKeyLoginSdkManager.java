package com.timespeed.time_hello.util;

//import com.mob.MobSDK;

//import com.mob.secverify.PreVerifyCallback;
//import com.mob.secverify.ResultCallback;
//import com.mob.secverify.SecVerify;
//import com.mob.secverify.VerifyResultCallback;
//import com.mob.secverify.common.exception.VerifyException;
//import com.mob.secverify.datatype.VerifyResult;


//import com.mob.Consts;
//import com.mob.MobSDK;
import io.flutter.embedding.android.FlutterActivity;
//
//import com.mob.confs.sharesdk.ShareSDKConfig;
//import com.mob.confs.sharesdk.ShareSDKDependency;

//import com.mob.secverify.SecVerify;

//import android.content.Intent;
//import android.util.Log;
//import android.widget.Toast;
//
//import com.mobile.auth.gatewayauth.AuthUIConfig;
//import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
//import com.mobile.auth.gatewayauth.ResultCode;
//import com.mobile.auth.gatewayauth.TokenResultListener;
//import com.mobile.auth.gatewayauth.model.TokenRet;
//import com.timespeed.time_hello.Params.Params;
//
//import org.json.JSONObject;
//
//import java.util.UUID;
//
//import io.flutter.embedding.android.FlutterActivity;

public class AliOneKeyLoginSdkManager {
    static AliOneKeyLoginSdkManager mAliOneKeyLoginSdkManager;
//    private static final String TAG = AliOneKeyLoginSdkManager.class.getSimpleName();
//    private PhoneNumberAuthHelper mPhoneNumberAuthHelper;
//    private FlutterActivity flutterActivity;
//    NotificationChannel notificationChannel = null;
//
    public static synchronized AliOneKeyLoginSdkManager getInstance(FlutterActivity flutterActivity) {
        if (mAliOneKeyLoginSdkManager == null) {
            mAliOneKeyLoginSdkManager = new AliOneKeyLoginSdkManager();
//            mAliOneKeyLoginSdkManager.init();
        }
        return mAliOneKeyLoginSdkManager;
    }

//    public void init(FlutterActivity flutterActivity) {
////        sdkInit("9FAGcChOIXzmSegMVFgKHNUuymGdqCa9mHuoNPk63HoGwWyxZBLblYNOIQV1p4TGGCEoMP9r+cyyU3Z9KCW7I1HJNt6Bw1sBdRfVrnTmkZYWbFbshbfJ/unckBMcG/jRuhCQMxRSd95meVxi1UtmBGSZjjrdUfKnz2hQawXmJ2j6TByC5Lw7/XsamR/sqa5/b/QZ/EjTSLSYSV4avvUQmiwZeo+7F8GeyBQhlbpIu0FJvGDQH/cP0tg0Pooaz2UyCMZ1L1vyHIoZqx66JX7kruhJdZe0DzV1mVC6/+SATKqp2f0X9LDlcWSz7UUX5BQS");
////        this.flutterActivity = flutterActivity;
//
//    }

    public void sdkInit(String secretInfo) {
//        TokenResultListener mTokenResultListener = new TokenResultListener() {
//            @Override
//            public void onTokenSuccess(String s) {
////                hideLoadingDialog();
////                if(Params.isDebug){
//                    Log.e(TAG, "获取token成功：" + s);
////                }
//                TokenRet tokenRet = null;
//                try {
//                    tokenRet = TokenRet.fromJson(s);
//                    if (ResultCode.CODE_START_AUTHPAGE_SUCCESS.equals(tokenRet.getCode())) {
////                        if(Params.isDebug == true){
//                            Log.i(TAG, "唤起授权页成功：" + s);
////                        }
//                    }
//
//                    if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
////                        if(Params.isDebug == true){
//                            Log.i(TAG, "获取token成功：" + s);
////                        }
//                        getResultWithToken(tokenRet.getToken());
//                        mPhoneNumberAuthHelper.setAuthListener(null);
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//            }
//
//            @Override
//            public void onTokenFailed(String s) {
//                if(Params.isDebug == true){
//                    Log.e(TAG, "获取token失败：" + s);
//                }
////                hideLoadingDialog();
//                mPhoneNumberAuthHelper.hideLoginLoading();
//                TokenRet tokenRet = null;
//                try {
//                    tokenRet = TokenRet.fromJson(s);
//                    if (ResultCode.CODE_ERROR_USER_CANCEL.equals(tokenRet.getCode())) {
//                        //模拟的是必须登录 否则直接退出app的场景
//                        flutterActivity.finish();
//                    } else {
//
//                        Toast.makeText(flutterActivity, "一键登录失败切换到其他登录方式", Toast.LENGTH_SHORT).show();
////                        Intent pIntent = new Intent(OneKeyLoginActivity.this, MessageActivity.class);
////                        startActivityForResult(pIntent, 1002);
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//                mPhoneNumberAuthHelper.quitLoginPage();
//                mPhoneNumberAuthHelper.setAuthListener(null);
//            }
//        };
//        mPhoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(this, mTokenResultListener);
//        mPhoneNumberAuthHelper.getReporter().setLoggerEnable(true);
//        mPhoneNumberAuthHelper.setAuthSDKInfo(secretInfo);
    }

    public void getResultWithToken(final String token) {
//        ExecutorManager.run(new Runnable() {
//            @Override
//            public void run() {
//                final String result = getPhoneNumber(token);
//                flutterActivity.runOnUiThread(new Runnable() {
//                    @Override
//                    public void run() {
////                        mTvResult.setText("登陆成功：" + result);
////                        mTvResult.setMovementMethod(ScrollingMovementMethod.getInstance());
//                        mPhoneNumberAuthHelper.quitLoginPage();
//                    }
//                });
//            }
//        });
    }

    /**
     * 开发者自己app的服务端对接阿里号码认证，并提供接口给app调用
     * 1、调用app服务端接口将一键登录token发送过去
     * 2、app服务端拿到token调用阿里号码认证服务端换号接口，获取手机号
     * 3、app服务端拿到手机号帮用户完成注册以及登录的逻辑，返回账户信息给app
     * @return 账户信息
     */
    public static String getPhoneNumber(String token) {
        String result = "";
//        try {
//            //模拟网络请求
////            if(Params.isDebug == true){
//                Log.i(TAG, "一键登录换号：" + "token: " + token );
////            }
//            Thread.sleep(500);
//            JSONObject pJSONObject = new JSONObject();
//            pJSONObject.put("account", UUID.randomUUID().toString());
//            pJSONObject.put("phoneNumber", "***********");
//            pJSONObject.put("token", token);
//            result = pJSONObject.toString();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
        return result;
    }

}