import Cocoa
import FlutterMacOS
import UserNotifications
import Firebase
import StoreKit

@main
class AppDelegate: FlutterAppDelegate, NSUserNotificationCenterDelegate, UNUserNotificationCenterDelegate {
    
    var flutterViewController:FlutterViewController!;
    //状态栏
    var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength:Constant.widthStatusBar) //状态栏高度
    }()
    var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .transient
        return popover
    }()
    
    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
      return true
    }
    
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        //        NotificationCenter.default.addObserver(self, selector: #selector(initNotification(_:)), name:Notification.Name(Params.ACTION_HANDLE_NOTIFICATION_PERMISSION), object: nil)
        //        startLocalNotification();
        //请求推送权限
//        SKPaymentQueue.default().add(IAPManager.shared)

        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge, .provisional])
        { granted, error in
            if error != nil
            {
                print ("Request notifications permission Error");
            };
            if granted
            {
                //               self.allowNotifications = true ;
                print ("Notifications allowed");
            }
            else
            {
                //               self.allowNotifications = false ;
                print ("Notifications denied");
            };
        }
        //        if (UIDevice.CurrentDevice.CheckSystemVersion (10, 0)) {
        // Request notification permissions from the user
        //              UNUserNotificationCenter.current().requestAuthorization (UNAuthorizationOptions.Alert, (approved, err) => {
        //                  // Handle approval
        //              });
        //          }
        
        NSUserNotificationCenter.default.delegate = self ;
        
        NotificationCenter.default.addObserver(self, selector: #selector(initNotification(_:)), name:Notification.Name(Params.ACTION_HANDLE_NOTIFICATION_PERMISSION), object: nil)
        if FirebaseApp.app() == nil  {
            FirebaseApp.configure()
        }
        
        resetBadge()
//        incrementBadge()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        incrementBadge()
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        // 在这里处理通知被送达的事件
        print("Notification delivered: \(notification)")
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool
    {
        return true
    }
    
    
    //        let notification = NSNotification.Name(rawValue: "123")
    //        notification.title = "message"
    //        notification.informativeText = "I have a dream"
    //        notification.userInfo = ["messageId": 111];
    //        notification.deliveryDate = NSData(timeInterval: 10) as Date
    //        notification.deliveryRepeatInterval?.minute = 1
    //        UserNotification.default.delegate = self
    //        UserNotification.default.scheduleNotification(notification)
    
    //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "123") , object: self, userInfo: ["content": "123"]);
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSLog("application start applicationShouldTerminateAfterLastWindowClosed")
        return true
    }
    
    override func applicationWillTerminate(_ notification: Notification) {
        let statusBar = NSStatusBar.system
        statusBar.removeStatusItem(statusItem)
    }
    
//    func applicationDidBecomeActive(_ notification: Notification) {
//        resetBadge()
//    }
    
    
    //    app显示在前端有焦点时
    override func applicationDidBecomeActive(_ notification: Notification) {
        NSLog("application applicationDidBecomeActive")
//        resetBadge()
        resetBadge()
    }
    
    
    @objc func initNotification(_ notification: Notification) {
        //阿里云推送end
        if let userInfo = notification.userInfo {
            if let value = userInfo["key"] as? String {
                print("Received notification with value: \(value)")
            }
        }
        //ios10.0以后 推送的基本适配 start
        //        if #available(iOS 10.0, *){
        let notifiCenter = UNUserNotificationCenter.current()
        notifiCenter.delegate = self
        notifiCenter.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                notifiCenter.requestAuthorization(options: [.alert,.sound,.badge]) { (accepted, error) in
                    if accepted {
                        if !(error != nil){
                            print("注册成功了！")
                            NSApplication.shared.registerForRemoteNotifications()
                            
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
                    NSApplication.shared.registerForRemoteNotifications()
                }
                
            }else{
                
            }
        }
        
        
        //ios8.0以后
        //        }
        
    }
    
    @IBAction func menuBarClickClicked(_ sender: NSStatusBarButton) {
        let isRightClickEvent = NSApp.currentEvent?.isRightClick ?? false
        if isRightClickEvent == true {
            
        } else {
            
        }
    }
    
    //    必须要写在appdelegate 否则selector send to unknonw instance todo 不懂为啥
    @objc func handleStatusBarStartBtn(_ sender: NSStatusBarButton) {
        Utility.activeApp();
        //        let isRightClickEvent = NSApp.currentEvent?.isRightClick ?? false
        print("start");
        if #available(macOS 11.0, *) {
            MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarStartBtn", arguments: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleStatusBarPauseBtn(_ sender: NSStatusBarButton) {
        Utility.activeApp();
        print("pause");
        if #available(macOS 11.0, *) {
            MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarPauseBtn", arguments: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleStatusBarStopBtn(_ sender: NSStatusBarButton) {
        Utility.activeApp();
        print("stop")
        if #available(macOS 11.0, *) {
            MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarStopBtn", arguments: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleStatusBarDoneBtn(_ sender: NSStatusBarButton) {
        Utility.activeApp();
        print("done")
        if #available(macOS 11.0, *) {
            MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarDoneBtn", arguments: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("");
    }
    
    override func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Register deviceToken failed, error");
    }
    
    /**
                
     */
//    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
//        // 在这里处理通知被送达的事件
//        print("Notification delivered: \(notification)")
//        // Determine whether you should suppress the notification.
//        let suppress = myShouldSuppressNotification(request: request)
//
//        if suppress {
//            // Don't deliver the notification to the user.
//            contentHandler(UNNotificationContent())
//
//        } else {
//            // Deliver the notification.
//            guard let updatedContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
//                // This error should never occur.
//                fatalError("Unable to create a mutable copy of the content")
//            }
//
//            // Update the notification's content, such as decrypting the body, here.
//            contentHandler(updatedContent)
//        }
//    }
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//
//
//    }
    
    fileprivate func initNotification() {
        //阿里云推送end
        //ios10.0以后 推送的基本适配 start
        let notifiCenter = UNUserNotificationCenter.current()
        notifiCenter.delegate = self
        notifiCenter.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                notifiCenter.requestAuthorization(options: [.alert,.sound,.badge]) { (accepted, error) in
                    if accepted {
                        if !(error != nil){
                            print("注册成功了！")
                            NSApplication.shared.registerForRemoteNotifications()
                            
                        }
                    } else {
                        print("用户不允许消息通知。")
                        //                    self.initAliyunPush()
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                //用户已经拒绝推送通知
                //-- 弹出页面提示用户去显示
                print("denied");
            }else if (setting.authorizationStatus == .authorized){
                //已注册 已授权 --注册同志获取 token
                // 请求授权时异步进行的，这里需要在主线程进行通知的注册
                DispatchQueue.main.async {
                    NSApplication.shared.registerForRemoteNotifications()
                }
                
            }else{
                
            }
        }
        
        
        //            registerAPNs()
        
        //ios8.0以后
        
    }
    
    func incrementBadge() -> Int {
        var currentBadge = UserDefaults.standard.integer(forKey: Params.badgeKey)
        currentBadge += 1
        print("increatement \(currentBadge)")
        UserDefaults.standard.set(currentBadge, forKey: Params.badgeKey)
        NSApplication.shared.dockTile.badgeLabel = String(currentBadge)
        return currentBadge
    }
    
    func resetBadge() {
        UserDefaults.standard.set(0, forKey: Params.badgeKey)
        print("resetBadge")
        NSApplication.shared.dockTile.badgeLabel = nil
    }
    
}

