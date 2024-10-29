//
//  PrimarryData.swift
//  Runner
//
//  Created by 林智彬 on 2023/6/8.
//

import SwiftUI
import WidgetKit

/**
 * 用来做数据存储
 *  
 */
@available(iOS 14.0, *)
struct PrimaryData {
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    let simpleData : StoreData
    func encodeData() async {
        do {
            guard let data = try? JSONEncoder().encode(simpleData) else {
                return
            }
            primaryData = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
        } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
            print("err \(error)")
        }
    }
}

@available(iOS 14.0, *)
struct MissionStoreData {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    let missionData : MissionData
    func encodeData() async {
        do {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            let missionData = try?
                    JSONDecoder().decode(MissionData.self, from: data) 
            primaryData = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
        } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
            print("err \(error)")
        }
    }
}

@available(iOS 14.0, *)
struct FlomoMissionStoreData {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
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
