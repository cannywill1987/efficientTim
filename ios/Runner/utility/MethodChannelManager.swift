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
    
    /// 功能：构造公共桥接器统一返回结构，后续新增 action 时优先在这里分发。
    private func buildCommonBridgeResult(_ call: FlutterMethodCall, platform: String) -> [String: Any] {
        let args = firstMapArgument(call)
        return [
            "success": true,
            "platform": platform,
            "action": args["action"] as? String ?? "",
            "data": args["params"] ?? [:]
        ]
    }

    /// 功能：兼容 Flutter 侧常用的 List<Map> 入参，也允许未来直接传 Map。
    private func firstMapArgument(_ call: FlutterMethodCall) -> [String: Any] {
        if let list = call.arguments as? [[String: Any]], let first = list.first {
            return first
        }
        if let map = call.arguments as? [String: Any] {
            return map
        }
        return [:]
    }

    public func handleMethodChannel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "commonBridge":
            result(buildCommonBridgeResult(call, platform: "ios"))
            break
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
