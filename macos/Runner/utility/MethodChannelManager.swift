////
////  MethodChannelManager.swift
////  Runner
////
////  Created by 林智彬 on 2022/1/29.
////
//
import Foundation
import FlutterMacOS
import WidgetKit
import SwiftUI
class MethodChannelManager {
    static let instance:MethodChannelManager = MethodChannelManager()
    var channel:FlutterMethodChannel?;
    var customStatusBarWidget:CustomStatusBarWidget?
    var curCounterStatus: Int?
    var window: MainFlutterWindow?;
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: "S4CLCWPCGH.com.timespeed.timehello")) var primaryData2 : Data = Data()
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
                let storeData = StoreData(title1: title1 , title2: title2 , title3: title3 , title4: title4 , missionList1: Utility.getMissionModelTitle(array: array1), missionList2: Utility.getMissionModelTitle(array: array2), missionList3: Utility.getMissionModelTitle(array: array3), missionList4: Utility.getMissionModelTitle(array: array4));
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
                        let tenDaysInSeconds = 50 * 24 * 60 * 60 * 1000
                        if (time) > (currentTime * 1000 - tenDaysInSeconds) && (time) < (currentTime * 1000 + tenDaysInSeconds) {
                            
                            let date = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                            print("date:\(date) count:\(count)")
                            if count > 0 {
                                for index2 in 0...count - 1 {
                                    let item2 = datas[index2]
                                    let title:String = item2["title"] as? String ?? "";
                                    
                                    //                            let percent:Double = item2["percent"] as? Double ?? 0;
                                    let color: Int = item2["color"] as? Int ?? 0xffff8800 - 0xff000000;
                                    let isFinished: Bool = item2["isFinished"] as? Bool ?? false;
                                    
                                    //                        let isDelayed:Bool = item["isDelayed"] as! Bool;
                                    //                                                let isFinished:Bool = item["isFinished"] as! Bool;
                                    //                                                let title:String = item["title"] as! String;
                                    let background_url:String? = item["background_url"] as? String;
                                    let end_time:Int = item["end_time"] as? Int ?? 0;
                                    let priorityStatus:Int? = item["priorityStatus"] as? Int;
                                    let missionData = MissionModel(title: title, lunar: lunar, background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: false, color: color)
                                    
                                    
                                    listMissionModel.append(missionData)
                                }
                            }
                            listMissionModels.append(MissionModelList(time: time, lunar: lunar,listMissionModel: listMissionModel))
                        }
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
                                let title:String = item2["title"] as? String ?? "";
                                let percent:Double = item2["percent"] as? Double ?? 0;
                                let color: Int = item2["color"] as? Int ?? 0xffff8800 - 0xff000000;
                                let isFinished: Bool = item2["isFinished"] as? Bool ?? false;
                                listFlomoMissionModel.append(FlomoMissionModel(title: title, color: color, isFinished: isFinished, percent: percent))
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
                
            case "storeMissionList": //创建今天任务
                let list = (call.arguments as! [[String: Any]]);
//                if list.count == 7 {
                    var listMissionModels:[MissionModel] = [];
                    //                for index in 0...((call.arguments as AnyObject).length ?? 0) {
                    if list.count > 0 {
                        for index in 0...list.count - 1 {
                            let item = list[index]
                            
                            let isDelayed:Bool = item["isDelayed"] as! Bool;
                            let isFinished:Bool = item["isFinished"] as! Bool;
                            //                    let daily_end_time:Int = item["daily_end_time"] as! Int;
                            //                    let daily_start_time:Int = item["daily_start_time"] as! Int;
                            //                    let no_tomotoes_finished:Int = item["no_tomotoes_finished"] as! Int;
                            //                    let total_tomotoes:Int = item["total_tomotoes"] as! Int;
                            //                    let repetiveType:Int = item["repetiveType"] as! Int;
                            //                    let repetiveValue:Int = item["repetiveValue"] as! Int;
                            //                    let repetiveWeekDay:NSArray = item["repetiveWeekDay"] as! NSArray;
                            let title:String = item["title"] as! String;
                            let background_url:String? = item["background_url"] as? String;
                            //                    let device_id:String = item["device_id"] as! String;
                            let end_time:Int = item["end_time"] as! Int;
                            let priorityStatus:Int? = item["priorityStatus"] as? Int;
                            let color:Int? = item["color"] as? Int ?? 0xffff8800 - 0xff000000;
                            //                    let dateStatus:Int = item["dateStatus"] as! Int;
                            //                    let createdAt:String = item["createdAt"] as! String;
                            //                    let updatedAt:String = item["updatedAt"] as! String;
                            let missionData = MissionModel(title: title, lunar: "", background_url: background_url, end_time: end_time, priorityStatus: priorityStatus, isFinished: isFinished, isDelayed: isDelayed, color:color)
                            listMissionModels.append(missionData);
                            print("11111");
                        }
//                    }
                    if #available(iOS 14.0, *) {
                        let primaryData:MissionStoreData = MissionStoreData(missionData: MissionData(listMissionModel: listMissionModels))
                        Task {
                            await primaryData.encodeData();
//                            var missionData:MissionData?;
//                            do {
////                                missionData = try JSONDecoder().decode(MissionData.self, from: primaryData)
//                                missionData = try JSONDecoder().decode(MissionData.self, from: primaryData2)
//                            } catch {
//                                print("Could not write to file")
//                            }
                        }
                    } else {
                        // Fallback on earlier versions
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

