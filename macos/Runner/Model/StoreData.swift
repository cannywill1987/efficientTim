//
//  PrimarryData.swift
//  Runner
//
//  Created by 林智彬 on 2023/6/8.
//

import Foundation

struct StoreData : Codable, Hashable {
//    var showText : String
    var title1 : String
    var title2 : String
    var title3 : String
    var title4 : String
    
    var missionList1 : [String]
    var missionList2 : [String]
    var missionList3 : [String]
    var missionList4 : [String]
    
    
    var missionListMissionModel1 : [MissionModel]?
    var missionListMissionModel2 : [MissionModel]?
    var missionListMissionModel3 : [MissionModel]?
    var missionListMissionModel4 : [MissionModel]?
}
