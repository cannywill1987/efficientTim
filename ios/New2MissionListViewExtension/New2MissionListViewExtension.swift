//
//  New2MissionListViewExtension.swift
//  New2MissionListViewExtension
//
//  Created by 林智彬 on 2024/11/13.
//

import WidgetKit
import SwiftUI
import AppIntents

// TimerManager: 管理计时器的状态和数据
struct TimerManager {
    static var objectID: String = "";
}

/**得到当前秒单位时间戳**/
func getCurrentTimeStampBySeconds() -> Int{
    let timeInterval: TimeInterval = Date().timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return timeStamp * 1000;
}

// TimerIntent: 用于处理计时器操作的AppIntent，支持启动、暂停、重置等操作
struct TimerIntent: AppIntent {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryDataMissionListView : Data = Data()
    
    init() {
        
    }
    
    static var title: LocalizedStringResource = "Toggle Mission State"
    
    @Parameter(title: "Mission ID")
    var missionID: String?
    init(missionID: String) {
        self.missionID = missionID
    }
    
    func perform() async throws -> some IntentResult {
//        Task {
            guard var missionDataMissionListView = try?
                    JSONDecoder().decode(MissionData.self, from: primaryDataMissionListView) else {
                return .result()
            }
        var missionID = self.missionID;
            var missionModel: MissionModel?;
            if let index = missionDataMissionListView.listMissionModel.firstIndex(where: { $0.objectId == missionID }) {
                missionDataMissionListView.listMissionModel[index].isFinished = !(missionDataMissionListView.listMissionModel[index].isFinished ?? false)
                missionModel = missionDataMissionListView.listMissionModel[index]
            }
            var res = !(missionModel?.isFinished ?? false);
            if let responseData:[String: Any]? = await NetworkRequest.shared.startRequestWithPost(pairParameters: ["objectId":missionModel?.objectId ?? "", "isFinished": !(missionModel?.isFinished ?? false)], url: Apis.updateMissionModelOfFinished) {
                do {
                    if responseData != nil && (responseData!["success"] as! Bool){
                        let missionDataToEncode = missionDataMissionListView
                        guard let data = try? JSONEncoder().encode(missionDataToEncode) else {
                            return .result()
                        }
                        primaryDataMissionListView = data //类似存储在 shareprefrerence
                        
                        @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: Params.groupName)) var primaryDataQuadrant : Data = Data()
                        guard var storeDataQuadrant = try?
                                JSONDecoder().decode(StoreData.self, from: primaryDataQuadrant) else {
                            return .result()
                        }
                        var missionModelQuadrant: MissionModel?;
                        if let index = storeDataQuadrant.missionListMissionModel1?.firstIndex(where: { $0.objectId == self.missionID }) {
                            storeDataQuadrant.missionListMissionModel1![index].isFinished = !(storeDataQuadrant.missionListMissionModel1?[index].isFinished ?? false)
                            missionModelQuadrant = storeDataQuadrant.missionListMissionModel1?[index]
                        }
                        if let index = storeDataQuadrant.missionListMissionModel2?.firstIndex(where: { $0.objectId == self.missionID }) {
                            storeDataQuadrant.missionListMissionModel2![index].isFinished = !(storeDataQuadrant.missionListMissionModel2?[index].isFinished ?? false)
                            missionModelQuadrant = storeDataQuadrant.missionListMissionModel2?[index]
                        }
                        if let index = storeDataQuadrant.missionListMissionModel3?.firstIndex(where: { $0.objectId == self.missionID }) {
                            storeDataQuadrant.missionListMissionModel3![index].isFinished = !(storeDataQuadrant.missionListMissionModel3?[index].isFinished ?? false)
                            missionModelQuadrant = storeDataQuadrant.missionListMissionModel3?[index]
                        }
                        if let index = storeDataQuadrant.missionListMissionModel4?.firstIndex(where: { $0.objectId == self.missionID }) {
                            storeDataQuadrant.missionListMissionModel4![index].isFinished = !(storeDataQuadrant.missionListMissionModel4?[index].isFinished ?? false)
                            missionModelQuadrant = storeDataQuadrant.missionListMissionModel4?[index]
                        }
                        missionModelQuadrant!.isFinished = (missionModelQuadrant?.isFinished ?? false);
                        let storeDataToEncode = storeDataQuadrant
                        guard let data = try? JSONEncoder().encode(storeDataToEncode) else {
                            return .result()
                        }
                        primaryDataQuadrant = data //类似存储在 shareprefrerence
                        
                        
                        print("请求成功")
                    } else {
                        print("请求失败")
                    }
                } catch {
                    print("JSON 解析失败: \(error)")
                }
            }
            WidgetCenter.shared.reloadAllTimelines();
//        }
        
        TimerManager.objectID = self.missionID ?? ""
        
        return .result()
    }
}


// TimerAction: 定义计时器可执行的各种操作
enum TimerAction: String, AppEnum {
    case start = "Start" // 启动计时器
    case pause = "Pause" // 暂停计时器
    case reset = "Reset" // 重置计时器
    case addMinute = "AddMinute" // 增加一分钟
    case subtractMinute = "SubtractMinute" // 减少一分钟
    case toggleCountdown = "ToggleCountdown" // 切换倒计时/正计时
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Timer Action" // 定义枚举的显示类型
    }

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .start: "Start", // 启动操作的显示名
            .pause: "Pause", // 暂停操作的显示名
            .reset: "Reset", // 重置操作的显示名
            .addMinute: "Add 1 Minute", // 增加一分钟的显示名
            .subtractMinute: "Subtract 1 Minute", // 减少一分钟的显示名
            .toggleCountdown: "Toggle Countdown/Countup" // 切换倒计时/正计时的显示名
        ]
    }
}


struct Provider: TimelineProvider {
    // Access stored primary data for the widget
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryDataMissionListView : Data = Data()
    // Access additional stored data for the widget (QuadrantWidget)
    
    // Placeholder view used to render a snapshot of the widget during loading or preview in WidgetKit
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
    }
    
    // Create a snapshot of the widget to be displayed when the widget is loading or previewing
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // Attempt to decode stored data into MissionData; if unsuccessful, use an empty list
        guard let missionDataMissionListView = try?
                JSONDecoder().decode(MissionData.self, from: primaryDataMissionListView) else {
            let missionDataMissionListView = MissionData(listMissionModel: [])
            let entry: SimpleEntry = SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
            completion(entry)
            return
        }
        // Create a widget entry using the decoded mission data
        let entry: SimpleEntry = SimpleEntry(date: Date(), missionData: missionDataMissionListView)
        // Complete the snapshot process with the created entry
        
        
        
        completion(entry)
    }
    
    // Provide a timeline of entries for the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Attempt to decode stored data into MissionData; if unsuccessful, use an empty list
        guard var missionData = try?
                JSONDecoder().decode(MissionData.self, from: primaryDataMissionListView) else {
            let missionData = MissionData(listMissionModel: [])
            let entry: SimpleEntry = SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
            completion(Timeline(entries: [entry], policy: .atEnd))
            return
        }
        
        // Create a widget entry using the decoded mission data
        
        //        missionData.listMissionModel.forEach { mission in
        //            NetworkRequest.shared.console(pairParameters: ["id": mission.objectId, "title": mission.title, "isFinished": mission.isFinished])
        //        }
        
        missionData.listMissionModel = missionData.listMissionModel
            .sorted { (!($0.isFinished ?? false) ?? false) && ($1.isFinished ?? false) } // 按 isFinished 排序：未完成的放在前面，已完成的放在后面
        //            .forEach { mission in
        //                NetworkRequest.shared.console(pairParameters: ["id": mission.objectId, "title": mission.title, "isFinished": mission.isFinished])
        //            }
        
        let entry: SimpleEntry = SimpleEntry(date: Date(), missionData: missionData)
        
        // Create a timeline using the generated entry
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missionData: MissionData?
}

struct New2MissionListViewExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header section with today's title
            HStack {
                Color.yellow.frame(width: 4, height: 10).padding(.trailing, 2) // Yellow line as a visual marker
                //                Text("11111111\(TimerManager.title)")
                //                Text(entry.date, style: .time)
                Text("today".localizable()) // Localized label for "today"
                    .font(.system(size: 15, weight: .bold)) // Bold font for today's text
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255)) // Dark gray color for text
                Spacer() // Spacer to push content to the end of the line
            }.padding(.trailing, 4)
            
            // Display each mission item, up to the maximum allowed
            ForEach(entry.missionData?.listMissionModel.prefix(getMaxItems()) ?? [], id: \.self) { item in
                ZStack {
                    HStack(alignment: .center)  {
                        // Check or Uncheck Icon based on isFinished value
                        if #available(iOSApplicationExtension 17.0, *) {
                            Button(intent: TimerIntent(missionID: item.objectId ?? "")) {
                                Image((item.isFinished ?? false) ? "ic_check" : "ic_uncheck") // Load the appropriate image
                                    .resizable() // Make the image resizable
                                    .frame(width: 14, height: 14) // Set the size of the image
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: 14, maxHeight: 14)
                            .background(Color.clear)
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        
                        // Display the mission title
                        if #available(iOSApplicationExtension 17.0, *) {
                            Button(intent: TimerIntent(missionID: item.objectId ?? "")) {
                                Text("\(item.title ?? "")")
                                    .font(.system(size: 12)) // Font size for mission title
                                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255)) // Dark gray color for text
                                    .padding(.bottom, 2) // Padding below each item
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                        } else {
                            // Fallback on earlier versions
                        }
                        //                        Spacer() // Spacer to align elements in the row
                    }
                    
                }
                
            }
            Spacer() // Spacer to fill remaining vertical space
        }
        .padding(10)
        .background(Color.white) // Padding for the VStack and white background color
    }
    
    // Determine the number of items to display based on widget size
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall: // Small widget
            return 5
        case .systemMedium: // Medium widget
            return 5
        case .systemLarge: // Large widget
            //            return 13
            return 13
            //            return 6
        @unknown default: // Any unknown widget size
            return 6
        }
    }
}



struct New2MissionListViewExtension: Widget {
    let kind: String = "New2MissionListViewExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
                New2MissionListViewExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                New2MissionListViewExtensionEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("today".localizable())
        .description("")
    }
}
//
//#Preview(as: .systemSmall) {
//    New2MissionListViewExtension()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
