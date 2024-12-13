//
//  WQBMissionData.swift
//  Runner
//
//  Created by 林智彬 on 2023/10/18.
//

import Foundation
import SwiftUI
import WidgetKit

@available(macOS 11.0, *)
@available(iOS 14.0, *)
struct WQBMissionStoreData {
    @AppStorage("WQBMissionStoreDataNote1", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    @AppStorage("WQBMissionStoreDataNote2", store: UserDefaults(suiteName: Params.groupName)) var primaryData2 : Data = Data()
    @AppStorage("WQBMissionStoreDataNote3", store: UserDefaults(suiteName: Params.groupName)) var primaryData3 : Data = Data()
    @AppStorage("WQBMissionStoreDataNote4", store: UserDefaults(suiteName: Params.groupName)) var primaryData4 : Data = Data()
    @AppStorage("WQBMissionStoreDataNote5", store: UserDefaults(suiteName: Params.groupName)) var primaryData5 : Data = Data()
    @AppStorage("WQBMissionStoreDataNote6", store: UserDefaults(suiteName: Params.groupName)) var primaryData6 : Data = Data()
    @AppStorage("WQBMissionStoreDataNote7", store: UserDefaults(suiteName: Params.groupName)) var primaryData7 : Data = Data()
    let missionData : WQBMissionModel
    func encodeData() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
    func encodeData2() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData2 = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
    func encodeData3() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData3 = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
    func encodeData4() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData4 = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
    func encodeData5() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData5 = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
    func encodeData6() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData6 = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
    func encodeData7() async {
            guard let data = try? JSONEncoder().encode(missionData) else {
                return
            }
            primaryData7 = data //类似存储在 shareprefrerence
            WidgetCenter.shared.reloadAllTimelines()
    }
}


struct WQBMissionModel: Codable, Hashable {
    let key: String
    let content: String
    let subtitle: String
    let color: Int
    let priorityStatus: Int
    init(
        key: String,
        content: String,
        subtitle: String,
        priorityStatus: Int?,
        color: Int?
    ) {
        self.subtitle = subtitle
        self.key = key
        self.content = content
        self.color = color ?? 0xffff8800
        self.priorityStatus = priorityStatus ?? -1
    }
}
