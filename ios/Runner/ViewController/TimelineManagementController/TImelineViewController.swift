//
//  TImelineViewController.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/22.
//

import Foundation
import SwiftUI // 引入SwiftUI
import DeviceActivity
import ManagedSettings
import FamilyControls

@available(iOS 16.0, *)
class TimelineViewController: UIViewController {
    
    //    private var cancellables = Set<<#Element: Hashable#>>()
    
    // Used to encode codable to UserDefaults
    private let encoder = PropertyListEncoder()
    
    // Used to decode codable from UserDefaults
    private let decoder = PropertyListDecoder()
    
    private let userDefaultsKey = "ScreenTimeSelection"
    var timelineItem:TimelineItem?;
    var createEditEnum:CreateEditEnum = CreateEditEnum.create;
    private var model:MyModel? = nil;
    // 创建你的SwiftUI视图
    //    let swiftUIView = Text("Hello, SwiftUI!")
    
    init(timelineItem: TimelineItem?, createEditEnum: CreateEditEnum, model: MyModel? = nil) {
        self.timelineItem = timelineItem
        self.createEditEnum = createEditEnum ?? CreateEditEnum.create
        self.model = model
        super.init(nibName: nil, bundle: nil) // Call to super.init
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the initial selection
        let familyActivitySelection: FamilyActivitySelection? = savedSelection() ?? FamilyActivitySelection();
        if model == nil {
            model = MyModel.shared
        }
        model!.activitySelection = familyActivitySelection ?? FamilyActivitySelection()
        if(self.timelineItem == nil) {
            self.timelineItem = TimelineItem()
        }
        // 创建一个UIHostingController实例
        if #available(iOS 15.2, *) {
            let createEditEnumBinding = Binding<CreateEditEnum>(
                get: { self.createEditEnum },
                set: { self.createEditEnum = $0 }
            )
            let hostingController = UIHostingController(rootView: UITimelineCreateView(createEditEnum: createEditEnumBinding, timelineItem: self.timelineItem!))
            
            
            // 添加hostingController作为子视图控制器
            addChild(hostingController)
            
            // 确保SwiftUI视图占据整个屏幕
            hostingController.view.frame = self.view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // 将SwiftUI视图添加到视图层次结构中
            view.addSubview(hostingController.view)
            // 完成添加子视图控制器的过程
            hostingController.didMove(toParent: self)
            if #available(iOS 16.0, *) {
                Task {
                    do {
                        await Utility.requestAuthorization()
                    } catch {
                        print("Fetched err: \(error).")
                    }
                }
                
            } else {
                // Fallback on earlier versions
            };
        } else {
            // Fallback on earlier versions
        }
        if model == nil {
            model = MyModel.shared
        }
        // Set the initial selection
        model?.activitySelection = savedSelection() ?? FamilyActivitySelection()
        
//        model?.$activitySelection.sink { selection in
//            self.saveSelection(selection: selection)
//        }
//                       .store(in: &cancellables)
    }
    
    
    @available(iOS 16.0, *)
    func saveSelection(selection: FamilyActivitySelection) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
    }
    
    @available(iOS 16.0, *)
    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        
        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }
        
        return try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
    }
}
