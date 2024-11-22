import Cocoa
import FlutterMacOS
class MainFlutterWindow: NSWindow {
    var customStatusBarWidget:CustomStatusBarWidget!
    var curCounterStatus: Int!
    var gEventHandler: Any?
    var lEventHandler: Any?
    var appDelegate: AppDelegate!
    //状态栏
    var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength:Constant.widthStatusBar) //状态栏高度
    }()
    
    override func awakeFromNib() {
        NSLog("application start awakeFromNib")
        self.appDelegate = NSApplication.shared.delegate as! AppDelegate;
        let flutterViewController = FlutterViewController.init()
        appDelegate.flutterViewController = flutterViewController
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        let hasSetSize = UserDefaults.standard.bool(forKey: "hasSetWindowSize")
//        if !hasSetSize {
            WindowUtility.setSize(window: self, width: 1400, height: 1100);
            UserDefaults.standard.set(true, forKey: "hasSetWindowSize")
//        }
        if #available(macOS 11.0, *) {
            MethodChannelManager.shareInstance(flutterViewController: flutterViewController, window: self)
        } else {
            // Fallback on earlier versions
        }
        
        self.startLocalEventMoniter();
        self.startGlobalEventMoniter();
    }
    
    func startLocalEventMoniter() {
        NSEvent.addLocalMonitorForEvents(matching: [NSEvent.EventTypeMask.keyDown]) { [unowned self] (event) -> NSEvent? in
            print("keyCode \(event.keyCode)")
            if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.shift) { //ctrl+shift
                switch event.keyCode {
                case 1: //ctrl+shift+s
                    if #available(macOS 11.0, *) {
                        MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarStopBtn", arguments: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    break
                case 35: //ctrl+shift+p
                    if #available(macOS 11.0, *) {
                        MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarPauseBtn", arguments: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    break
                case 15: //ctrl+shift+p
                    if #available(macOS 11.0, *) {
                        MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarStartBtn", arguments: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    break
                case 2: //ctrl+shift+d
                    if #available(macOS 11.0, *) {
                        MethodChannelManager.shareInstance(flutterViewController: nil, window: nil).channel?.invokeMethod("handleStatusBarDoneBtn", arguments: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    break
                default:
                    break
                }
            } else if event.modifierFlags.contains(.command){
                if event.keyCode == 13 { //ctrl+w
                    NSApp.hide(_: true)
                    print("1111111111111")
                }
            }
            return event
        }
    }
    //    感觉没啥用
    func startGlobalEventMoniter() {
        NSEvent.addGlobalMonitorForEvents(
            matching: [NSEvent.EventTypeMask.keyDown], handler: {(event: NSEvent) in
                print(String(event.characters!) as Any)
                do {
                    print("keyCode \(event.keyCode)")
                    if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.shift) {
                        //                    if event.keyCode == event.keyCode.
                    }
                } catch {
                    print("Could not write to file")
                }
            }
        )
    }
    
}
