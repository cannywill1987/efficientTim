//
//  MissionDatas.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/29.
//

import Foundation



struct FlomoMissionData : Codable, Hashable {
    var listFlomoMissionModelList: [FlomoMissionModelList]
}

struct FlomoMissionModelList: Codable, Hashable {
    var time: Int
    var listMissionModel: [FlomoMissionModel]
}



struct FlomoMissionModel: Codable, Hashable {
    let objectId: String?
    let title: String?
    let color: Int?
    var isFinished: Bool?
    var percent: Double?;
    init(
        objectId: String?,
        title: String?,
        color: Int?,
        isFinished: Bool?,
        percent: Double?
    ) {
        self.objectId = objectId
        self.title = title
        self.color = color
        self.percent = percent
        self.isFinished = isFinished
    }
}
