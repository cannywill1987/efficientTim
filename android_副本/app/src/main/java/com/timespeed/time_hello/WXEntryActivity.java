package com.timespeed.time_hello;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

//import com.tencent.mm.opensdk.modelbase.BaseReq;
//import com.tencent.mm.opensdk.modelbase.BaseResp;
//import com.tencent.mm.opensdk.openapi.IWXAPI;
//import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
//import com.tencent.mm.opensdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.timespeed.time_hello.Params.Params;


public class WXEntryActivity extends Activity implements IWXAPIEventHandler {
	// IWXAPI 是第三方app和微信通信的openapi接口  
	private IWXAPI api;

	@Override  
	protected void onCreate(Bundle savedInstanceState) {  
		super.onCreate(savedInstanceState);

		//        setContentView(R.layout.activity_wechat);
		api = WXAPIFactory.createWXAPI(this, Params.APP_ID, false);
		api.handleIntent(getIntent(), this);  
	}  
	
	@Override  
	public void onReq(BaseReq arg0) {
	}  

	@Override  
	public void onResp(BaseResp resp) {
		switch (resp.errCode) {

		case BaseResp.ErrCode.ERR_OK:  
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_SHARE_SUCCESS));
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_HIDE_DIALOG));
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_SHARE_JS_SUCCESS));
//			Toast.makeText(getApplicationContext(), "分享成功", 2000).show();
			System.out.println("success");
			/*     Util.showWechatAddFocusRemindDialog(this);

        	final SimpleWechatRemindDialog simpleRemindDialog2 = new SimpleWechatRemindDialog(this);
    		simpleRemindDialog2.setTitle("关注微信公众号");
    		simpleRemindDialog2.setContent(getResources().getString(R.string.dialog_info));
    		simpleRemindDialog2.show();
    		EventCollection.onCollection(WXEntryActivity.this, EventName.MGM, EventName.D4_View, null, SharePopupWindow.mOrigin);
    		simpleRemindDialog2.setButtonOnClick(new SimpleWechatRemindDialog.ButtonOnClick() {

    			@Override
    			public void submitOnClick() {
    				// TODO Auto-generated method stub
    				boolean result = Util.jumpToWechat(WXEntryActivity.this);
    				if(result == true) {
    					simpleRemindDialog2.hide();
    				} else {
    					EventCollection.onCollection(WXEntryActivity.this, EventName.MGM, EventName.D4_OpenWeChat, null, SharePopupWindow.mOrigin);
    					Toast.makeText(WXEntryActivity.this, "请确认您的手机已经安装了微信", Toast.LENGTH_SHORT).show();
    				}
    				finish();
    			}

    			@Override
    			public void cancelOnClic() {
    				// TODO Auto-generated method stub
    				finish();
    			}
    		});*/
			this.finish();
			//分享成功  
			break;  
		case BaseResp.ErrCode.ERR_USER_CANCEL:  
			//分享取消  
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_HIDE_DIALOG));
//			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_SHARE_JS_SUCCESS));
//			Toast.makeText(getApplicationContext(), "分享取消", 2000).show();
			System.out.println("ERR_USER_CANCEL");
			this.finish();
			break;  
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_HIDE_DIALOG));
//			Toast.makeText(getApplicationContext(), "授信被拒绝", 2000).show();
			System.out.println("ERR_AUTH_DENIED");
			this.finish();
			//分享拒绝  
			break;  
		case BaseResp.ErrCode.ERR_UNSUPPORT:
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_HIDE_DIALOG));
//			Toast.makeText(getApplicationContext(), "分享成功不支持", 2000).show();
			System.out.println("ERR_AUTH_DENIED");
			this.finish();
			break;
		default:
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_SHARE_SUCCESS));
			sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_HIDE_DIALOG));
			//        	sendBroadcast(new Intent(Params.BROADCAST_FROM_WECHAT_SHARE_SUCCESS));
//			Toast.makeText(getApplicationContext(), "未知错误", 2000).show();
			System.out.println("ERR_AUTH_DENIED");
			this.finish();
			break;
		}  

	}  
	
	

}