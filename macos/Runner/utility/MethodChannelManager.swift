////
////  MethodChannelManager.swift
////  Runner
////
////  Created by 林智彬 on 2022/1/29.ƒ
////
//
import Foundation
import FlutterMacOS
import WidgetKit
import SwiftUI
@available(macOS 11.0, *)
class MethodChannelManager {
    static let instance:MethodChannelManager = MethodChannelManager()
    var channel:FlutterMethodChannel?;
    var customStatusBarWidget:CustomStatusBarWidget?
    var curCounterStatus: Int?
    var window: MainFlutterWindow?;
    @AppStorage("uid", store: UserDefaults(suiteName: Params.groupName)) var uid : String = ""
//    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: "\(Params.isMACOS == true ? "":"group.")S4CLCWPCGH.com.timespeed.timehello")) var primaryData2 : Data = Data()
    //@AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: "\(Params.isMACOS == true ? "":"group.")S4CLCWPCGH.com.timespeed.timehello")) var primaryData : Data = Data()
    static func shareInstance(flutterViewController: FlutterViewController?, window: MainFlutterWindow?) -> MethodChannelManager {
        if (instance.channel == nil) {
            instance.window = window;
            let appDelegate:AppDelegate = NSApplication.shared.delegate as! AppDelegate
            instance.channel = FlutterMethodChannel(name: "com.efficienttime.counter",
                                                    binaryMessenger: flutterViewController!.engine.binaryMessenger)
            instance.channel?.setMethodCallHandler(instance.handleMethodChannel);
            RegisterGeneratedPlugins(registry: flutterViewController!)
            instance.customStatusBarWidget = Utility.initStatusBarMenu(appDelegate: appDelegate);
            instance.customStatusBarWidget?.time.stringValue = ""
            
            //            appDelegate.statusItem = {
            //                NSStatusBar.system.statusItem(withLength:80) //状态栏高度
            //            }()
        }
        return instance;
    }
    
    init() {
    }
    
    public func handleMethodChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "requestEventReminderAccess": // 获取权限
                       EventReminderManager.shared.requestAccess { granted, error in
                           if granted {
                               print("授权成功，可以访问日历和提醒")
                               result("Access granted")
                           } else {
                               print("授权失败，错误信息: \(String(describing: error))")
                               result(FlutterError(code: "ACCESS_DENIED", message: "访问日历或提醒被拒绝", details: error?.localizedDescription))
                           }
                       }
                       
                   case "fetchEventReminderEvents": // 获取事件
                       guard let args = call.arguments as? [String: Any],
                             let start = args["startDate"] as? Double,
                             let end = args["endDate"] as? Double else {
                           result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                           return
                       }
                       
                       let startDate = Date(timeIntervalSince1970: start / 1000)
                       let endDate = Date(timeIntervalSince1970: end / 1000)
                EventReminderManager.shared.fetchEvents(startDate: startDate, endDate: endDate) { events in
                           let eventTitles = events.map { $0.title }
                        let res:[[String: Any]] = Utility.serializeEventList(events: events)
                    do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: [])
                    
                        // 创建数据字典
                        let data: [String: Any] = [
                            "success": true,
                            "data":res
                        ]
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            result(jsonString) // 使用 JSON 字符串返回结果
                        } else {
                            result("{\"success\": false, \"error\": \"Failed to encode JSON.\"}")
                        }
                        
                    // 将 JSON 数据转换为字符串
//                    if jsonData {
//                        result(jsonData) // 使用 JSON 字符串返回结果
//                    } else {
//                        result("{\"success\": false, \"error\": \"Failed to encode JSON.\"}")
//                    }
                    } catch {
                        // 捕获 JSON 转换错误
                        result("{\"success\": false, \"error\": \"\(error.localizedDescription)\"}")
                    }
//                           result(res)
                       }
                       
                   case "fetchEventReminderReminders": // 获取提醒
                EventReminderManager.shared.fetchReminders { reminders in
                    
                    let reminderTitles = reminders.map { $0.title }
                    result(reminderTitles)
                    
                    let res:[[String: Any]] = Utility.serializeReminderList(reminders: reminders)
                    do {
                        // 创建数据字典
                        let data: [String: Any] = [
                            "success": true,
                            "data":res
                        ]
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            result(jsonString) // 使用 JSON 字符串返回结果
                        } else {
                            result("{\"success\": false, \"error\": \"Failed to encode JSON.\"}")
                        }
                    } catch {
                        // 捕获 JSON 转换错误
                        result("{\"success\": false, \"error\": \"\(error.localizedDescription)\"}")
                    }
                }
                       
                   case "syncEventsToReminders": //同步事件到提醒
                       guard let args = call.arguments as? [String: Any],
                             let start = args["startDate"] as? Double,
                             let end = args["endDate"] as? Double else {
                           result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                           return
                       }
                       
                       let startDate = Date(timeIntervalSince1970: start / 1000)
                       let endDate = Date(timeIntervalSince1970: end / 1000)
                EventReminderManager.shared.syncEventsToReminders(startDate: startDate, endDate: endDate) { success, error in
                           if success {
                               result("Events synced to reminders successfully")
                           } else {
                               result(FlutterError(code: "SYNC_FAILED", message: "同步事件到提醒失败", details: error?.localizedDescription))
                           }
                       }
                       
                   case "syncRemindersToEvents": //同步提醒到事件
                EventReminderManager.shared.syncRemindersToEvents { success, error in
                           if success {
                               result("Reminders synced to events successfully")
                           } else {
                               result(FlutterError(code: "SYNC_FAILED", message: "同步提醒到事件失败", details: error?.localizedDescription))
                           }
                       }
            case "requestEventReminderAccess":
                EventReminderManager.shared.requestAccess { granted, error in
                    if granted {
                        print("授权成功，可以访问日历和提醒")
                    } else {
                        print("授权失败，错误信息: \(String(describing: error))")
                    }
                }
                break;
            case "test":
                Task {
                    let _id = "66a84fecb65a7c07dde2a162"
                    NotificationCenter.default.post(name: NSNotification.Name( Params.ACTION_HANDLE_NOTIFICATION_POSTMESSAGE) , object: self, userInfo: ["action": "handleUpdateFlomoMissionModelList"]);
                    
//                    let res:BaseResponse? = await URLSessionRequest.insertStatsModel(params: [
//                        "title": "111111111111111111",
//                        "type": 0,
//                        "focus_duration": 0,
//                        "tagNames": "",
//                        "category": NSNull()(),
//                        "color": 0,
//                        "icon": 0,
//                        "device_id": "B5CC32ED-595A-54B7-A814-7BC911FBD2D4",
//                        "value": 60000.0,
//                        "begin_time": 1729255421071,
//                        "finish_time": 1729255481094,
//                        "duration": 0,
//                        "folder_id": NSNull()(),
//                        "mission_id": "66a09799d4c83f07d66e4c23",
//                        "uid": "089f8c2d-85b9-45f1-899c-d1159ca9e6f3"
//                    ])
                    
//                    let res:ResourceResponse? = await URLSessionRequest.requestSceneList(scene: "timehello_game");
//                    print("err \(res)")
                }
                break;
            case "IAPManagerFetchReceipt":
                let list:[String] = (call.arguments as! [String]);
//                let list:[String] = (res["datas"] as? [String]) ?? [];
                IAPManager.shared.fetchProducts(list: list) { products in
                    // 处理获取到的产品数组
                    if products.isEmpty {
                        print("No products available.")
                    } else {
                        do {
                            // 将 SKProduct 转换为字典数组
                            let productsArray = products.map { product -> [String: Any] in
                                return [
                                    "title": product.localizedTitle,
                                    "description": product.localizedDescription,
                                    "price": "\(product.priceLocale.currencySymbol ?? "")\(product.price)",
                                    "identifier": product.productIdentifier
                                ]
                            }
                            
                            // 创建数据字典
                            let data: [String: Any] = [
                                "success": true,
                                "data": productsArray
                            ]
                            
                            // 将字典转换为 JSON 数据
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            
                            // 将 JSON 数据转换为字符串
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                result(jsonString) // 使用 JSON 字符串返回结果
                            } else {
                                result("{\"success\": false, \"error\": \"Failed to encode JSON.\"}")
                            }
                        } catch {
                            // 捕获 JSON 转换错误
                            result("{\"success\": false, \"error\": \"\(error.localizedDescription)\"}")
                        }
                    }
                }
                break;
            case "setUserBean":
                uid = (call.arguments as! [[String: Any]])[0]["uid"] as! String;
                UserDefaults(suiteName: Params.groupName)?.set(uid, forKey: "uid")
                WidgetCenter.shared.reloadAllTimelines()
                break;
            case "scheduleShutdown":
                Utility.scheduleShutdown(after: 30000);
                break;
            case "init":
                let env:Bool = (call.arguments as! [[String: Any]])[0]["env"] as! Bool;
                //                let env:Bool = item["env"] as! Bool;
                Params.isDebug = !env;
                if(Params.isDebug) {
                    //                    WindowUtility.setMinSize(window: window!, width: 300, height: 150);
                } else {
                    //                    if(window != nil) {
//                                            WindowUtility.setMinSize(window: window!, width: 1000, height: 800);
                    //                    }
                }
                break;
            case "storeWQBNoteMissionData":
                let key = (call.arguments as! [[String: Any]])[0]["key"] as! String;
                let content = (call.arguments as! [[String: Any]])[0]["content"] as! String;
                let subtitle = (call.arguments as! [[String: Any]])[0]["subtitle"] as! String;
                
                let color = (call.arguments as! [[String: Any]])[0]["color"] as! Int;
                let priorityStatus = (call.arguments as! [[String: Any]])[0]["priorityStatus"] as? Int ?? 0;
                let order_index = (call.arguments as! [[String: Any]])[0]["order_index"] as? Int ?? -1;
//                let subtitle = (call.arguments as! [[String: Any]])[0]["subtitle"] as! String;
                let missionModel = WQBMissionModel(key: key, content: content, subtitle: subtitle, priorityStatus: priorityStatus, color: color);
                let missionStoreData:WQBMissionStoreData;
                if #available(iOS 14.0, *) {
                        missionStoreData  = WQBMissionStoreData(missionData: missionModel)
                    Task {
                        if order_index == 1 {
                            await missionStoreData.encodeData();
                        } else if order_index == 2 {
                            await missionStoreData.encodeData2();
                        } else if order_index == 3 {
                            await missionStoreData.encodeData3();
                        }  else if order_index == 4 {
                            await missionStoreData.encodeData4();
                        } else if order_index == 5 {
                            await missionStoreData.encodeData5();
                        } else if order_index == 6 {
                            await missionStoreData.encodeData6();
                        } else if order_index == 7 {
                            await missionStoreData.encodeData7();
                        }
                    }
                } else {
                    // Fallback on earlier versions
                };
                break;
            case "storeMissionDataList": // 4象限
                let title1 = (call.arguments as! [[String: Any]])[0]["title"] as! String;
                let title2 = (call.arguments as! [[String: Any]])[1]["title"] as! String;
                let title3 = (call.arguments as! [[String: Any]])[2]["title"] as! String;
                let title4 = (call.arguments as! [[String: Any]])[3]["title"] as! String;
                let array1:NSArray = (call.arguments as! [[String: Any]])[0]["datas"] as! NSArray;
                let array2:NSArray = (call.arguments as! [[String: Any]])[1]["datas"] as! NSArray;
                let array3:NSArray = (call.arguments as! [[String: Any]])[2]["datas"] as! NSArray;
                let array4:NSArray = (call.arguments as! [[String: Any]])[3]["datas"] as! NSArray;
                
                let storeData = StoreData(title1: title1 , title2: title2 , title3: title3 , title4: title4 , missionList1: Utility.getMissionModelTitle(array: array1), missionList2: Utility.getMissionModelTitle(array: array2), missionList3: Utility.getMissionModelTitle(array: array3), missionList4: Utility.getMissionModelTitle(array: array4), missionListMissionModel1: Utility.getMissionModelsFromList(list: array1), missionListMissionModel2: Utility.getMissionModelsFromList(list: array2), missionListMissionModel3: Utility.getMissionModelsFromList(list: array3), missionListMissionModel4: Utility.getMissionModelsFromList(list: array4));
                if #available(iOS 14.0, *) {
                    let primaryData = PrimaryData(simpleData: storeData)
                    Task {
                        await primaryData.encodeData();
                    }
                 
                } else {
                    // Fallback on earlier versions
                };
                break;
            case "storeMyCalendarMissionList": //创建任务日志任务
                let list = (call.arguments as! [[String: Any]]);
                var listMissionModels:[MissionModelList] = [];
                //                for index in 0...((call.arguments as AnyObject).length ?? 0) {
                if list.count  > 0 {
                    for index in 0...list.count - 1 {
                        let item = list[index]
                        let time:Int = item["time"] as! Int;
                        let lunar:String = item["lunar"] as? String ?? "";
                        
                        let datas:[[String: Any]] = item["data"] as? [[String: Any]] ?? [];
                        let count = datas.count;
                        var listMissionModel: [MissionModel] = []
                        //time四毫秒时间戳
                        let currentTime = Int(Date().timeIntervalSince1970)
                        //50天时间范围
                        let tenDaysInSeconds = 100 * 24 * 60 * 60 * 1000
//                        if (time) > (currentTime * 1000 - tenDaysInSeconds) && (time) < (currentTime * 1000 + tenDaysInSeconds) {
                            
                            let date = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                        let calendar = Calendar.current
                        let components1 = calendar.dateComponents([.year, .month, .day], from: date)
                        if datas.count > 0 {
                            print("");
                        }
//                        if components1.year == 2024 && components1.month==11 && components1.day == 19 {
//                            if datas.count > 0 {
//                                print("");
//                            }
//                        }
//                            print("date:\(date) count:\(count)")
                            if count > 0 {
                                for index2 in 0...count - 1 {
                                    let item2 = datas[index2]
                                    let title:String = item2["title"] as? String ?? "";
                                    let objectId:String = item2["_id"] as? String ?? "";
                                    //                            let percent:Double = item2["percent"] as? Double ?? 0;
                                    let color: Int = item2["color"] as? Int ?? 0xffff8800 - 0xff000000;
                                    let isFinished: Bool = item2["isFinished"] as? Bool ?? false;
                                    
                                    //                        let isDelayed:Bool = item["isDelayed"] as! Bool;
                                    //                                                let isFinished:Bool = item["isFinished"] as! Bool;
                                    //                                                let title:String = item["title"] as! String;
                                    let background_url:String? = item["background_url"] as? String;
                                    let end_time:Int = item["end_time"] as? Int ?? 0;
                                    let priorityStatus:Int? = item["priorityStatus"] as? Int;
//                                    if title == "网球" {
//                                        print("date:\(date)")
//                                        print("year:\(components1.year) month:\(components1.month) day:\(components1.day)")
//                                        if (components1.year == 2024 && components1.month == 11 && components1.day == 19) {
                                            let missionData = MissionModel(objectId: objectId, title: title, lunar: lunar, background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: false, color: color)
//                                    if title == "网球" {
//                                        print();
//                                    }
                                    
                                    listMissionModel.append(missionData)
//                                        }
//                                    }
                                }
                            }
                        if listMissionModel.count > 0 {
                            listMissionModels.append(MissionModelList(time: time, lunar: lunar,listMissionModel: listMissionModel))
                        }
//                        }
                    }
                }
                if #available(iOS 14.0, *) {
                    let primaryData:MyCalendarMissionStoreData = MyCalendarMissionStoreData(missionData: MyCalendarMissionData(listMissionModelList: listMissionModels))
                    Task {
                        await primaryData.encodeData();
                    }
                } else {
                    // Fallback on earlier versions
                };
                break;
            case "storeFlomoMissionList": //创建今天任务 签到
                let list = (call.arguments as! [[String: Any]]);
                var listMissionModels:[FlomoMissionModelList] = [];
                //                for index in 0...((call.arguments as AnyObject).length ?? 0) {
                if list.count > 0 {
                    for index in 0...list.count - 1 {
                        let item = list[index]
                        let time:Int = item["time"] as! Int;
                        
                        let entryDate = Date(timeIntervalSince1970: TimeInterval(time) / 1000)

                        let datas:[[String: Any]] = item["data"] as? [[String: Any]] ?? [];
                        let count = datas.count - 1;
                        var listFlomoMissionModel: [FlomoMissionModel] = []
                        if(count >= 0) {
                            for index2 in 0...count {
                                let item2 = datas[index2]
                                let objectId:String? = item2["_id"] as? String;
                                let title:String = item2["title"] as? String ?? "";
                                let percent:Double = item2["percent"] as? Double ?? 0;
                                let color: Int = item2["color"] as? Int ?? 0xffff8800 - 0xff000000;
                                let isFinished: Bool = item2["isFinished"] as? Bool ?? false;
                                if (title == "早起") {
                                                 print("");
                                             }
                                listFlomoMissionModel.append(FlomoMissionModel(objectId: objectId, title: title, color: color, isFinished: isFinished, percent: percent))
                            }
                        }
                        listMissionModels.append(FlomoMissionModelList(time: time,  listMissionModel: listFlomoMissionModel))
                    }
                }
                if #available(iOS 14.0, *) {
                    let primaryData:FlomoMissionStoreData = FlomoMissionStoreData(missionData: FlomoMissionData(listFlomoMissionModelList: listMissionModels))
                    Task {
                        await primaryData.encodeData();
                    }
                } else {
                    // Fallback on earlier versions
                };
                break;
            case "storeCustomizeMissionList": //创建自定义任务
                let res = (call.arguments as! [String: Any]);
                let list:[[String: Any]] = (res["datas"] as? [[String: Any]]) ?? [[:]];
                let title = (res["title"] as! String);
                var listMissionModels:[MissionModel] = [];
                if list.count > 0 {
                    for index in 0...list.count - 1 {
                        let item = list[index]
                        
                        let objectId:String? = item["_id"] as? String;
                        let isDelayed:Bool = item["isDelayed"] as! Bool;
                        let isFinished:Bool = item["isFinished"] as! Bool;
                        let title:String = item["title"] as! String;
                        let background_url:String? = item["background_url"] as? String;
                        let end_time:Int = item["end_time"] as! Int;
                        let priorityStatus:Int? = item["priorityStatus"] as? Int;
                        let color:Int? = item["color"] as? Int ?? 0xffff8800 - 0xff000000;
                        let missionData = MissionModel(objectId: objectId,title: title, lunar: "", background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: isDelayed, color:color)
                        listMissionModels.append(missionData);
                        //                            print("11111");
                    }
                    //                    }
                    if #available(iOS 14.0, *) {
                        let primaryData:CustomizeMissionStoreData = CustomizeMissionStoreData(missionData: MissionData(title: title,listMissionModel: listMissionModels))
                        Task {
                            await primaryData.encodeData();
                        }
                    } else {
                    };
                }
                break;
            case "storeMissionList": //创建今天任务
                let list = (call.arguments as! [[String: Any]]);
                    var listMissionModels:[MissionModel] = [];
                    if list.count > 0 {
                        for index in 0...list.count - 1 {
                            let item = list[index]
                            
                            let objectId:String? = item["_id"] as? String;
                            let isDelayed:Bool = item["isDelayed"] as! Bool;
                            let isFinished:Bool = item["isFinished"] as! Bool;
                            let title:String = item["title"] as! String;
                            let background_url:String? = item["background_url"] as? String;
                            let end_time:Int = item["end_time"] as! Int;
                            let priorityStatus:Int? = item["priorityStatus"] as? Int;
                            let color:Int? = item["color"] as? Int ?? 0xffff8800 - 0xff000000;
                            let missionData = MissionModel(objectId: objectId,title: title, lunar: "", background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: isDelayed, color:color)
                            listMissionModels.append(missionData);
//                            print("11111");
                        }
//                    }
                    if #available(iOS 14.0, *) {
                        let primaryData:MissionStoreData = MissionStoreData(missionData: MissionData(listMissionModel: listMissionModels))
                        Task {
                            await primaryData.encodeData();
                        }
                    } else {
                    };
                }
                break;
            case "storeEndTimeMissionList": //创建倒计时任务
                let list = (call.arguments as! [[String: Any]]);
                    var listMissionModels:[EndTimeMissionModel] = [];
                    if list.count > 0 {
                        for index in 0...list.count - 1 {
                            let item = list[index]
                            
                            let objectId:String? = item["_id"] as? String;
                            let isDelayed:Bool = item["isDelayed"] as! Bool;
                            let isFinished:Bool = item["isFinished"] as! Bool;
                            let title:String = item["title"] as! String;
                            let background_url:String? = item["background_url"] as? String;
                            let end_time:Int = item["end_time"] as! Int;
                            let priorityStatus:Int? = item["priorityStatus"] as? Int;
                            let color:Int? = item["color"] as? Int ?? 0xffff8800 - 0xff000000;
                            let missionData = EndTimeMissionModel(objectId: objectId,title: title, lunar: "", background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: isDelayed, color:color, remainTime: 0)
                            listMissionModels.append(missionData);
//                            print("11111");
                        }
//                    }
                    if #available(iOS 14.0, *) {
                        let primaryData:EndTimeMissionStoreData = EndTimeMissionStoreData(missionData: EndTimeMissionData(listMissionModel: listMissionModels))
                        Task {
                            await primaryData.encodeData();
                        }
                    } else {
                    };
                }
                break;
            case "requestReview":
                Utility.requestReview();
                break;
            case "pushListNotificationWithWhen":
                let list: Array = (call.arguments as! [[String: Any]]);
                for item in list {
                    //                print(11111);
                    let id:String = item["id"] as! String;
                    let content:String = item["content"] as! String;
                    let title:String = item["title"] as! String;
                    let when:Int = item["when"] as! Int;
                    if #available(iOS 10.0, *){
                        Utility.pushNotificationWithWhen(when: when, title: title, body: content, userInfo: ["id": "id66", "articleId": 999], action: id);
                    }
                }
                break;
            case "grantNotificationPermission":
                Utility.postNotification(action: Params.ACTION_HANDLE_NOTIFICATION_PERMISSION);
                break;
            case "requestStatusBar":
                let text: String = (call.arguments as! [[String: Any]])[0]["text"] as! String;
                let status: Int = (call.arguments as! [[String: Any]])[0]["status"] as! Int;
                let shouldShowRedFocusStatus: Bool = (call.arguments as! [[String: Any]])[0]["shouldShowRedFocusStatus"] as! Bool;
                customStatusBarWidget?.time.stringValue = text
                customStatusBarWidget?.image.image = shouldShowRedFocusStatus ? NSImage.init(named: "ic_appicon_red") : NSImage.init(named: "ic_appicon_blue")
                print("text:" + text + "status:" + status.description);
                if (self.curCounterStatus != status){
                    (NSApplication.shared.delegate as! AppDelegate).statusItem.menu = Utility.getStatusBarMenus(counterStatusEnum: CounterStatusEnum(rawValue: status))
                }
                self.curCounterStatus = status;
                
                break;
            case "openSetting":
                if let bundleIdentifier = Bundle.main.bundleIdentifier,
                   let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications?bundleId=\(bundleIdentifier)") {
                    NSWorkspace.shared.open(url)
                }
                //            if let appSettings = URL(string: NSApplication.open), NSApplication.shared.canOpenURL(appSettings) {
                //                NSApplication.shared.open(appSettings)
                //                if #available(iOS 10.0, *) {
                //                    UIApplication.shared.open(appSettings, completionHandler: { (success) in
                //                        result("{\"success\": true, \"data\": \(String(success))}");
                //                    })
                //                }
                //            }
                //            break;
            case "pushNotificationWithWhen":
                let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
                let content: String = (call.arguments as! [[String: Any]])[0]["content"] as! String;
                let when: Int = (call.arguments as! [[String: Any]])[0]["when"] as! Int;
                let id: String = (call.arguments as! [[String: Any]])[0]["id"] as! String;
                if #available(iOS 10.0, *){
                    Utility.pushNotificationWithWhen(when: when, title: title, body: content, userInfo: ["id": "id66", "articleId": 999], action: id);
                }
                break;
            case "cancelAllPendingNotification":
                Utility.cancelAllPendingNotification();
                result("{\"success\": true, \"data\": \"\"}");
                break;
            case "isNotificationEnabled":
                Utility.isNotificationEnabled(cb: {(res:Bool)->Void in
                    //                NSLog("", result);
                    result("{\"success\": true, \"data\": \(String(res))}");
                }
                );
                break;
            case "pushCounterNotification":
                let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
                let content: String = (call.arguments as! [[String: Any]])[0]["content"] as! String;
                let delay: Int = (call.arguments as! [[String: Any]])[0]["delay"] as! Int;
                let id: String = (call.arguments as! [[String: Any]])[0]["id"] as! String;
                let extendsParams: String = (call.arguments as! [[String: Any]])[0]["extendsParams"] as! String;
                Utility.showLocalNotificationWithDelay(delay: delay, title: title, body: content, userInfo: ["id": "id66", "articleId": 999], action: id);
                result(true);
                break;
            case "cancelPushCounterNotification":
                let id: String = (call.arguments as! [[String: Any]])[0]["action"] as! String;
                Utility.cancelNotificationWithAction(action: id);
                result(true);
                break;
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch let error{
            print(error);
        }
    }
    
    
}

