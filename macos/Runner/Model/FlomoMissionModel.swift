//
//  MissionDatas.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/29.
//

import Foundation



struct FlomoMissionData : Codable, Hashable {
    var listFlomoMissionModelList: [FlomoMissionModelList]
//    var missionList : [String]
    
//    var missionList2 : [String]
//    var missionList3 : [String]
//    var missionList4 : [String]
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
