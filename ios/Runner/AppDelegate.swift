import UIKit
import Flutter
import UserNotifications
//import CloudPushSDK
import flutter_downloader
//import FirebaseCore
import Firebase

//
@main
@objc class AppDelegate: FlutterAppDelegate, WXApiDelegate{
    let badgeKey = "badgeKey"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //ios10.0以后 推送的基本适配 end todo 下面这个不能删除
        GeneratedPluginRegistrant.register(with: self)
        //flutter downloader插件需要注册 否则闪屏页就出问题
        FlutterDownloaderPlugin.setPluginRegistrantCallback { registry in
            if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
                FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
            }
        }
        //        FirebaseApp.configure()
        MethodChannelManager.shareInstance(flutterViewController: self.window.rootViewController as? FlutterViewController);
        NotificationCenter.default.addObserver(self, selector: #selector(initNotification(_:)), name:Notification.Name(Params.ACTION_HANDLE_NOTIFICATION_PERMISSION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleActionButtonClick(notification:)), name: NSNotification.Name("ACTION_BTN_CLICK"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initBtnClickNotification(_:)), name:Notification.Name("ACTION_BTN_CLICK"), object: nil)
        
        if FirebaseApp.app() == nil  {
            FirebaseApp.configure()
        }
        //        initNotification();
        initAliyunPush();
        //        Params.deviceId = CloudPushSDK.getDeviceId();
        //        Params.deviceId = CloudPushSDK.getDeviceId();
        
        let wxApi = WXApi.registerApp("wxb74e3f117aec1616", universalLink: "https://www.timerbell.com/app/")
        
        resetBadge()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        //给flutter
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationDidFinishLaunching(application: UIApplication) {
        if #available(iOS 14.0, *) {
            NotificationManager.shared.requestAuthorization()
        } else {
            // Fallback on earlier versions
        }
    }

    
    func application(_application:UIApplication, continue userActivity:NSUserActivity, restorationHandler:@escaping([UIUserActivityRestoring]?) ->Void) ->Bool{
        return true
    }
    
    //    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //
    //          return WXApi.handleOpen(url, delegate: self)
    //      }
    
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: SendMessageToWXResp.self) {
            if resp.errCode == WXSuccess.rawValue{
                print("分享成功")
            }else if resp.errCode == WXErrCodeCommon.rawValue {
                print("分享失败：普通错误类型")
            }else if resp.errCode == WXErrCodeUserCancel.rawValue {
                print("分享失败：用户点击取消并返回")
            }else if resp.errCode == WXErrCodeSentFail.rawValue {
                print("分享失败：发送失败")
            }else if resp.errCode == WXErrCodeAuthDeny.rawValue {
                print("分享失败：授权失败")
            }else if resp.errCode == WXErrCodeUnsupport.rawValue {
                print("分享失败：微信不支持")
            }
        }
        
    }
    
    @objc func handleActionButtonClick(notification: Notification) {
        if let userInfo = notification.userInfo, let action = userInfo["action"] as? String {
            switch action {
            case "handleStatusBarPauseBtn":
                // 处理暂停按钮点击
                break
            case "handleStatusBarStartBtn":
                // 处理开始按钮点击
                break
            case "handleStatusBarStopBtn":
                // 处理停止按钮点击
                break
            case "handleStatusBarDoneBtn":
                // 处理完成按钮点击
                break
            default:
                break
            }
        }
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        // 在这里处理应用程序即将被终止的情况
        if #available(iOS 16.1, *) {
            LiveActivityManager.shareInstance().stopActivity()
        } else {
            // Fallback on earlier versions
        };
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        // 在这里处理应用程序进入后台的情况
        if #available(iOS 16.1, *) {
            let activity = LiveActivityManager.shareInstance().activity
            print("applicationDidEnterBackground");
        } else {
            // Fallback on earlier versions
        };
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        // 在这里处理应用程序即将进入前台的情况
        if #available(iOS 16.1, *) {
            let attributes = LiveActivityManager.shareInstance().activity?.attributes
            MethodChannelManager.shareInstance(flutterViewController: nil).channel?.invokeMethod("pushToPage", arguments: ["objectId": attributes?.objectId, "lastStartTime": attributes?.currentTimeStamp, "counterStatusEnum": attributes?.counterStatusEnum, "time": attributes?.time])
            print("applicationDidEnterBackground");
        } else {
            // Fallback on earlier versions
        };
        resetBadge()
    }
    
    //    //重写openURL
    //    override func  application(_ app:  UIApplication , open url:  URL ,
    //                               options: [ UIApplication.OpenURLOptionsKey  :  Any ] = [:]) ->  Bool  {
    //
    //    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let isSuc = WXApi.handleOpen(url, delegate: self)
        let urlKey: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        
        //        print("isSuc=\(isSuc)")
        if urlKey == "com.tencent.mqq" {
            // QQ 的回调
            return  TencentOAuth.handleOpen(url)
        }
        if isSuc == true{
            ////        BYCGUtil().showAlertView("微信启动失败")
            //        }
            return isSuc
        } else {
            return TencentOAuth.handleOpen(url)
        }
        
        
        //        return WXApi.handleOpen(url, delegate: self)
        
        
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    //    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //        return WXApi.handleOpen(url, delegate: self)
    //    }
    
    //    //重写openURL
    //    override func  application(_ app:  UIApplication , open url:  URL ,
    //                               options: [ UIApplication.OpenURLOptionsKey  :  Any ] = [:]) ->  Bool  {
    //        QQApiInterface .handleOpen(url, delegate:  self )
    //        return  TencentOAuth .handleOpen(url)
    //    }
    
    
    /**
     *  App处于前台时收到通知(iOS 10+)
     */
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let request:UNNotificationRequest = notification.request;
        let content: UNNotificationContent = request.content;
        let userInfo = notification.request.content.userInfo
//        if #available(iOS 14.0, *) {
//            NotificationManager.shared.requestNotificationCreate(
//                title: "userNotificationCenter Front",
//                subtitle: "userNotificationCenter Front"
//            )
//        } else {
//            // Fallback on earlier versions
//        }
        //        print("userInfo10:\(userInfo)")
        //        let title:String = content.title;
        //        let subtitle:String = content.body;
        //        let body = content.body;
        //        incrementBadge();
        //        let badge:Int? = content.badge?.intValue;
        //下面这段代码调用后 会执行上面的方法
        
        //        let extras:String = userInfo.values;
        completionHandler([.alert, .sound, .badge])
        //        let action: String = (userInfo["ACTION"] ?? "") as! String
        //        let activityName: String = (userInfo["ACTIVITY_NAME"] ?? "") as! String
        //
        //        if action == Params.START_MONITORING {
        //            if #available(iOS 16.0, *) {
        //                if #available(iOS 14.0, *) {
        //                    NotificationManager.shared.requestNotificationCreate(
        //                        title: "Activity Time",
        //                        subtitle: "\(action) \(activityName)"
        //                    )
        //                } else {
        //                    // Fallback on earlier versions
        //                }
        //                MyModel.shared.startMonitorByActivityName(activityName: activityName )
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        } else if action == Params.END_MONITORING {
        //            if #available(iOS 16.0, *) {
        //                if #available(iOS 14.0, *) {
        //                    NotificationManager.shared.requestNotificationCreate(
        //                        title: "Activity Time",
        //                        subtitle: "\(action) \(activityName)"
        //                    )
        //                } else {
        //                    // Fallback on earlier versions
        //                }
        //                MyModel.shared.stopMonitoring(activityName: activityName )
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }
        //        completionHandler();
    }
    
    
    
    // registerForRemoteNotifications后执行   获取deviceToken上传服务器
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        CloudPushSDK.registerDevice(deviceToken, withCallback: {
        //            (res: CloudPushCallbackResult?) -> Void in
        //            if (res!.success == true) {
        //                print("Register deviceToken success.");
        //            } else {
        //                print("Register deviceToken failed, error");
        //            }
        //        });
        print("deviceToken" + deviceToken.map { String(format: "%02hhx", $0) }.joined())
        let str =  NSString(data:deviceToken ,encoding: String.Encoding.utf8.rawValue);
        initAliyunPush()
    }
    //registerForRemoteNotifications 后执行 虚拟机不起作用
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Register deviceToken failed, error");
    }
    
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print("userInfo10 11111111111:\(userInfo)")
//        print("收到新消息Active\(userInfo)")
//        if #available(iOS 14.0, *) {
//            NotificationManager.shared.requestNotificationCreate(
//                title: "1111111111",
//                subtitle: "1111111111"
//            )
//        } else {
//            // Fallback on earlier versions
//        }
        completionHandler()

    }
    
    //iOS10新增：处理后台点击通知的代理方法
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        completionHandler()

        let userInfo = response.notification.request.content.userInfo
        NSLog( "Push registration success." );

        print("userInfo10 11111111111:\(userInfo)")
        print("收到新消息Active\(userInfo)")
//        if #available(iOS 14.0, *) {
//            NotificationManager.shared.requestNotificationCreate(
//                title: "1111111111",
//                subtitle: "1111111111"
//            )
//        } else {
//            // Fallback on earlier versions
//        }
////        if application.applicationState == UIApplication.State.active {
////            // 代表从前台接受消息app
////        }else{
////            // 代表从后台接受消息后进入app
////            //            UIApplication.shared.applicationIconBadgeNumber = 0
////        }
//        
//        if userInfo["ACTION" as NSObject] != nil && userInfo["ACTIVITY_NAME"  as NSObject] != nil {
//            
//            
//            let action: String = (userInfo["ACTION" as NSObject]) as! String
//            let activityName: String = (userInfo["ACTIVITY_NAME"  as NSObject]) as! String
//            if action == Params.START_MONITORING {
//                if #available(iOS 16.0, *) {
//                    if #available(iOS 14.0, *) {
//                        NotificationManager.shared.requestNotificationCreate(
//                            title: "Activity Time",
//                            subtitle: "\(action) \(activityName)"
//                        )
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                    MyModel.shared.startMonitorByActivityName(activityName: activityName )
//                } else {
//                    // Fallback on earlier versions
//                }
//            } else if action == Params.END_MONITORING {
//                if #available(iOS 16.0, *) {
//                    if #available(iOS 14.0, *) {
//                        NotificationManager.shared.requestNotificationCreate(
//                            title: "Activity Time",
//                            subtitle: "\(action) \(activityName)"
//                        )
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                    MyModel.shared.stopMonitoring(activityName: activityName )
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        }
//        incrementBadge()
        resetBadge()
    }
    
    
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(.newData)
    }
    
    //    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //        incrementBadge()
    //    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        resetBadge()
    }
    
    @objc func initBtnClickNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let value = userInfo["key"] as? String {
                print("Received notification with value: \(value)")
            }
        }
    }
    
    @objc func initNotification(_ notification: Notification) {
        //阿里云推送end
        if let userInfo = notification.userInfo {
            if let value = userInfo["key"] as? String {
                print("Received notification with value: \(value)")
            }
        }
        //ios10.0以后 推送的基本适配 start
        if #available(iOS 10.0, *){
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            notifiCenter.getNotificationSettings { (setting) in
                if setting.authorizationStatus == .notDetermined {
                    notifiCenter.requestAuthorization(options: [.alert,.sound,.badge]) { (accepted, error) in
                        if accepted {
                            if !(error != nil){
                                print("注册成功了！")
                                DispatchQueue.main.async {
                                    UIApplication.shared.registerForRemoteNotifications()
                                }
                                
                                
                            }
                        } else {
                            print("用户不允许消息通知。")
                            //                    self.initAliyunPush()
                        }
                    }
                } else if (setting.authorizationStatus == .denied){
                    //用户已经拒绝推送通知
                    //-- 弹出页面提示用户去显示
                    
                }else if (setting.authorizationStatus == .authorized){
                    //已注册 已授权 --注册同志获取 token
                    // 请求授权时异步进行的，这里需要在主线程进行通知的注册
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }else{
                    
                }
            }
            
            
            //            registerAPNs()
            
            //ios8.0以后
        }else if #available(iOS 8.0, *){
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType(rawValue: UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue), categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }else{    //其他
            
            let type = UIRemoteNotificationType(rawValue: UIRemoteNotificationType.alert.rawValue | UIRemoteNotificationType.badge.rawValue | UIRemoteNotificationType.sound.rawValue)
            UIApplication.shared.registerForRemoteNotifications(matching: type)
        }
        
    }
    
    fileprivate func initAliyunPush() {
        //        阿里云推送配置start
        //闭包 通过In语句实现 即我们平常所说的回调
        //        let callbackHandler: CallbackHandler = {
        //            (res: CloudPushCallbackResult?) -> Void in
        //            if (res!.success == true) {
        //                Params.deviceId = CloudPushSDK.getDeviceId();
        //                print("Push SDK init success, deviceId: %@." + CloudPushSDK.getDeviceId());
        //            } else {
        //                //下面会造成崩溃
        //                //                Params.deviceId = CloudPushSDK.getDeviceId();
        //                //                print("Push SDK init fail, deviceId: %@." + CloudPushSDK.getDeviceId());
        //            }
        //        }
        //        //        CloudPushSDK.init();
        //        CloudPushSDK.asyncInit("333720527", appSecret: "17f888de1d31481d9dfc950659cd88b4",callback: callbackHandler)
        //        CloudPushSDK.autoInit(callbackHandler)
    }
    
    func incrementBadge() -> Int {
        var currentBadge = UserDefaults.standard.integer(forKey: badgeKey)
        currentBadge += 1
        UserDefaults.standard.set(currentBadge, forKey: badgeKey)
        UIApplication.shared.applicationIconBadgeNumber  = currentBadge
        return currentBadge
    }
    
    func resetBadge() {
        UserDefaults.standard.set(0, forKey: badgeKey)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //    func incrementBadge() -> Int {
    //        var currentBadge = UserDefaults.standard.integer(forKey: badgeKey)
    //        currentBadge += 1
    //        UserDefaults.standard.set(currentBadge, forKey: badgeKey)
    //        return currentBadge
    //    }
    //
    //    func resetBadge() {
    //        UserDefaults.standard.set(0, forKey: badgeKey)
    //    }
    
}
