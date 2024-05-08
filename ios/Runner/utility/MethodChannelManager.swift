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
    
    static func shareInstance(flutterViewController: FlutterViewController?) -> MethodChannelManager {
        if (instance.channel == nil) {
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
        switch call.method {
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
}

