//
//  CustomStatusBarWidget.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/28.
//

import Cocoa

class CustomStatusBarWidget: NSView {
    @IBOutlet var view: NSView!
    @IBOutlet weak var time: NSTextField!
    @IBOutlet weak var image: NSImageView!
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
        Bundle.main.loadNibNamed(NSNib.Name("CustomStatusBarWidget"), owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
}
