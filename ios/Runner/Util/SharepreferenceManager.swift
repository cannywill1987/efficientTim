//
//  SharepreferenceManager.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/23.
//

import Foundation
import ManagedSettings
import DeviceActivity

// @available(iOS 15.0, *)
// struct TimelineItem: Codable, Hashable {
//     var id: String?
//     var isOn: Bool
//     var startTime: TimeInterval
//     var endTime: TimeInterval
//     var applicationTokens: [ApplicationToken]
//     var activityCategoryTokens: [ActivityCategoryToken]
//     var weekend: [Bool]
// }


class SharepreferenceManager{
    static let instance:SharepreferenceManager = SharepreferenceManager()
    //    var flutterViewController: FlutterViewController?;
    //
    static func shareInstance() -> SharepreferenceManager {
        return instance;
    }
    
    init () {}
    
    // 增加或修改
    func setKeys(value: [String], forKey key: String) {
        UserDefaults(suiteName: Params.groupName)?.set(value, forKey: key)
    }
    
    // 查询
    func getKeys(forKey key: String) -> [String]? {
        return UserDefaults(suiteName: Params.groupName)?.array(forKey: key) as? [String]
    }
    
    // 删除
    func removeKeys(forKey key: String) {
        UserDefaults(suiteName: Params.groupName)?.removeObject(forKey: key)
    }
    
    // 增加
    @available(iOS 15.0, *)
    func addTimelineItem(TimelineItem: TimelineItem, forKey key: String) {
        var TimelineItems = getTimelineItems(forKey: key) ?? []
        TimelineItems.append(TimelineItem)
        setTimelineItems(TimelineItems: TimelineItems, forKey: key)
    }
    
    // 根据id修改
    @available(iOS 15.0, *)
    func updateTimelineItem(id: String, newTimelineItem: TimelineItem, forKey key: String) {
        var TimelineItems = getTimelineItems(forKey: key) ?? []
        if let index = TimelineItems.firstIndex(where: { $0.id == id }) {
            TimelineItems[index] = newTimelineItem
            setTimelineItems(TimelineItems: TimelineItems, forKey: key)
        }
    }
    
    // 删除
    @available(iOS 15.0, *)
    func removeTimelineItem(id: String, forKey key: String) {
        var TimelineItems = getTimelineItems(forKey: key) ?? []
        TimelineItems.removeAll(where: { $0.id == id })
        setTimelineItems(TimelineItems: TimelineItems, forKey: key)
    }

    // Check if id exists
    @available(iOS 15.0, *)
    func timelineItemIdExists(id: String, forKey key: String) -> Bool {
        let timelineItems = getTimelineItems(forKey: key) ?? []
        return timelineItems.contains(where: { $0.id == id })
    }
    
    
    // 查询
    @available(iOS 15.0, *)
    func getTimelineItems(forKey key: String) -> [TimelineItem]? {
        guard let data = UserDefaults(suiteName: Params.groupName)?.data(forKey: key) else { return nil }
        if #available(iOS 15.0, *) {
            return try? JSONDecoder().decode([TimelineItem].self, from: data)
        } else {
            // Fallback on earlier versions
        }
        return []
    }
    
    @available(iOS 15.0, *)
    func getTimelineItem(id: String, forKey key: String) -> TimelineItem? {
        let userDefault:UserDefaults? = UserDefaults(suiteName: Params.groupName);
//        UserDefaults.standard.addSuite(named: Params.groupName)
        guard let data = userDefault?.data(forKey: key) else { return nil }
        if #available(iOS 15.0, *) {
            guard let timelineItems = try? JSONDecoder().decode([TimelineItem].self, from: data)  else { return nil }
            return timelineItems.first(where: { $0.id == id })
        } else {
            // Fallback on earlier versions
        }
        return nil;
//        guard let timelineItems = getTimelineItems(forKey: key) else { return nil }
        
    }
    
    // 设置
    @available(iOS 15.0, *)
    func setTimelineItems(TimelineItems: [TimelineItem], forKey key: String) {
        if let data = try? JSONEncoder().encode(TimelineItems) {
            UserDefaults(suiteName: Params.groupName)?.set(data, forKey: key)
        }
    }
    
    
}

