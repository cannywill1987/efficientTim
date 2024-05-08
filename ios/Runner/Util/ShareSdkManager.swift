//
//  ShareSdkManager.swift
//  Runner
//
//  Created by 林智彬 on 2022/12/28.
//

import Foundation
//import MOBFoundation
//import SecVerify
import Flutter


class ShareSdkManager{
    static let instance:ShareSdkManager = ShareSdkManager()
    var flutterViewController: FlutterViewController?;
    //    var customStatusBarWidget:CustomStatusBarWidget?
    //    var curCounterStatus: Int?
    //
    static func shareInstance(flutterViewController: FlutterViewController) -> ShareSdkManager {
        if (instance.flutterViewController == nil) {
            instance.flutterViewController = flutterViewController;
//            MobSDK.registerAppKey("37349d1054389", appSecret: "263a217e653718cfb65194d23e11dda1");
//            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            instance.channel = FlutterMethodChannel(name: "com.efficienttime.counter",
//                                                    binaryMessenger: flutterViewController!.binaryMessenger)
//            instance.channel?.setMethodCallHandler(instance.handleMethodChannel);
        }
        return instance;
    }
    
    init () {}
//
//    public func uploadPrivacyPermissionStatus() {
////        [MobSDK uploadPrivacyPermissionStatus:YES onResult:nil];
//        MobSDK.uploadPrivacyPermissionStatus(true);
//    }
//    
//    public func startPreLogin() {
//        SVSDKHyVerify.setDebug(false);
//        SVSDKHyVerify.preLogin();
//    }
//    
//    public func startLogin(viewController: UIViewController) {
//        SVSDKHyVerify.setDebug(false);
////        SVSDKHyVerify.setDelegate(self);
//        //1.创建一个ui配置对象
////        SVSDKHyUIConfigure
//        let uiConfigure:SVSDKHyUIConfigure = SVSDKHyUIConfigure();
//        //2.设置currentViewController，必传！请传入当前vc或视图顶层vc，可使用此vc调系统present测试是否可以present其他vc
//        uiConfigure.currentViewController = viewController;
//        
//        //3.可选。设置一些定制化属性。eg. 开发者手动控制关闭授权页
//        uiConfigure.manualDismiss = true;
//        uiConfigure.navBarHidden = true;
//        
////        uiConfigure.modalPresentationStyle = .formSheet;
////        uiConfigure.modalTransitionStyle = .crossDissolve;
//        
//        
////        SVSDKHyVerify.openAuthPage(withModel: uiConfigure) { [AnyHashable : Any]?, Error? in
////
////        } cancelAuthPageListener: { [AnyHashable : Any]?, Error? in
////
////        }
////
////        SVSDKHyVerify.openAuthPage(withModel: uiConfigure) { [AnyHashable : Any]?, Error? in
////
////        } cancelAuthPageListener: { [AnyHashable : Any]?, Error? in
////
////        }
//        
//    }
    
}

