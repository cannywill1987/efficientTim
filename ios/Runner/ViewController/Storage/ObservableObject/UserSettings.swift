//
//  UserSettings.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/23.
//

import Foundation
//import ManagedSettings

@available(iOS 15.0, *)
class UserSettings: ObservableObject {
//    var key: String
    
    @Published var datasTimelineItem: [TimelineItem] {
        willSet {
//            SharepreferenceManager.shareInstance().setTimelineItems(TimelineItems: datasTimelineItem, forKey: SharePreferenceKey.TimelineKey)
//            UserDefaults.standard.set(try? PropertyListEncoder().encode(applicationTokens), forKey: "applicationTokens"+key)
        }
        didSet {
//            SharepreferenceManager.shareInstance().setTimelineItems(TimelineItems: datasTimelineItem, forKey: SharePreferenceKey.TimelineKey)
//            UserDefaults.standard.set(try? PropertyListEncoder().encode(applicationTokens), forKey: "applicationTokens"+key)
        }
    }
    
//    @Published var applicationTokens: [ApplicationToken] {
//        didSet {
//            UserDefaults.standard.set(try? PropertyListEncoder().encode(applicationTokens), forKey: "applicationTokens"+key)
//        }
//    }
//
//    @Published var categoriesToken: [ActivityCategoryToken] {
//        didSet {
//            UserDefaults.standard.set(try? PropertyListEncoder().encode(categoriesToken), forKey: "categoriesToken"+key)
//        }
//    }
    
    init() {
        datasTimelineItem = SharepreferenceManager.shareInstance().getTimelineItems(forKey: SharePreferenceKey.TimelineKey) ?? []
        print("datasTimelineItem \(datasTimelineItem)")
        print("1111111")
//        if let data = UserDefaults.standard.value(forKey:"applicationTokens" + key) as? Data {
//            let tokens = try? PropertyListDecoder().decode(Array<ApplicationToken>.self, from: data)
//            self.applicationTokens = tokens ?? []
//        } else {
//            self.applicationTokens = []
//        }
    }
    
//    init(key: String) {
//        self.key = key
//        if let data = UserDefaults.standard.value(forKey:"applicationTokens" + key) as? Data {
//            let tokens = try? PropertyListDecoder().decode(Array<ApplicationToken>.self, from: data)
//            self.applicationTokens = tokens ?? []
//        } else {
//            self.applicationTokens = []
//        }
//        if let data = UserDefaults.standard.value(forKey:"categoriesToken" + key) as? Data {
//            let tokens = try? PropertyListDecoder().decode(Array<ActivityCategoryToken>.self, from: data)
//            self.categoriesToken = tokens ?? []
//        } else {
//            self.categoriesToken = []
//        }
//    }
}
