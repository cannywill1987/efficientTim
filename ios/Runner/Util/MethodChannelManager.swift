////
////  MethodChannelManager.swift
////  Runner
////
////  Created by 林智彬 on 2022/1/29.
////
//
import Foundation
import Flutter
import WidgetKit
import SwiftUI

@available(iOS 14.0, *)
class MethodChannelManager {
    static let instance:MethodChannelManager = MethodChannelManager()
    var channel:FlutterMethodChannel?;
    
    @AppStorage("uid", store: UserDefaults(suiteName: Params.groupName)) var uid : String = ""
    
    static func shareInstance(flutterViewController: FlutterViewController?) -> MethodChannelManager {
        if (instance.channel == nil) {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            instance.channel = FlutterMethodChannel(name: "com.efficienttime.counter",
                                                    binaryMessenger: flutterViewController!.binaryMessenger)
            instance.channel?.setMethodCallHandler(instance.handleMethodChannel);
        }
        return instance;
    }
    //
    //    init() {
    //    }
    //
    public func handleMethodChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "deleteReminder":
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            EventReminderManager.shared.deleteReminder(withIdentifier: args) { success, error in
                if success {
                    print("Event deleted successfully.")
                    result("{\"success\": true, \"error\": \"\"}")
                } else {
                    print("Failed to delete event: \(error?.localizedDescription ?? "Unknown error")")
                    result("{\"success\": false, \"error\": \"\(error)\"}")
                }
            }
            break;
        case "deleteEvent":
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            EventReminderManager.shared.deleteEvent(withIdentifier: args) { success, error in
                if success {
                    print("Event deleted successfully.")
                    result("{\"success\": true, \"error\": \"\"}")
                } else {
                    print("Failed to delete event: \(error?.localizedDescription ?? "Unknown error")")
                    result("{\"success\": false, \"error\": \"\(error)\"}")
                }
            }
            break;
        case "openReminderApp":
            guard let args = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            EventReminderManager.shared.openReminder(withIdentifier: args)
            break;
        case "openCalendarApp":
            guard let args = call.arguments as? Int64 else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            EventReminderManager.shared.openCalendarApp(at: args)
            break;
            
        case "updateMissionModelToCalendar":
            guard let args = call.arguments as? [String: Any]
                  else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            let ekEvent = EventReminderManager.createCustomEvent(from: args, eventStore: EventReminderManager.shared.eventStore)
            if ekEvent != nil {
                EventReminderManager.shared.updateEvent(id: args["_id"] as? String, ekEvent: ekEvent!) { success, error in
                    if success {
                        print("授权成功，可以访问日历和提醒")
                        result("{\"success\": true, \"error\": \"\"}")
                    } else {
                        print("授权失败，错误信息: \(String(describing: error))")
                        result("{\"success\": false, \"error\": \"\(error)\"}")
                    }
                }
            }
            break;
        case "updateMissionModelToReminder":
            guard let args = call.arguments as? [String: Any]
                  else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            let ekEvent = EventReminderManager.convertToEKReminder(from: args, eventStore: EventReminderManager.shared.eventStore)
            if ekEvent != nil {
                EventReminderManager.shared.updateReminder(id: args["_id"] as? String, ekReminder: ekEvent!) { success, error in
                    if success {
                        print("授权成功，可以访问日历和提醒")
                        result("{\"success\": true, \"error\": \"\"}")
                    } else {
                        print("授权失败，错误信息: \(String(describing: error))")
                        result("{\"success\": false, \"error\": \"\(error)\"}")
                    }
                }
            }
            break;
        case "createMissionModelToCalendar":
            guard let args = call.arguments as? [String: Any]
                  else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            let ekEvent = EventReminderManager.createCustomEvent(from: args, eventStore: EventReminderManager.shared.eventStore)
//            EventReminderManager.shared.syncEvent(ekEvent: ekEvent!, completion: success, error in {})
            if ekEvent != nil {
                EventReminderManager.shared.updateEvent(id: nil, ekEvent: ekEvent!) { success, error in
                    
                }
            }
            
            break;
        case "requestEventReminderAccess": // 获取权限
            EventReminderManager.shared.requestAccess { granted, error in
                if granted {
                    print("授权成功，可以访问日历和提醒")
                    //                           result("Access granted")
                    result("{\"success\": true, \"error\": \"\"}")
                } else {
                    print("授权失败，错误信息: \(String(describing: error))")
                    //                           result(FlutterError(code: "ACCESS_DENIED", message: "访问日历或提醒被拒绝", details: error?.localizedDescription))
                    result("{\"success\": false, \"error\": \"Failed to encode JSON.\"}")
                }
            }
            break;
        case "fetchEventReminderEvents": // 获取事件
            guard let args = call.arguments as? [String: Any],
                  let start = args["startDate"] as? Double,
                  let end = args["endDate"] as? Double else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "无效的参数", details: nil))
                return
            }
            
            let startDate = Date(timeIntervalSince1970: start / 1000)
            let endDate = Date(timeIntervalSince1970: end / 1000)
            EventReminderManager.shared.fetchEvents(startDate: startDate, endDate: endDate) { customEvents in
//                let eventTitles = events.map { $0.title }
                let res:[[String: Any]] = EventReminderManager.serializeEventList(events: customEvents)
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
                //                           result(res)
            }
            break;
        case "fetchEventReminderReminders": // 获取提醒
            EventReminderManager.shared.fetchReminders { customReminders in
                
//                let reminderTitles = reminders.map { $0.title }
//                result(reminderTitles)
                
                let res:[[String: Any]] = EventReminderManager.serializeReminderList(customReminders: customReminders)
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
            break;
            
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
            break;
        case "syncRemindersToEvents": //同步提醒到事件
            EventReminderManager.shared.syncRemindersToEvents { success, error in
                if success {
                    result("Reminders synced to events successfully")
                } else {
                    result(FlutterError(code: "SYNC_FAILED", message: "同步提醒到事件失败", details: error?.localizedDescription))
                }
            }
            break;
        case "pushToTimeline":
            if #available(iOS 15.0, *) {
                //                    Utility.navigateToViewController(controller: TimelineListViewController());
                navigateToTimelineViewController()
            } else {
                // Fallback on earlier versions
            };
            break;
        case "shareToWechat":
            let titleWechat: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
            let subtitle: String = (call.arguments as! [[String: Any]])[0]["subtitle"] as! String;
            let toWhere: Int = (call.arguments as! [[String: Any]])[0]["toWhere"] as! Int;
            //                let id: String = (call.arguments as! [[String: Any]])[0]["id"] as! String;
            let urlWechat: String = (call.arguments as! [[String: Any]])[0]["url"] as! String;
            
            let mIconUrlWechat: String = (call.arguments as! [[String: Any]])[0]["iconUrl"] as! String;
            
            let subtitleWechat: String = (call.arguments as! [[String: Any]])[0]["subtitle"] as! String;
            Utility.shareToWechat(towhere: toWhere, shareurl: urlWechat, title: titleWechat, description: subtitle, iconUrl: mIconUrlWechat, imageData: "");
            break;
        case "shareToQQ":
            let mIconUrl: String = (call.arguments as! [[String: Any]])[0]["iconUrl"] as! String;
            let url: String = (call.arguments as! [[String: Any]])[0]["url"] as! String;
            let subtitle: String = (call.arguments as! [[String: Any]])[0]["subtitle"] as! String;
            let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
            let isOn: Bool = (call.arguments as! [[String: Any]])[0]["isOn"] as! Bool;
            //                static func shareToQQ(title: String, subtitle: String, url: String, iconUrl: String, isOn: Bool) -> TencentOAuth {
            Utility.shareToQQ(title: title, subtitle: subtitle, url: url, iconUrl: mIconUrl, isOn: isOn);
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
                    let tenDaysInSeconds = 50 * 24 * 60 * 60 * 1000
                    //                    if (time) > (currentTime * 1000 - tenDaysInSeconds) && (time) < (currentTime * 1000 + tenDaysInSeconds) {
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                    print("date:\(date) count:\(count)")
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
                            let missionData = MissionModel(objectId: objectId, title: title, lunar: lunar, background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: false, color: color)
                            
                            
                            listMissionModel.append(missionData)
                        }
                    }
                    listMissionModels.append(MissionModelList(time: time, lunar: lunar,listMissionModel: listMissionModel))
                    //                    }
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
        case "storeFlomoMissionList": //创建今天任务
            let list = (call.arguments as! [[String: Any]]);
            var listMissionModels:[FlomoMissionModelList] = [];
            //                for index in 0...((call.arguments as AnyObject).length ?? 0) {
            if list.count > 0 {
                for index in 0...list.count - 1 {
                    let item = list[index]
                    let time:Int = item["time"] as! Int;
                    let datas:[[String: Any]] = item["data"] as? [[String: Any]] ?? [];
                    let count = datas.count - 1;
                    var listFlomoMissionModel: [FlomoMissionModel] = []
                    if(count > 0) {
                        for index2 in 0...count {
                            let item2 = datas[index2]
                            let objectId:String? = item2["_id"] as? String;
                            let title:String = item2["title"] as? String ?? "";
                            let percent:Double = item2["percent"] as? Double ?? 0;
                            let color: Int = item2["color"] as? Int ?? 0xffff8800 - 0xff000000;
                            let isFinished: Bool = item2["isFinished"] as? Bool ?? false;
                            listFlomoMissionModel.append(FlomoMissionModel(objectId: objectId, title: title, color: color, isFinished: isFinished, percent: percent))
                        }
                    }
                    listMissionModels.append(FlomoMissionModelList(time: time, listMissionModel: listFlomoMissionModel))
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
        case "setUserBean":
            uid = (call.arguments as! [[String: Any]])[0]["uid"] as! String;
            UserDefaults(suiteName: Params.groupName)?.set(uid, forKey: "uid")
            WidgetCenter.shared.reloadAllTimelines()
            break;
        case "scheduleShutdown":
            //Utility.scheduleShutdown(after: 30000);
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
            if #available(iOS 14.0, *) {
                let missionStoreData:WQBMissionStoreData
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
                    let missionData = EndTimeMissionModel(objectId: objectId,title: title, lunar: "", background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: isDelayed, color:color)
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
        case "storeMissionDataList":
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
        case "storeCustomizeMissionList": //创建今天任务
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
                    let end_time:Int = (item["end_time"] as? Int) ?? 0;
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
        case "getLiveActivityData":
            if #available(iOS 17, *) {
                let attributes = LiveActivityManager.shareInstance().activity?.attributes
                var state:IslandAttributes.ContentState? = LiveActivityManager.shareInstance().activity?.content.state;
                //                MethodChannelManager.shareInstance(flutterViewController: nil).channel?.invokeMethod("pushToPage", arguments: ["objectId": attributes?.objectId, "lastStartTime": attributes?.currentTimeStamp, "counterStatusEnum": attributes?.counterStatusEnum, "time": attributes?.time])
                
                result("{\"success\": true, \"data\": {\"objectId\": \"\(state?.objectId ?? "")\", \"lastStartTime\": \(0), \"counterStatusEnum\": \(state?.counterStatusEnum ?? 0), \"time\": \(0)}}")
                
            } else {
                // Fallback on earlier versions
            }
            break;
        case "requestReview":
            Utility.requestReview();
            break;
        case "startLiveActivity":
            //            NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarStopBtn"]);
            if #available(iOS 17.0, *) {
                //                LiveActivityManager.shareInstance().startActivity(time: 0, counterStatusEnum: CounterStatusEnum.none)
            } else {
                // Fallback on earlier versions
            }
            break;
        case "stopLiveActivity":
            if #available(iOS 17.0, *) {
                //                LiveActivityManager.shareInstance().stopActivity()
            } else {
                // Fallback on earlier versions
            }
            break;
        case "updateLiveActivity":
            print("");
            //            if #available(iOS 16.1, *) {
            //                //                LiveActivityManager.shareInstance().updateActivity(time: 0, counterStatusEnum: CounterStatusEnum.none)
            //            } else {
            //                // Fallback on earlier versions
            //            }
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
            print("pushListNotificationWithWhen");
            break;
        case "pushNotificationWithWhen":
            let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
            let content: String = (call.arguments as! [[String: Any]])[0]["content"] as! String;
            let when: Int = (call.arguments as! [[String: Any]])[0]["when"] as! Int;
            let id: String = (call.arguments as! [[String: Any]])[0]["id"] as! String;
            if #available(iOS 10.0, *){
                Utility.pushNotificationWithWhen(when: when, title: title, body: content, userInfo: ["id": "id66", "articleId": 999], action: id);
            }
            break;
        case "grantNotificationPermission":
            Utility.postNotification(action: Params.ACTION_HANDLE_NOTIFICATION_PERMISSION);
            break;
        case "shareSdkSubmitPolicyGrantResult":
            //                                ShareSdkManager.getInstance().submitPolicyGrantResult(true);
            break;
        case "preSecVerify":
            result("{\"success\": true, \"data\": \"\"}");
            break;
        case "secVerify":
            result("{\"success\": true, \"data\": \"\"}");
            break;
        case "requestStatusBar":
            
            let text: String = (call.arguments as! [[String: Any]])[0]["text"] as! String;
            let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
            let status: Int = (call.arguments as! [[String: Any]])[0]["status"] as! Int;
            let statusString: String = (call.arguments as! [[String: Any]])[0]["statusString"] as! String;
            let totalTomatees: Int = (call.arguments as! [[String: Any]])[0]["totalTomatees"] as! Int;
            let focusedDuration: String = (call.arguments as! [[String: Any]])[0]["focusedDuration"] as! String;
            let bgUrl: String = (call.arguments as! [[String: Any]])[0]["bgUrl"] as! String;
            let objectId: String = (call.arguments as! [[String: Any]])[0]["objectId"] as! String;
            let currentTimeStamp = Int(Date().timeIntervalSince1970) // 当前时间戳
            let numTomatees: Int = (call.arguments as! [[String: Any]])[0]["numTomatees"] as! Int;
            let time: Int = (call.arguments as! [[String: Any]])[0]["time"] as! Int;
            let shouldShowRedFocusStatus: Bool = (call.arguments as! [[String: Any]])[0]["shouldShowRedFocusStatus"] as! Bool;
            let isCountDown: Bool = (call.arguments as! [[String: Any]])[0]["isCountDown"] as! Bool;
            let focusedDurationInt: Int = (call.arguments as! [[String: Any]])[0]["focusedDurationInt"] as! Int;
            let restingDurationInt: Int = (call.arguments as! [[String: Any]])[0]["restingDurationInt"] as! Int;
            
            print("time:" + text + ",status:" + status.description);
            if #available(iOS 16.1, *) {
                if (LiveActivityManager.shareInstance().curCounterStatus != status){
                    LiveActivityManager.shareInstance().curCounterStatus = status
                    LiveActivityManager.shareInstance().updateActivity(
                        objectId: objectId,
                        currentTimeStamp: currentTimeStamp,
                        statusString: statusString,
                        totalTomatees: totalTomatees,
                        numTomatees: numTomatees,
                        focusedDuration: focusedDuration,
                        bgUrl: bgUrl,
                        title: title, text: text, isCountDown: isCountDown, time: time, counterStatusEnum: CounterStatusEnum(rawValue: status) ?? CounterStatusEnum.none, focusedDurationInt: focusedDurationInt, restingDurationInt: restingDurationInt)
                    
                    //                (NSApplication.shared.delegate as! AppDelegate).statusItem.menu = Utility.getStatusBarMenus(counterStatusEnum: CounterStatusEnum(rawValue: status))
                }
            } else {
                // Fallback on earlier versions
            }
            break;
        case "openSetting":
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appSettings, completionHandler: { (success) in
                        result("{\"success\": true, \"data\": \(String(success))}");
                    })
                }
            }
            break;
        case "isNotificationEnabled":
            Utility.isNotificationEnabled(cb: {(res:Bool)->Void in
                //                NSLog("", result);
                result("{\"success\": true, \"data\": \(String(res))}");
            }
            );
            break;
        case "cancelAllPendingNotification":
            Utility.cancelAllPendingNotification();
            result("{\"success\": true, \"data\": \"\"}");
            break;
        case "pushCounterNotification":
            let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
            let content: String = (call.arguments as! [[String: Any]])[0]["content"] as! String;
            let delay: Int = (call.arguments as! [[String: Any]])[0]["delay"] as! Int;
            let id: String = (call.arguments as! [[String: Any]])[0]["id"] as! String;
            let extendsParams: String = (call.arguments as! [[String: Any]])[0]["extendsParams"] as! String;
            if #available(iOS 10.0, *){
                Utility.showLocalNotificationWithDelay(delay: delay, title: title, body: content, userInfo: ["id": "id66", "articleId": 999], action: id);
            }
            break;
        case "cancelPushCounterNotification":
            let id: String = (call.arguments as! [[String: Any]])[0]["id"] as! String;
            if #available(iOS 10.0, *){
                Utility.cancelNotificationWithAction(action: id);
            }
            break;
        case "getAliyunDeviceId":
            result(Params.deviceId);
            break;
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func navigateToTimelineViewController() {
        // 获取当前的顶层控制器
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // 创建一个TimelineViewController实例
            if #available(iOS 15.0, *) {
                let timelineViewController = UINavigationController(rootViewController: TimelineListViewController())
                // 在当前的顶层控制器上推送TimelineViewController
                topController.present(timelineViewController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            };
            
        }
    }
    //
    //    @available(iOS 15.0, *)
    //    func navigateToTimelineViewController(controller: UINavigationController) {
    //        // 获取当前的顶层控制器
    //        if var topController = UIApplication.shared.keyWindow?.rootViewController {
    //            while let presentedViewController = topController.presentedViewController {
    //                topController = presentedViewController
    //            }
    //
    //            // 创建一个TimelineViewController实例
    //
    //
    //            // 检查topController是否是UINavigationController
    //            if let navigationController = topController as? UINavigationController {
    //                // 在当前的顶层控制器上推送TimelineViewController
    //                navigationController.pushViewController(controller, animated: true)
    //            } else {
    //                print("Cannot push. Top controller is not a UINavigationController.")
    //            }
    //        }
    //    }
    
    //
    //
}

