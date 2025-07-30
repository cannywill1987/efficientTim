//
//  StatsModel.swift
//  Runner
//
//  Created by 林智彬 on 2024/10/18.
//

import Foundation

class StatsModel: Codable {
    
    var title: String? // 任务标题
    var type: Int? = 0 // 0 missionModel的数据 1 missionModel 单个已经完成的 2 FolderModel
    var focusDuration: Int? = 0
    var tagNames: String? // 标签名称
    var category: String? // 分类 文件夹名称
    var color: Int?
    var icon: Int?
    var deviceId: String? // 设备ID
    var value: Double?
    var beginTime: Int? // 任务开始时间, 如果是type=1，及这个mission
    var finishTime: Int? // 任务完成时间
    var duration: Int? = 0
    var folderId: String? // folderModel的ObjectId
    var missionId: String? // folderModel的ObjectId
    var uid: String?
    
    init() {}
    
    // 从JSON解析
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        type = try container.decodeIfPresent(Int.self, forKey: .type)
        focusDuration = try container.decodeIfPresent(Int.self, forKey: .focusDuration)
        tagNames = try container.decodeIfPresent(String.self, forKey: .tagNames)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        color = try container.decodeIfPresent(Int.self, forKey: .color)
        icon = try container.decodeIfPresent(Int.self, forKey: .icon)
        deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId)
        value = try container.decodeIfPresent(Double.self, forKey: .value)
        beginTime = try container.decodeIfPresent(Int.self, forKey: .beginTime)
        finishTime = try container.decodeIfPresent(Int.self, forKey: .finishTime)
        folderId = try container.decodeIfPresent(String.self, forKey: .folderId)
        missionId = try container.decodeIfPresent(String.self, forKey: .missionId)
        uid = try container.decodeIfPresent(String.self, forKey: .uid)
        
        // 计算 duration
        if let finishTime = finishTime, let beginTime = beginTime, let value = value {
            self.duration = (finishTime - beginTime) > Int(value) ? Int(value) : (finishTime - beginTime)
        }
    }
    
    // 转换为JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(focusDuration, forKey: .focusDuration)
        try container.encodeIfPresent(tagNames, forKey: .tagNames)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(deviceId, forKey: .deviceId)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(beginTime, forKey: .beginTime)
        try container.encodeIfPresent(finishTime, forKey: .finishTime)
        try container.encodeIfPresent(folderId, forKey: .folderId)
        try container.encodeIfPresent(missionId, forKey: .missionId)
        try container.encodeIfPresent(uid, forKey: .uid)
    }
    
    // 定义属性的键
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case focusDuration = "focus_duration"
        case tagNames = "tagNames"
        case category
        case color
        case icon
        case deviceId = "device_id"
        case value
        case beginTime = "begin_time"
        case finishTime = "finish_time"
        case folderId = "folder_id"
        case missionId = "mission_id"
        case uid
    }
    
    // 获取参数
    func getParams() -> [String: Any] {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            return jsonDict ?? [:]
        } catch {
            print("Error converting model to dictionary: \(error)")
            return [:]
        }
    }
}

