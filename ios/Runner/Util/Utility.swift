//
//  Utility.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/29.
//

import Foundation
import UserNotifications
import SwiftUI
import CoreMedia
import StoreKit
//import FamilyControls
//import DeviceActivity
import FamilyControls
import DeviceActivity
import ManagedSettings
import EventKit


//@available(iOS 15.0, *)
//extension DeviceActivityName {
//    static let activity = Self("activity")
//    static let gaming = Self("gaming");
//    static let social = Self("social");
//}

class Utility {
    //    @available(iOS 16.0, *)
    //    static func limitUsageOfApp() {
    //        //5点到6点才允许社交app使用
    //        try? DeviceActivityCenter().startMonitoring(.activity, during: DeviceActivity.DeviceActivitySchedule(intervalStart: DateComponents(hour:17), intervalEnd: DateComponents(hour: 20), repeats: true));
    //    }
    
    /// - Parameters:
    ///   - urlString: 音乐文件的URL字符串
    ///   - completion: 完成回调，返回本地文件路径或错误
    //    ///   downloadMusicFile(from: "https://example.com/path/to/music.mp3") { result in
    //    switch result {
    //    case .success(let fileURL):
    //        print("文件保存在：\(fileURL)")
    //    case .failure(let error):
    //        print("下载错误：\(error)")
    //    }
    //}
    static func downloadMusicFile(from urlString: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // 尝试获取目标保存路径
                guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    completion(.failure(NSError(domain: "FileError", code: 1, userInfo: nil)))
                    return
                }
                
                let fileExtension = url.pathExtension
                let fileName = UUID().uuidString + (fileExtension.isEmpty ? "" : ".\(fileExtension)")
                let savedURL = documentsPath.appendingPathComponent(fileName)
                
                do {
                    // 如果目标路径已存在文件，先删除
                    if FileManager.default.fileExists(atPath: savedURL.path) {
                        try FileManager.default.removeItem(at: savedURL)
                    }
                    
                    // 将下载的文件移动到目标路径
                    try FileManager.default.moveItem(at: tempLocalUrl, to: savedURL)
                    completion(.success(savedURL))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "DownloadError", code: 2, userInfo: nil)))
            }
        }
        
        task.resume()
    }
    
    static func isTodayInWeekend(weekend: [Bool]) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // 注意: 在西方的日历系统中，周日是1，周一是2，以此类推，周六是7
        // 所以我们需要将其转换为数组的索引，周日是0，周一是1，以此类推，周六是6
        let index = (weekday - 1) % 7
        return weekend[index]
        //        func isTodayInWeekend(weekend: [Bool]) -> Bool {
        //            let calendar = Calendar.current
        //            let weekday = calendar.component(.weekday, from: Date())
        //            // 注意: 在西方的日历系统中，周日是1，周一是2，以此类推，周六是7
        //            // 所以我们需要将其转换为数组的索引，周日是0，周一是1，以此类推，周六是6
        //            let index = (weekday - 1) % 7
        //            return weekend[index]
        //        }
        //        let calendar = Calendar.current
        //        let weekday = calendar.component(.weekday, from: Date())
        //        // 注意: 在西方的日历系统中，周日是1，周一是2，以此类推，周六是7
        //        // 所以我们需要将其转换为数组的索引，周日是0，周一是1，以此类推，周六是6
        //        let index = (weekday + 5) % 7
        //        return weekend[index]
    }
    
    static func dateFromComponents(_ components: DateComponents) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
    }
    
    static func navigateToViewController(controller: UIViewController) {
        // 获取当前的顶层控制器
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // 创建一个TimelineViewController实例
            
            
            // 检查topController是否是UINavigationController
            if let navigationController = topController as? UINavigationController {
                // 在当前的顶层控制器上推送TimelineViewController
                navigationController.pushViewController(controller, animated: true)
            } else {
                print("Cannot push. Top controller is not a UINavigationController.")
            }
        }
    }
    
    static func getWeekdaysFromBooleans(_ days: [Bool]) -> String {
        guard days.count == 7 else {
            print("Error: Array should contain 7 elements.")
            return ""
        }
        
        let weekdays = ["Sun".localizable(), "Mon".localizable(), "Tue".localizable(), "Wed".localizable(), "Thu".localizable(), "Fri".localizable(), "Sat".localizable()]
        var result = [String]()
        
        for (index, value) in days.enumerated() {
            if value {
                result.append(weekdays[index])
            }
        }
        
        return result.joined(separator: ",")
    }
    static func dismissViewController(controller: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        controller.dismiss(animated: animated, completion: completion)
    }
    
    static func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @available(iOS 16.0, *)
    @available(iOS 16.0, *)
    static func requestAuthorization() async {
        let center = AuthorizationCenter.shared
        do {
            //child需要密码 individual个人使用
            try await center.requestAuthorization(for: .individual)
        } catch {
            print("Fetched err: \(error).")
        }
        _ = AuthorizationCenter.shared.$authorizationStatus
            .sink() {_ in
                switch AuthorizationCenter.shared.authorizationStatus {
                case .notDetermined:
                    print("not determined")
                case .denied:
                    print("denied")
                case .approved:
                    NotificationManager.shared.registerCategory()
                    print("approved")
                @unknown default:
                    break
                }
            }
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
    
    static func getHourAndMinuteString(from dateComponents: DateComponents) -> String {
        guard let hour = dateComponents.hour, let minute = dateComponents.minute else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let date = Calendar.current.date(from: dateComponents)
        return formatter.string(from: date ?? Date())
    }
    
    static func getHourAndMinute(from date: Date) -> (hour: Int, minute: Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return (hour, minute)
    }
    
    // 1 is Sunday, 2 is Monday, ..., 6 is Friday
    static func createDateComponents(startHour: Int, endHour: Int, weekdays: [Int]) -> [(start: DateComponents, end: DateComponents)] {
        var dateComponentsList = [(start: DateComponents, end: DateComponents)]()
        
        for weekday in weekdays {
            let startTime = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, hour: startHour, weekday: weekday)
            let endTime = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, hour: endHour, weekday: weekday)
            dateComponentsList.append((start: startTime, end: endTime))
        }
        
        return dateComponentsList
    }
    
    static func isMac() -> Bool {
#if targetEnvironment(macCatalyst)
        return true;
#else
        return false;
#endif
    }
    
    //    @available(iOS 16.0, *)
    //    static func requestAuthorization() async {
    //        let center = AuthorizationCenter.shared
    //        do {
    //            try await center.requestAuthorization(for: .child)
    //        } catch {}
    //    }
    
    //    @available(iOS 15.0, *)
    //    static func requestAuthorization() async {
    //        let center = AuthorizationCenter.shared
    //        do {
    ////            try await center.requestAuthorization(for: .individual)
    //            try await center.requestAuthorization(for: .child)
    //        } catch {}
    //
    //
    //
    ////        AuthorizationCenter.shared.requestAuthorization { result in
    ////            switch result {
    ////                case .success:
    ////                print("");
    ////                    //...
    ////                case .failure(let error):
    ////                print("");
    ////                   //...
    ////            }
    ////        }
    //    }
    
    static func shareToWechat(towhere: Int, shareurl: String, title: String, description: String, iconUrl: String, imageData: String) {
        //需要再associateLinks里添加
        //        let wxApi = WXApi.registerApp("wxb74e3f117aec1616", universalLink: "applinks:www.timerbell.com")
        
        let message = WXMediaMessage()
        message.title = title
        message.description = description
        
        URLSession.shared.dataTask(with: URL(string: iconUrl)!) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    // Continue with your code here
                    message.setThumbImage(image)
                }
                if !shareurl.isEmpty {
                    let ext = WXWebpageObject()
                    ext.webpageUrl = shareurl
                    message.mediaObject = ext
                } else if let imageData = Data(base64Encoded: imageData), let image = UIImage(data: imageData) {
                    let ext = WXImageObject()
                    ext.imageData = imageData
                    message.mediaObject = ext
                }
                
                let req = SendMessageToWXReq()
                req.bText = false
                req.message = message
                req.scene = towhere == 0 ? Int32(WXSceneSession.rawValue) : Int32(WXSceneTimeline.rawValue)
                
                WXApi.send(req) { (isSuccess) in
                    print("Send success: \(isSuccess)")
                }
            }
        }.resume()
        
        
        //
        //        if let url = URL(string: iconUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        //            message.setThumbImage(image)
        //        }
        
        
    }
    
    static func shareToQZone(title: String, subtitle: String, url: String, iconUrl: String, isOn: Bool) {
        guard let imageUrl = URL(string: iconUrl) else { return }
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let newsObj = QQApiTextObject(text: "text")
                //                let newsObj = QQApiNewsObject(url: URL(string: url), title: title, description: subtitle, previewImageData: data, targetContentType: QQApiURLTargetType.news)
                newsObj?.cflag = UInt64(kQQAPICtrlFlag.qqapiCtrlFlagQZoneShareOnStart.rawValue)
                //                newsObj?.shareDestType = ShareDestType.QZone
                let req = SendMessageToQQReq(content: newsObj)
                /*  QQApiSendResultCode 说明
                 EQQAPISENDSUCESS = 0,                      操作成功
                 EQQAPIQQNOTINSTALLED = 1,                   没有安装QQ
                 EQQAPIQQNOTSUPPORTAPI = 2,
                 EQQAPIMESSAGETYPEINVALID = 3,              参数错误
                 EQQAPIMESSAGECONTENTNULL = 4,
                 EQQAPIMESSAGECONTENTINVALID = 5,
                 EQQAPIAPPNOTREGISTED = 6,                   应用未注册
                 EQQAPIAPPSHAREASYNC = 7,
                 EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
                 EQQAPISENDFAILD = -1,                       发送失败
                 qzone分享不支持text类型分享
                 EQQAPIQZONENOTSUPPORTTEXT = 10000,
                 qzone分享不支持image类型分享
                 EQQAPIQZONENOTSUPPORTIMAGE = 10001,
                 当前QQ版本太低，需要更新至新版本才可以支持
                 EQQAPIVERSIONNEEDUPDATE = 10002,
                 */
                let code = QQApiInterface.send(req)
                print(code)
            }
        }.resume();
    }
    
    static func shareToQQ(title: String, subtitle: String, url: String, iconUrl: String, isOn: Bool) {
        
        guard let imageUrl = URL(string: iconUrl) else { return }
        //
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data, error == nil else { return }
            //
            DispatchQueue.main.async {
                let newsObj = QQApiNewsObject(url: URL(string: url), title: title, description: subtitle, previewImageData: data, targetContentType: QQApiURLTargetType.news)
                newsObj?.shareDestType = ShareDestType.QQ
                newsObj?.cflag = UInt64(kQQAPICtrlFlag.qqapiCtrlFlagQQShare.rawValue)
                let req = SendMessageToQQReq(content: newsObj)
                let code = QQApiInterface.send(req)
                print(code)
                
            }
        }.resume();
        
        // let txtObj = QQApiTextObject(text: "text")
        // let req = SendMessageToQQReq(content: txtObj)
        // let sent = QQApiInterface.send(req)
        
        //                if let imageUrl = URL(string: iconUrl),
        //                   let imgData = try? Data(contentsOf: imageUrl) {
        //                    let imgObj = QQApiImageObject(data: imgData, previewImageData: imgData, title: title, description: subtitle)
        //                    let req = SendMessageToQQReq(content: imgObj)
        //                    QQApiInterface.send(req)
        //                }
        //                return tencentOAuth
    }
    
    //    static func shareWithQQ() {
    //        var  _tencentOAuth: TencentOAuth =  TencentOAuth.init(appId:  "1112263382" , andDelegate:  nil)
    //
    //
    //        let  filePath =   Bundle.main.path(forResource:  "logo" , ofType:  "png" )
    //        let  imgData =  NSData(contentsOfFile:filePath!)
    //        let  imgObj = QQApiImageObject(data: imgData as Data?, previewImageData: imgData as Data?, title: "title", description: "haha");
    ////        let  imgObj =  QQApiImageObject(data: imgData  as  Data !, previewImageData: imgData  as  Data !,
    ////                                        title:  "hangge.com" , description:  "航歌 - 做最好的开发者知识平台" )
    //        let  req =  SendMessageToQQReq (content: imgObj)
    //        QQApiInterface.send(req)
    //
    //    }
    
    
    static func requestReview() {
        //        var ud = UserDefaults.standard.integer(forKey: "rew")
        //         NSLog("rew show count is %d", ud)
        //
        //        if(ud >= 1)
        //        {
        
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene  {
                SKStoreReviewController.requestReview(in: scene)
                NSLog("rateappios14")
            }
        } else {
            // Fallback on earlier versions
            SKStoreReviewController.requestReview()
            NSLog("rateappotherios")
        }
        
        
        //        }
        //        ud = ud + 1
        //        UserDefaults.standard.setValue(ud, forKey: "rew")
        //        UserDefaults.standard.synchronize()
        
        //         SKStoreReviewController.requestReview()
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
    
    static func getColor(hex: String) ->Color {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        let alpha = Double((rgbValue & 0xFF000000) >> 24) / 255.0
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    /**跨组件推送 类似eventbus通过
     NotificationCenter.default.addObserver显示 参考 https://www.youtube.com/watch?v=DM3LDLG3Cnk
     */
    static func postNotification(action: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: action) , object: self, userInfo: ["content": "123"]);
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
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests();
            //            UNUserNotificationCenter.current().removeAllDeliveredNotifications();
        };
    }
    
    @available(iOS 10.0, *)
    static func pushNotificationWithWhen(when: Int, title: String, body: String, userInfo: Any, action: String) {
        //        let startNotificationTime: Int = getCurrentTimeStampBySeconds() + delay;
        let queue = DispatchQueue(label: "pushNotificationWithWhen", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            let date:Date = getDateFromTimeStamp(timeStamp: when.description);
            //        let com = Calendar.current.dateComponents(in: TimeZone.current, from: date)
            let com = getDateComponentFromDate(date: date);
            
            //            if((com.year == 2023 && com.month == 2 && com.day == 26) || (com.year == 2023 && com.month == 2 && com.day == 27) || com.year == 2023 && com.month == 2 && com.day == 28) {
            //                print("1111111111111 title:" + String(title) + ", body" + String(body) + " year:" + String(com.year!) + " month:" + String(com.month!) + " day:" + String(com.day!) + " hour:" + String(com.hour!) + " minute:" + String(com.minute!) + " second: " + String(com.second!));
            do {
                showLocalNotification(title: title, body: body, userInfo: userInfo, year: com.year!, month: com.month!, day: com.day!, hour: com.hour!, minute: com.minute!, second: com.second!, action: action);
            } catch {}
        }
    }
    
    @available(iOS 10.0, *)
    static func showLocalNotificationWithDelay(delay: Int, title: String, body: String, userInfo: Any, action: String) {
        let queue = DispatchQueue(label: "showLocalNotificationWithDelay", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            let startNotificationTime: Int = getCurrentTimeStampBySeconds() + delay;
            let date:Date = getDateFromTimeStamp(timeStamp: startNotificationTime.description);
            //        let com = Calendar.current.dateComponents(in: TimeZone.current, from: date)
            let com = getDateComponentFromDate(date: date);
            showLocalNotification(title: title, body: body, userInfo: userInfo, year: com.year!, month: com.month!, day: com.day!, hour: com.hour!, minute: com.minute!, second: com.second!, action: action);
        }
    }
    
    @available(iOS 10.0, *)
    static func cancelNotificationWithAction(action: String) {
        let queue = DispatchQueue(label: "cancelNotificationWithAction", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [action])
        }
    }
    
    /**
     *发送本地推送 app测底关闭也可以推送
     *if #available(iOS 10.0, *){
     *sentNo()
     *}
     */
    @available(iOS 10.0, *)
    static func showLocalNotification(title: String, body: String, userInfo: Any, year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, action: String) {
        let queue = DispatchQueue(label: "showLocalNotification", qos: .userInteractive, attributes: .concurrent);
        queue.async {
            //设置推送内容
            let content = UNMutableNotificationContent()
            content.title = title;
            content.body = body;
            content.userInfo = userInfo as! [AnyHashable : Any];
            content.sound = UNNotificationSound.default
            content.badge = 1;
            if #available(iOS 15.0, *){
                content.relevanceScore = 1; //0到1之间 决定app 在Notification列表显示的优先级
            }
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
            //            UNUserNotificationCenter.current().
            //
            //将通知请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    //                   VVLog("Time Interval Notification scheduled: \(requestIdentifier)")
                } else {
                    //                   VV Log("通知添加成功")
                }
            }
        }
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

    static func serializeCustomReminderList(customReminders: [CustomReminder]) -> [[String: Any]] {
        return customReminders.map { serializeCustomReminder(customReminder: $0) }
    }
    
    static func convertEventsToCustomEvents(events: [EKEvent]) -> [CustomEvent] {
        return events.map { CustomEvent(from: $0) }
    }
    
    static func convertRemindersToCustomReminders(reminders: [EKReminder]) -> [CustomReminder] {
        return reminders.map { CustomReminder(from: $0) }
    }
}
