////
////  MethodChannelManager.swift
////  Runner
////
////  Created by 林智彬 on 2022/1/29.
////
//
import Foundation
import FlutterMacOS

class MethodChannelManager {
    static let instance:MethodChannelManager = MethodChannelManager()
    var channel:FlutterMethodChannel?;
    var customStatusBarWidget:CustomStatusBarWidget?
    var curCounterStatus: Int?
    var window: MainFlutterWindow?;
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
            case "init":
                let env:Bool = (call.arguments as! [[String: Any]])[0]["env"] as! Bool;
//                let env:Bool = item["env"] as! Bool;
                Params.isDebug = !env;
                if(Params.isDebug) {
//                    WindowUtility.setMinSize(window: window!, width: 300, height: 150);
                } else {
//                    if(window != nil) {
//                        WindowUtility.setMinSize(window: window!, width: 1000, height: 800);
//                    }
                }
                print("11111");
                break;
            case "storeMissionDataList":
//                let s:String = call.arguments as! String;
//                let title: String = (call.arguments as! [[String: Any]])[0]["title"] as! String;
//                print(call.arguments[0])
                let title1 = (call.arguments as! [[String: Any]])[0]["title"] as! String;
                let title2 = (call.arguments as! [[String: Any]])[1]["title"] as! String;
                let title3 = (call.arguments as! [[String: Any]])[2]["title"] as! String;
                let title4 = (call.arguments as! [[String: Any]])[3]["title"] as! String;
                
                let array1:NSArray = (call.arguments as! [[String: Any]])[0]["datas"] as! NSArray;
                let array2:NSArray = (call.arguments as! [[String: Any]])[1]["datas"] as! NSArray;
                let array3:NSArray = (call.arguments as! [[String: Any]])[2]["datas"] as! NSArray;
                let array4:NSArray = (call.arguments as! [[String: Any]])[3]["datas"] as! NSArray;
                
//                let title1 = (call.arguments as! [[String: Any]])[0]["datas"] as! NSArray;
//                (call.arguments as! [[String: Any]])[3]["datas"]
//                (call.arguments as! [[String: Any]])[0]["title"] as! String
                
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

