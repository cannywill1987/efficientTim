//
//  Extensions.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/28.
//
import Cocoa
import Foundation

import Cocoa

protocol NibLoadable {
    static var nibName: String? { get }
    static func createFromNib(in bundle: Bundle) -> Self?
}

//用不上 不懂为啥i返回的是Nil
extension NibLoadable where Self: NSView {
    
    static var nibName: String? {
        return String(describing: Self.self)
    }
    
    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self? {
        guard let nibName = nibName else { return nil }
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        for i in topLevelArray! {
            if i is NSView {
                return i as? Self;
            }
            print(i is NSView);
        }
        return nil
    }
}

extension String {
    func emojiToImage(with fontSize: CGFloat)-> NSImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        let image = NSImage(size: size, flipped: true, drawingHandler: { dstRect in
            // explicitly set center, layer anchor point is already (0.5, 0.5)
            let textOrigin = CGPoint (x: 0, y: 0)
            // create new dstRect to include new origin
            let rect = CGRect(origin: textOrigin, size: dstRect.size)
            let textFont = NSFont.systemFont(ofSize: fontSize)
            let attributes = [NSAttributedString.Key.font:textFont,]
            self.draw(in: rect, withAttributes: attributes)
            return true
        })
        return image
    }
}

extension NSStatusBarButton{
    func changeStatus(emojiString: String) {
        guard let statusBtnImage = emojiString.emojiToImage(with: 18) else {
            return
        }
        self.title = "title"
        self.image = statusBtnImage
    }
}
extension NSEvent {
    var isRightClick: Bool {
        let isRightClickEvent = NSApp.currentEvent?.type == NSEvent.EventType.rightMouseDown
        return isRightClickEvent
    }
}
