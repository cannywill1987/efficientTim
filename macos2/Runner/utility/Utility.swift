//
//  Utility.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/29.
//
import Cocoa
import Foundation
import UserNotifications
import StoreKit
//import WechatOpenSDK

class Utility {

    static func requestReview() {
        DispatchQueue.main.async {
             SKStoreReviewController.requestReview()
         }
    }
    
    static func getMissionModelTitle(array: NSArray) -> [String] {
        var arrayList:[String] = [];
        for item in array {
            let itemDict:NSDictionary = item as! NSDictionary;
            arrayList.append(itemDict["title"] as! String);
//            arrayList.append(itemDict["title"]);
//            arrayList.add(itemDict["title"]);
        }
        return arrayList;
    }
    
    static func isNotificationEnabled(cb: @escaping (_ result:Bool)->()) -> Void {
        let center = UNUserNotificationCenter.current()
        //        var isEnabled = false
        center.getNotificationSettings { settings in
            //            isEnabled = settings.authorizationStatus == .authorized
            cb(settings.authorizationStatus == .authorized)
        }
        //        return isEnabled
    }
    
    @available(iOS 10.0, *)
    static func cancelAllPendingNotification() {
        let queue = DispatchQueue(label: "cancelAllPendingNotification", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications();
        };
    }
    
    static func pushNotificationWithWhen(when: Int, title: String, body: String, userInfo: Any, action: String) {
        let queue = DispatchQueue(label: "pushNotificationWithWhen", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            //        let startNotificationTime: Int = getCurrentTimeStampBySeconds() + delay;
            let date:Date = getDateFromTimeStamp(timeStamp: when.description);
            //        let com = Calendar.current.dateComponents(in: TimeZone.current, from: date)
            let com = getDateComponentFromDate(date: date);
            showLocalNotification(title: title, body: body, userInfo: userInfo, year: com.year!, month: com.month!, day: com.day!, hour: com.hour!, minute: com.minute!, second: com.second!, action: action);
        };
        
    }
    
    static func showLocalNotificationWithDelay(delay: Int, title: String, body: String, userInfo: Any, action: String) {
        let startNotificationTime: Int = getCurrentTimeStampBySeconds() + delay;
        let date:Date = getDateFromTimeStamp(timeStamp: startNotificationTime.description);
        //        let com = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        let com = getDateComponentFromDate(date: date);
        let queue = DispatchQueue(label: "showLocalNotificationWithDelay", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            showLocalNotification(title: title, body: body, userInfo: userInfo, year: com.year!, month: com.month!, day: com.day!, hour: com.hour!, minute: com.minute!, second: com.second!, action: action);
        };
        
    }
    
    static func cancelNotificationWithAction(action: String) {
        let queue = DispatchQueue(label: "cancelNotificationWithAction", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [action])
        };
    }
    
    static func cancelAllNotification() {
        
    }
    
    @available(iOS 10.0, *)
    static func showLocalNotification(title: String, body: String, userInfo: Any, year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, action: String) {
        let queue = DispatchQueue(label: "showLocalNotification", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            //设置推送内容
            let content = UNMutableNotificationContent()
            content.title = title;
            content.body = body;
            //        content.informativeText = body ;
            content.summaryArgument = title;
            content.userInfo = userInfo as! [AnyHashable : Any];
            content.sound = UNNotificationSound.default
            content.badge = 1;
            if #available(macOS 12.0, *) {
                content.relevanceScore = 1
            } //0到1之间 决定app 在Notification列表显示的优先级
            // 定义触发的时间组合
            var matchingDate = DateComponents()
            matchingDate.year = year;
            matchingDate.month = month;
            matchingDate.day = day;
            matchingDate.hour = hour;
            matchingDate.minute = minute;
            matchingDate.second = second;
            //        print("11111111111: year:\(matchingDate.year) month:\(matchingDate.month) day:\(matchingDate.day) hour:\(matchingDate.hour) minute:\(matchingDate.minute) seconds:\(matchingDate.second)")
            //设置通知触发器
            let trigger =  UNCalendarNotificationTrigger.init(dateMatching: matchingDate, repeats: false)
            //设置请求标识符
            let requestIdentifier = action
            //设置一个通知请求
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            //
            //将通知请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    //                   VVLog("Time Interval Notification scheduled: \(requestIdentifier)")
                } else {
                    //                   VV Log("通知添加成功")
                }
            }
        };
    }
    
    static func initStatusBarMenu(appDelegate: AppDelegate) -> CustomStatusBarWidget {
        let storyboard = NSStoryboard(name: "MainStoryboard", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier:"MainWindowController") as? NSWindowController
        
        let contentViewController = windowController?.contentViewController
        appDelegate.popover.contentViewController = contentViewController
        
        let btn = appDelegate.statusItem.button
        let customStatusBarWidget:CustomStatusBarWidget = CustomStatusBarWidget.init(frame: NSMakeRect(0, 0, Constant.widthStatusBar, 110))
        btn?.action = #selector(appDelegate.menuBarClickClicked(_:))
        btn?.sendAction(on: [.leftMouseDown, .rightMouseDown])
        btn?.addSubview(customStatusBarWidget)
        appDelegate.statusItem.menu = Utility.getStatusBarMenus(counterStatusEnum: CounterStatusEnum.none)
        //        appDelegate.statusItem.menu.autoenablesItems = true;
        return customStatusBarWidget;
    }
    
    
    /*根据状态显示不同的右键菜单栏*/
    static func getStatusBarMenus(counterStatusEnum: CounterStatusEnum?)-> NSMenu {
        let menu = NSMenu()
        switch counterStatusEnum! {
        case .focusing:
            menu.addItem(NSMenuItem.separator())
            menu.addItem(getPauseMenuItem())
            break
        case .pausingFucusing:
            menu.addItem(NSMenuItem.separator())
            menu.addItem(getStartMenuItem())
            menu.addItem(NSMenuItem.separator())
            menu.addItem(getStopMenuItem())
            break
        case .relaxing:
            menu.addItem(NSMenuItem.separator())
            menu.addItem(getDoneMenuItem())
            break
        case .waitingToFocus:
            menu.addItem(NSMenuItem.separator())
            menu.addItem(getStartMenuItem())
            break
        case .waitingToStartRelaxing:
            menu.addItem(NSMenuItem.separator())
            menu.addItem(getStartMenuItem())
            break
        case .pausingRelaixing:
            break
        case .none:
            break
        }
        //        let menuItem = NSMenuItem(title: "Start", action: #selector (AppDelegate.statusItemClicked(_:)),keyEquivalent: "");
        //        menuItem.target = self
        //        menu.autoenablesItems = true;
        //        menu.addItem(menuItem)
        
        
        menu.addItem(NSMenuItem.separator())
        //         menu.addItem(NSMenuItem(title: "Quit", action: #selector (NSApplication.activate(flag:true)),keyEquivalent: "q"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector (NSApplication.terminate(_:)),keyEquivalent: "q"))
        return menu
    }
    
    static func activeApp() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    static func getStartMenuItem() -> NSMenuItem{
        //        let function = MethodChannelManager.shareInstance(flutterViewController: nil).handleStatusBarStartBtn(payload: nil);
        //        let shift = NSEvent.ModifierFlags.shift;
        //        let cmd = NSEvent.ModifierFlags.command;
        //        let cmd = NSEvent.ModifierFlags.Element.;
        
        //        NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
        //                        switch event.charactersIgnoringModifiers! {
        //                        case "x":
        //                            if NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self) { return true }
        //                        case "c":
        //                            if NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self) { return true }
        //                        case "v":
        //                            if NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self) { return true }
        //                        case "z":
        //                            if NSApp.sendAction(Selector(("undo:")), to: nil, from: self) { return true }
        //                        case "a":
        //                            if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self) { return true }
        //                        default:
        //                            break
        //                        }
        //                    }
        
        let commandShiftKey = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue
        
        let menuItem =  NSMenuItem(title:"Start", action: #selector (AppDelegate.handleStatusBarStartBtn(_:)), keyEquivalent: "r")
        menuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.shift]
        //        menu.target = MethodChannelManager.shareInstance(flutterViewController: nil);
        menuItem.isEnabled = true;
        return menuItem;
    }
    
    
    static func getStopMenuItem() -> NSMenuItem{
        let menuItem = NSMenuItem(title:"Stop", action: #selector(AppDelegate.handleStatusBarStopBtn(_:)), keyEquivalent:"s")
        menuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.shift]
        menuItem.isEnabled = true;
        return menuItem;
    }
    
    static func getPauseMenuItem() -> NSMenuItem{
        let menuItem = NSMenuItem(title:"Pause", action: #selector(AppDelegate.handleStatusBarPauseBtn(_:)), keyEquivalent:"p")
        menuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.shift]
        menuItem.isEnabled = true;
        return menuItem;
    }
    
    static func getDoneMenuItem() -> NSMenuItem{
        let menuItem = NSMenuItem(title:"Done", action: #selector(AppDelegate.handleStatusBarDoneBtn(_:)), keyEquivalent:"d")
        menuItem.keyEquivalentModifierMask = [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.shift]
        menuItem.isEnabled = true;
        return menuItem;
    }
    
    @IBAction func statusItemClicked(_ sender: NSStatusBarButton) {
        print("111111");
        //        let isRightClickEvent = NSApp.currentEvent?.isRightClick ?? false
    }
    
    /**Date生成dateComponents 才能有 year month day hour minute seconds**/
    static func getDateComponentFromDate(date: Date) -> DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: date);
    }
    
    /**得到当前秒单位时间戳**/
    static  func getCurrentTimeStampBySeconds() -> Int{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp;
    }
    
    /**
     *时间戳得到date
     */
    static  func getDateFromTimeStamp(timeStamp:String) ->Date {
        let interval:TimeInterval = TimeInterval.init(timeStamp)!
        return Date(timeIntervalSince1970: interval)
    }
    
    /**得到当前毫秒时间戳**/
    static  func getCurrentTimeStampByMilliSeconds() -> CLongLong{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond;
    }
    
    /**跨组件推送 类似eventbus通过
     NotificationCenter.default.addObserver显示 参考 https://www.youtube.com/watch?v=DM3LDLG3Cnk
     */
    static func postNotification(action: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: action) , object: self, userInfo: ["content": "123"]);
    }
    
    
    
}
