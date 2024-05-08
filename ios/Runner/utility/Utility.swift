//
//  Utility.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/29.
//
import Cocoa
import Foundation

class Utility {
    /**
     *发送本地推送 app测底关闭也可以推送
     *if #available(iOS 10.0, *){
     *sentNo()
     *}
     */
    @available(iOS 10.0, *)
    static func sentNo() {
        //设置推送内容
           let content = UNMutableNotificationContent()
           content.title = "aaa.com"
           content.body = "哈哈哈"
           content.userInfo = ["id": "id66", "articleId": 999]
           content.sound = UNNotificationSound.default
           
           // 定义触发的时间组合
           var matchingDate = DateComponents()
   //        matchingDate.hour = 14
   //        matchingDate.minute = 24
           matchingDate.second = 0
           //设置通知触发器
           let trigger =  UNCalendarNotificationTrigger.init(dateMatching: matchingDate, repeats: true)
            
           //设置请求标识符
           let requestIdentifier = "com.WL.Test"
            
           //设置一个通知请求
           let request = UNNotificationRequest(identifier: requestIdentifier,
                                               content: content, trigger: trigger)
            
           //将通知请求添加到发送中心
           UNUserNotificationCenter.current().add(request) { error in
               if error == nil {
//                   VVLog("Time Interval Notification scheduled: \(requestIdentifier)")
               } else {
//                   VV Log("通知添加成功")
               }
           }
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
    
}
