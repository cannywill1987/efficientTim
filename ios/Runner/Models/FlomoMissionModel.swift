//
//  MissionDatas.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/29.
//

import Foundation
import SwiftUI
import WidgetKit

@available(iOS 14.0, *)
struct FlomoMissionStoreData {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()
    let missionData : FlomoMissionData
    func encodeData() async {
        do {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            let missionData = try?
                    JSONDecoder().decode(FlomoMissionData.self, from: data)
            primaryData = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
        } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
            print("err \(error)")
        }
    }
}



struct FlomoMissionData : Codable, Hashable {
    var listFlomoMissionModelList: [FlomoMissionModelList]
    
}

struct FlomoMissionModelList: Codable, Hashable {
    var time: Int
    var listMissionModel: [FlomoMissionModel]
}



struct FlomoMissionModel: Codable, Hashable {
    let title: String?
    let color: Int?
    let isFinished: Bool?
    let percent: Double?;
    init(
        title: String?,
        color: Int?,
        isFinished: Bool?,
        percent: Double?
    ) {
        self.title = title
        self.color = color
        self.percent = percent
        self.isFinished = isFinished
    }
}
