//
//  TimelineItem.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/25.
//

import Foundation
import ManagedSettings
import DeviceActivity


@available(iOS 15.0, *)
class TimelineItem: ObservableObject, Codable, Hashable {
    @Published var id: String
    @Published var isOn: Bool
    @Published var isRunning: Bool
    @Published var startTime: DateComponents
    @Published var endTime: DateComponents
    @Published var applicationTokens: [ApplicationToken]
    @Published var activityCategoryTokens: [ActivityCategoryToken]
    @Published var webDomainTokens: [WebDomainToken]
//    @Published var deviceActivityName: DeviceActivityName
    @Published var weekend: [Bool]
    init(){
        self.id = ""
        self.isRunning = false
            self.isOn = true
            self.startTime = DateComponents(hour: 24,minute: 0)
            self.endTime = DateComponents(hour: 6,minute: 0)
            self.applicationTokens = []
            self.activityCategoryTokens = []
            self.webDomainTokens = []
            self.weekend = [true,true,true,true,true,true,true]
    }
    init(id: String?, isRunning: Bool?, isOn: Bool?, startTime: DateComponents?, endTime: DateComponents?, applicationTokens: [ApplicationToken]?, activityCategoryTokens: [ActivityCategoryToken]?, weekend: [Bool]?, webDomainTokens: [WebDomainToken]?) {
        self.isRunning = isRunning ?? false
        self.id = id ?? ""
        self.isOn = isOn ?? true
        self.startTime = startTime ?? DateComponents()
        self.endTime = endTime ?? DateComponents()
        self.applicationTokens = applicationTokens ?? []
        self.activityCategoryTokens = activityCategoryTokens ?? []
        self.webDomainTokens = webDomainTokens ?? []
//        self.deviceActivityName = deviceActivityName
        self.weekend = weekend ?? [false,false,false,false,false,false,false,]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        isOn = try container.decode(Bool.self, forKey: .isOn)
        isRunning = try container.decode(Bool.self, forKey: .isRunning)
        startTime = try container.decode(DateComponents.self, forKey: .startTime)
        endTime = try container.decode(DateComponents.self, forKey: .endTime)
        applicationTokens = try container.decode([ApplicationToken].self, forKey: .applicationTokens)
        activityCategoryTokens = try container.decode([ActivityCategoryToken].self, forKey: .activityCategoryTokens)
        webDomainTokens = try container.decode([WebDomainToken].self, forKey: .WebDomainTokens)
//        deviceActivityName = try container.decode([DeviceActivityName].self, forKey: .DeviceActivityName)
//        deviceActivityName = try container.decode([DeviceActivityName].self, forKey: .DeviceActivityName)
        weekend = try container.decode([Bool].self, forKey: .weekend)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isOn, forKey: .isOn) 
        try container.encode(isRunning, forKey: .isRunning)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(applicationTokens, forKey: .applicationTokens)
        try container.encode(activityCategoryTokens, forKey: .activityCategoryTokens)
        try container.encode(weekend, forKey: .weekend)
        try container.encode(webDomainTokens, forKey: .WebDomainTokens)
        
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TimelineItem, rhs: TimelineItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, isOn, startTime, endTime, applicationTokens, activityCategoryTokens, weekend, WebDomainTokens, DeviceActivityName, isRunning
    }
}
