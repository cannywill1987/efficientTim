//
//  WindowUtility.swift
//  Runner
//
//  Created by 林智彬 on 2022/2/6.
//
import Cocoa
import FlutterMacOS
import Foundation
var _appWindow: NSWindow? = nil;
var _insideDoWhenWindowReady: Bool? = false;
var _windowCanBeShown: Bool = false;

class WindowUtility {
    
    static func setInsideDoWhenWindowReady(value: Bool){
        _insideDoWhenWindowReady = value;
    }

    static func setAppWindow(value: NSWindow){
        _appWindow = value;
    }

//    getAppWindow() -> NSWindow{
//        if (NULL == _appWindow) {
////            NSApplication.windo
//            _appWindow = [NSApp windows][0];
//        }
//        return _appWindow;
//    }

    static func windowCanBeShown() -> Bool{
        return _windowCanBeShown;
    }

    static func setWindowCanBeShown(value: Bool){
        _windowCanBeShown = value;
    }

    static func showWindow(window: NSWindow) {
        window.makeKeyAndOrderFront(nil);
//        dispatch_async(dispatch_get_main_queue(), ^{
//           // [window setIsVisible:TRUE]
//            [window makeKeyAndOrderFront:nil];
//        });
    }

    static func hideWindow(window: NSWindow) {
        window.setIsVisible(false);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [window setIsVisible:FALSE];
//        });
    }

    static func moveWindow(window: NSWindow) {
        window.performDrag(with: window.currentEvent!);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [window performWindowDragWithEvent:[window currentEvent]];
//        });
    }

    static func setSize(window: NSWindow, width: Int, height: Int){
        var frame: NSRect = window.frame;
        frame.size.width = CGFloat(width);
        frame.size.height = CGFloat(height);
        window.setFrame(frame, display: true, animate: false);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [window setFrame:frame display:true];
//        });
    }

    static func setMinSize(window: NSWindow, width: Int, height: Int){
        let minSize: NSSize = NSSize.init(width: width, height: height);
//        minSize.width = CGFloat(width);
//        minSize.height = CGFloat(height);
        
        window.minSize = minSize;
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    }

    static func setMaxSize(window: NSWindow, width: Int, height: Int){
        let maxSize:NSSize = NSSize.init(width: width, height: height);
//        maxSize.width = CGFloat(width);
//        maxSize.height = CGFloat(height);
        window.maxSize = maxSize;
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    }

//    getScreenInfoForWindow(window: NSWindow, screenInfo: BDWScreenInfo) -> Bool{
//        let screen: NSScreen = window.screen!;
//        let workingScreenRect: NSRect = screen.visibleFrame;
//        auto fullScreenRect = screen.frame;
//        auto menuBarHeight = fullScreenRect.size.height - workingScreenRect.size.height - workingScreenRect.origin.y;
//
//        BDWRect* workingRect = screenInfo->workingRect;
//        BDWRect* fullRect = screenInfo->fullRect;
//        workingRect->top = menuBarHeight;
//        workingRect->left = workingScreenRect.origin.x;
//        workingRect->bottom = workingRect->top + workingScreenRect.size.height;
//        workingRect->right = workingRect->left + workingScreenRect.size.width;
//
//        fullRect->left = fullScreenRect.origin.x;
//        fullRect->right = fullRect->left + fullScreenRect.size.width;
//        fullRect->top = fullScreenRect.origin.y;
//        fullRect->bottom = fullRect->top + fullScreenRect.size.height;
//        return BDW_SUCCESS;
//    }

//    BDWStatus setPositionForWindow(NSWindow* window, BDWOffset* offset){
//        auto block = ^{
//            NSPoint position;
//            auto screen = [window screen];
//            auto fullScreenRect = [screen visibleFrame];
//            position.x = offset->x;
//            position.y = fullScreenRect.origin.y + fullScreenRect.size.height - offset->y;
//            [window setFrameTopLeftPoint:position];
//        };
//
//        if ([NSThread isMainThread]) {
//            block();
//        } else {
//            dispatch_async(dispatch_get_main_queue(), block);
//        }
//        return BDW_SUCCESS;
//    }
//    BDWStatus setRectForWindow(NSWindow* window, BDWRect* rect){
//
//        auto block = ^ {
//            NSScreen* screen = [window screen];
//            NSRect fullScreenRect = [screen frame];
//            NSRect frame;
//            frame.size.width = rect->right - rect->left;
//            frame.size.height = rect->bottom - rect->top;
//            frame.origin.x = fullScreenRect.origin.x + rect->left;
//            frame.origin.y = fullScreenRect.origin.y + fullScreenRect.size.height - rect->bottom;
//            [window setFrame:frame display:TRUE];
//        };
//
//        if ([NSThread isMainThread]) {
//            block();
//        } else {
//            dispatch_async(dispatch_get_main_queue(), block);
//        }
//        return BDW_SUCCESS;
//    }

//    getRectForWindow(window: NSWindow, rect: BDWRect) -> Bool{
//        let screen: NSScreen = window.screen;
//        let workingScreenRect: NSRect = screen.visibleFrame;
//        NSRect frame = [window frame];
//        rect->left = frame.origin.x;
//        auto frameTop = frame.origin.y + frame.size.height;
//        auto workingScreenTop = workingScreenRect.origin.y + workingScreenRect.size.height;
//        rect->top = workingScreenTop - frameTop;
//        rect->right = rect->left + frame.size.width;
//        rect->bottom = rect->top + frame.size.height;
//        return true;
//    }

    static func isWindowMaximized(window: NSWindow) -> Bool{
        return window.isZoomed;
    }

    static func isWindowVisible(window: NSWindow) -> Bool{
        return window.isVisible;
    }

    static func maximizeOrRestoreWindow(window: NSWindow){
        window.zoom(nil);
//        [window zoom:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    }

    static func maximizeWindow(window: NSWindow){
        let screen: NSScreen = window.screen!;
        window.setFrame(screen.visibleFrame, display: true);
//        [window setFrame:[screen visibleFrame] display:true animate:true];
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    }

    static func minimizeWindow(window: NSWindow){
        window.setIsMiniaturized(false); //todo不确定
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    }

    static func closeWindow(window: NSWindow){
        window.close();
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    }

    static func setWindowTitle(window: NSWindow, title: String){
        window.title = title;
//        NSString *_title = [NSString stringWithUTF8String:title];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
    }

    static func getTitleBarHeight(window: NSWindow) -> Double{
        let windowFrameHeight: CGFloat = window.contentView!.frame.size.height;
        let contentLayoutHeight: CGFloat = window.contentLayoutRect.size.height;
        return windowFrameHeight - contentLayoutHeight;
    }

}
