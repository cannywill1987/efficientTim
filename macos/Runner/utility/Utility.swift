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
import EventKit
//import WechatOpenSDK

class Utility {
    @discardableResult
    static func runProcessAsAdministrator(scriptPath: String, withArguments arguments: [String], output: inout String?, errorDescription: inout String?) -> Bool {
        let allArgs = arguments.joined(separator: " ")
        let fullScript = "'\(scriptPath)' \(allArgs)"
        
        let script = "do shell script \"\(fullScript)\" with administrator privileges"
        
        if let appleScript = NSAppleScript(source: script) {
            var errorInfo: NSDictionary? = nil
            let eventResult = appleScript.executeAndReturnError(&errorInfo)
            
            // Check errorInfo
            if eventResult.stringValue == nil {
                // Describe common errors
                if let errorNumber = errorInfo?[NSAppleScript.errorNumber] as? NSNumber, errorNumber.intValue == -128 {
                    errorDescription = "The administrator password is required to do this."
                } else if let errorMessage = errorInfo?[NSAppleScript.errorMessage] as? String {
                    errorDescription = errorMessage
                }
                return false
            } else {
                // Set output to the AppleScript's output
                output = eventResult.stringValue
                return true
            }
        } else {
            errorDescription = "Failed to create AppleScript."
            return false
        }
    }
    
    static func scheduleShutdown(after seconds: Int) {
        var output: String?
        var errorDescription: String?
        let success = runProcessAsAdministrator(scriptPath: "/sbin/shutdown", withArguments: ["-h", "+\(seconds / 60)"], output: &output, errorDescription: &errorDescription)
        
        if success {
            print("Shutdown scheduled successfully!")
        } else {
            if let errorDescription = errorDescription {
                print("Error: \(errorDescription)")
            } else {
                print("Unknown error occurred.")
            }
        }
    }
    
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
    
    static func getMissionModelsFromList(list: NSArray) -> [MissionModel] {
        //        var arrayList:[String] = [];
        var listMissionModels:[MissionModel] = [];
        
        for item in list {
            let itemDict:NSDictionary = item as! NSDictionary;
            let objectId:String? = itemDict["_id"] as? String;
            let isDelayed:Bool = itemDict["isDelayed"] as! Bool;
            let isFinished:Bool = itemDict["isFinished"] as! Bool;
            let title:String = itemDict["title"] as! String;
            let background_url:String? = itemDict["background_url"] as? String;
            let end_time:Int = itemDict["end_time"] as! Int;
            let priorityStatus:Int? = itemDict["priorityStatus"] as? Int;
            let color:Int? = itemDict["color"] as? Int ?? 0xffff8800 - 0xff000000;
            let missionData = MissionModel(objectId: objectId,title: title, lunar: "", background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: isDelayed, color:color)
            listMissionModels.append(missionData);
        }
        return listMissionModels;
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
    
    
    static func formatTimestampToDateString(timestamp: Int) -> String {
        // 将 timestamp 从毫秒转换为秒
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        
        // 设置日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 将日期对象格式化为字符串
        return dateFormatter.string(from: date)
    }
    
    static func serializeRecurrenceRule(_ rule: EKRecurrenceRule) -> [String: Any] {
        var recurrenceDict: [String: Any] = [:]
        
        recurrenceDict["frequency"] = rule.frequency.rawValue // 日、周、月、年等
        recurrenceDict["interval"] = rule.interval // 间隔
        recurrenceDict["endDate"] = rule.recurrenceEnd?.endDate?.description ?? NSNull()
        
        if let daysOfTheWeek = rule.daysOfTheWeek {
            recurrenceDict["daysOfTheWeek"] = daysOfTheWeek.map { $0.dayOfTheWeek.rawValue }
        }
        if let daysOfTheMonth = rule.daysOfTheMonth {
            recurrenceDict["daysOfTheMonth"] = daysOfTheMonth
        }
        if let monthsOfTheYear = rule.monthsOfTheYear {
            recurrenceDict["monthsOfTheYear"] = monthsOfTheYear
        }
        if let setPositions = rule.setPositions {
            recurrenceDict["setPositions"] = setPositions
        }
        
        return recurrenceDict
    }
    
    static func serializeEvent(event: EKEvent) -> [String: Any] {
        var structuredLocationData: [String: Any] = [:]
        if let structuredLocation = event.structuredLocation {
            structuredLocationData = [
                "title": structuredLocation.title ?? NSNull(),
                "geoLocation": [
                    "latitude": structuredLocation.geoLocation?.coordinate.latitude,
                    "longitude": structuredLocation.geoLocation?.coordinate.longitude
                ],
                "radius": structuredLocation.radius
            ]
        }
        
        let recurrenceRule = event.recurrenceRules?.first
        var recurrenceData: [String: Any] = [:]
        if let rule = recurrenceRule {
            recurrenceData = serializeRecurrenceRule(rule)
        }
        
        return [
            "location": event.location ?? NSNull(),
            "structuredLocation": structuredLocationData,
            "startDate": event.startDate?.description ?? NSNull(),
            "endDate": event.endDate?.description ?? NSNull(),
            "allDay": event.isAllDay,
            //            "floating": event.isFloating,
            "recurrence": recurrenceData,
            //            "travelTime": event.travelTime ?? NSNull(),
            "startLocation": event.structuredLocation?.geoLocation?.description ?? NSNull()
        ]
    }
    
    static func serializeEventList(events: [EKEvent]) -> [[String: Any]] {
        return events.map { serializeEvent(event: $0) }
    }
    
    static func serializeReminder(reminder: EKReminder) -> [String: Any] {
        var reminderDict: [String: Any] = [:]
        
        // 开始时间 (毫秒时间戳)
        if let startDate = reminder.startDateComponents?.date {
            reminderDict["startDate"] = startDate.timeIntervalSince1970 * 1000 // 转换为毫秒
        } else {
            reminderDict["startDate"] = NSNull()
        }
        
        // 截止时间 (毫秒时间戳)
        if let dueDate = reminder.dueDateComponents?.date {
            reminderDict["dueDate"] = dueDate.timeIntervalSince1970 * 1000 // 转换为毫秒
        } else {
            reminderDict["dueDate"] = NSNull()
        }
        
        // 完成状态
        reminderDict["isCompleted"] = reminder.isCompleted
        reminderDict["completionDate"] = reminder.completionDate?.timeIntervalSince1970 ?? NSNull()
        
        // 优先级
        reminderDict["priority"] = reminder.priority
        
        // 标题和备注（继承自 EKCalendarItem）
        reminderDict["title"] = reminder.title ?? NSNull()
        reminderDict["notes"] = reminder.notes ?? NSNull()
        
        // 日历信息
        reminderDict["calendar"] = reminder.calendar?.title ?? NSNull()
        
        return reminderDict
    }
    
    static func serializeReminderList(reminders: [EKReminder]) -> [[String: Any]] {
        return reminders.map { serializeReminder(reminder: $0) }
    }

    static func serializeCustomEvent(customEvent: CustomEvent) -> [String: Any] {
        let event = customEvent.ekEvent
        var structuredLocationData: [String: Any] = [:]
        if let structuredLocation = event.structuredLocation {
            structuredLocationData = [
                "title": structuredLocation.title ?? NSNull(),
                "geoLocation": [
                    "latitude": structuredLocation.geoLocation?.coordinate.latitude,
                    "longitude": structuredLocation.geoLocation?.coordinate.longitude
                ],
                "radius": structuredLocation.radius
            ]
        }
        
        let recurrenceRule = event.recurrenceRules?.first
        var recurrenceData: [String: Any] = [:]
        if let rule = recurrenceRule {
            recurrenceData = serializeRecurrenceRule(rule)
        }
        
        return [
            "id": customEvent.id, // 添加唯一 ID
            "location": event.location ?? NSNull(),
            "structuredLocation": structuredLocationData,
            "startDate": event.startDate?.description ?? NSNull(),
            "endDate": event.endDate?.description ?? NSNull(),
            "allDay": event.isAllDay,
            "recurrence": recurrenceData,
        ]
    }

    static func serializeCustomEventList(customEvents: [CustomEvent]) -> [[String: Any]] {
        return customEvents.map { serializeCustomEvent(customEvent: $0) }
    }
    
    static func serializeCustomReminderList(customReminders: [CustomReminder]) -> [[String: Any]] {
        return customReminders.map { serializeCustomReminder(customReminder: $0) }
    }
    static func serializeCustomReminder(customReminder: CustomReminder) -> [String: Any] {
        let reminder = customReminder.ekReminder
        var reminderDict: [String: Any] = [:]
        
        // 添加唯一 ID
        reminderDict["id"] = customReminder.id
        
        // 开始时间 (毫秒时间戳)
        if let startDate = reminder.startDateComponents?.date {
            reminderDict["startDate"] = startDate.timeIntervalSince1970 * 1000 // 转换为毫秒
        } else {
            reminderDict["startDate"] = NSNull()
        }

        // 截止时间 (毫秒时间戳)
        if let dueDate = reminder.dueDateComponents?.date {
            reminderDict["dueDate"] = dueDate.timeIntervalSince1970 * 1000 // 转换为毫秒
        } else {
            reminderDict["dueDate"] = NSNull()
        }

        // 完成状态
        reminderDict["isCompleted"] = reminder.isCompleted
        reminderDict["completionDate"] = reminder.completionDate?.timeIntervalSince1970 ?? NSNull()

        // 优先级
        reminderDict["priority"] = reminder.priority

        // 标题和备注（继承自 EKCalendarItem）
        reminderDict["title"] = reminder.title ?? NSNull()
        reminderDict["notes"] = reminder.notes ?? NSNull()

        // 日历信息
        reminderDict["calendar"] = reminder.calendar?.title ?? NSNull()

        return reminderDict
    }
    
    static func convertEventsToCustomEvents(events: [EKEvent]) -> [CustomEvent] {
        return events.map { CustomEvent(from: $0) }
    }
    
    static func convertRemindersToCustomReminders(reminders: [EKReminder]) -> [CustomReminder] {
        return reminders.map { CustomReminder(from: $0) }
    }

}
