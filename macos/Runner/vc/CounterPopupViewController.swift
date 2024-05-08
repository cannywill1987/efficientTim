//
//  CounterPopupViewController.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/26.
//

import Cocoa

class CounterPopupViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.addSubview(self.changeStatusButton)
        self.setupContraints()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setupContraints(){
            NSLayoutConstraint.activate([
            self.changeStatusButton.centerXAnchor.constraint(equalTo:self.view.centerXAnchor),
            self.changeStatusButton.centerYAnchor.constraint(equalTo:self.view.centerYAnchor),
            ])
    }
    
    var changeStatusButton: NSButton = {
        let btn = NSButton(title: "Change To Random Emoji", target: self, action: #selector(changeStatusButton(_:)))
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
   
        
    @objc func changeStatusButton(_ sender: NSButton) {
        let emojis = ["@", "Ein","O"]
        let randomIndex = Int.random(in: 0..<emojis.count)
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            delegate.statusItem.button?.changeStatus(emojiString:emojis[randomIndex])
        }
    }

    
}
