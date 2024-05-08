//
//  MissionStoreData.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/30.
//

import Foundation
import SwiftUI
import WidgetKit

//struct MissionData : Codable, Hashable {
////    var missionList : [String]
//    var listMissionModel: [MissionModel]
////    var missionList2 : [String]
////    var missionList3 : [String]
////    var missionList4 : [String]
//}
//
//struct MissionModel: Codable, Hashable {
////    let createdAt, updatedAt, _id, folder_id: String
//    let title: String?
//    let end_time: Int?
//    let background_url: String?
////    let indexSearchingStart, indexSearchingEnd: String?
////    let device_id, tagNames, tagIds, background_url: String
////    let no_tomotoes_finished, total_tomotoes, tomato_duration, order_index: Int
////    let end_time_before_finished, finish_time, alert_time, time_finished: Int?
////    let dateStatus, repetiveType, repetiveValue: Int
////    let repetiveWeekDay: [Int]
////    let uid: String
//    let isFinished, isDelayed: Bool?
////    let daily_start_time, daily_end_time: String?
////    let message: String?
//    let priorityStatus: Int?
//    
////    init() {
////
////    }
//    init(
////        createdAt: String,
////        updatedAt: String,
////        _id: String,
////        folder_id: String,
//        title: String?,
////        indexSearchingStart: String?,
////        indexSearchingEnd: String?,
////        device_id: String,
////        tagNames: String,
////        tagIds: String,
//        background_url: String?,
////        no_tomotoes_finished: Int,
////        total_tomotoes: Int,
////        tomato_duration: Int,
////        order_index: Int,
////        end_time_before_finished: Int?,
//        end_time: Int?,
////        finish_time: Int?,
////        alert_time: Int?,
////        time_finished: Int?,
////        dateStatus: Int,
//        priorityStatus: Int?,
////        daily_start_time: String?,
////        daily_end_time: String?,
////        message: String?,
//        isFinished: Bool?,
//        isDelayed: Bool?
////        repetiveType: Int,
////        repetiveValue: Int,
////        repetiveWeekDay: [Int],
////        uid: String
//    ) {
////        self.createdAt = createdAt
////        self.updatedAt = updatedAt
////        self._id = _id
////        self.folder_id = folder_id
//        self.title = title
////        self.indexSearchingStart = indexSearchingStart
////        self.indexSearchingEnd = indexSearchingEnd
////        self.device_id = device_id
////        self.tagNames = tagNames
////        self.tagIds = tagIds
//        self.background_url = background_url
////        self.no_tomotoes_finished = no_tomotoes_finished
////        self.total_tomotoes = total_tomotoes
////        self.tomato_duration = tomato_duration
////        self.order_index = order_index
////        self.end_time_before_finished = end_time_before_finished
//        self.end_time = end_time
////        self.finish_time = finish_time
////        self.alert_time = alert_time
////        self.time_finished = time_finished
////        self.dateStatus = dateStatus
//        self.priorityStatus = priorityStatus
////        self.daily_start_time = daily_start_time
////        self.daily_end_time = daily_end_time
////        self.message = message
//        self.isFinished = isFinished
//        self.isDelayed = isDelayed
////        self.repetiveType = repetiveType
////        self.repetiveValue = repetiveValue
////        self.repetiveWeekDay = repetiveWeekDay
////        self.uid = uid
//    }
//}


@available(iOS 14.0, *)
struct MissionStoreData {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()
    let missionData : MissionData
    func encodeData() async {
        do {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            let missionData = try?
                    JSONDecoder().decode(MissionData.self, from: data)

            
            //        guard let storeData = try?
            //                        JSONDecoder().decode(StoreData.self, from: data) else {
            //                    return
            //                }
            primaryData = data //类似存储在 shareprefrerence
            //            WidgetCenter.shared.reloadTimelines(ofKind: <#T##String#>, )
            WidgetCenter.shared.reloadAllTimelines()
        } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
            print("err \(error)")
        }
    }
}
