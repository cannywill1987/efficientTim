//
//  New2QuadrantWidget.swift
//  New2QuadrantWidget
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
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: Params.groupName)) var primaryDataQuadrant : Data = Data()
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
        if let responseData:[String: Any]? = await NetworkRequest.shared.startRequestWithPost(pairParameters: ["objectId":missionModelQuadrant?.objectId ?? "", "isFinished": (missionModelQuadrant?.isFinished ?? false)], url: Apis.updateMissionModelOfFinished) {
            do {
                if responseData != nil && (responseData!["success"] as! Bool){
      

                    missionModelQuadrant!.isFinished = (missionModelQuadrant?.isFinished ?? false);
                    let storeDataToEncode = storeDataQuadrant
                    guard let data = try? JSONEncoder().encode(storeDataToEncode) else {
                        return .result()
                    }
                    primaryDataQuadrant = data //类似存储在 shareprefrerence
                    
                    guard var missionDataMissionListView = try?
                            JSONDecoder().decode(MissionData.self, from: primaryDataMissionListView) else {
                        return .result()
                    }
                    
                    var missionID = TimerManager.objectID;
                    var missionModel: MissionModel?;
                    if let index = missionDataMissionListView.listMissionModel.firstIndex(where: { $0.objectId == missionID }) {
                        missionDataMissionListView.listMissionModel[index].isFinished = !(missionDataMissionListView.listMissionModel[index].isFinished ?? false)
                        missionModel = missionDataMissionListView.listMissionModel[index]
                    }
                    var res = !(missionModel?.isFinished ?? false);
                    let missionDataToEncode = missionDataMissionListView
                    guard let data = try? JSONEncoder().encode(missionDataToEncode) else {
                        return .result()
                    }
                    primaryDataMissionListView = data //类似存储在 shareprefrerence
                    
                    print("请求成功")
                } else {
                    print("请求失败")
                }
            } catch {
                print("JSON 解析失败: \(error)")
            }
            WidgetCenter.shared.reloadAllTimelines();
        }
        
//        TimerManager.objectID = missionID ?? ""
        
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
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: Params.groupName)) var primaryDataQuadrant : Data = Data()
    
//    @AppStorage("shouldShowHeader") var shouldShowHeader : Bool = true
    
    func placeholder(in context: Context) -> SimpleEntry {
        guard let storeData = try?
                JSONDecoder().decode(StoreData.self, from: primaryDataQuadrant) else {
            let storeData = StoreData(title1: "imp. & urg.", title2: "not imp. & urg.", title3: "imp. & not urg.", title4: "not imp. & not urg.", missionList1: ["mission1", "mission2", "mission3"], missionList2: ["mission4", "mission5", "mission6"], missionList3: ["mission7", "mission8", "mission9"], missionList4: ["mission11", "mission12", "mission13"]);
            
            return SimpleEntry(date: Date(), storeData: storeData, missionListMissionModel1: storeData.missionListMissionModel1 ?? [], missionListMissionModel2: storeData.missionListMissionModel2 ?? [], missionListMissionModel3: storeData.missionListMissionModel3 ?? [], missionListMissionModel4: storeData.missionListMissionModel4 ?? [])
        }
        return SimpleEntry(date: Date(), storeData: storeData, missionListMissionModel1: storeData.missionListMissionModel1 ?? [], missionListMissionModel2: storeData.missionListMissionModel2 ?? [], missionListMissionModel3: storeData.missionListMissionModel3 ?? [], missionListMissionModel4: storeData.missionListMissionModel4 ?? [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard let storeData = try?
                JSONDecoder().decode(StoreData.self, from: primaryDataQuadrant) else {
            let storeData = StoreData(title1: "imp. & urg.", title2: "not imp. & urg.", title3: "imp. & not urg.", title4: "not imp. & not urg.", missionList1: ["mission1", "mission2", "mission3"], missionList2: ["mission4", "mission5", "mission6"], missionList3: ["mission7", "mission8", "mission9"], missionList4: ["mission11", "mission12", "mission13"]);
            
            let entry:SimpleEntry = SimpleEntry(date: Date(), storeData: storeData, missionListMissionModel1: [], missionListMissionModel2: [], missionListMissionModel3: [], missionListMissionModel4: [])
            
            completion(entry)
            return;
        }
        let entry2:SimpleEntry =  SimpleEntry(date: Date(), storeData: storeData, missionListMissionModel1: [], missionListMissionModel2: [], missionListMissionModel3: [], missionListMissionModel4: [])
        
        completion(entry2)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        //NetworkRequest.shared.console(pairParameters: ["id": "id", "title": "title", "isFinished": "isFinished"])

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //
        //        }
        
        
        let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        //        let storeData = StoreData(showText: "1234")
        
        guard var storeData = try?
                JSONDecoder().decode(StoreData.self, from: primaryDataQuadrant) else {
            return
        }
        
        
        storeData.missionListMissionModel1 = storeData.missionListMissionModel1?
            .sorted { (!($0.isFinished ?? false) ?? false) && ($1.isFinished ?? false) } // 按 isFinished 排序：未完成的放在前面，已完成的放在后面
        storeData.missionListMissionModel2 = storeData.missionListMissionModel2?
            .sorted { (!($0.isFinished ?? false) ?? false) && ($1.isFinished ?? false) } // 按 isFinished 排序：未完成的放在前面，已完成的放在后面
        storeData.missionListMissionModel3 = storeData.missionListMissionModel3?
            .sorted { (!($0.isFinished ?? false) ?? false) && ($1.isFinished ?? false) } // 按 isFinished 排序：未完成的放在前面，已完成的放在后面
        storeData.missionListMissionModel4 = storeData.missionListMissionModel4?
            .sorted { (!($0.isFinished ?? false) ?? false) && ($1.isFinished ?? false) } // 按 isFinished 排序：未完成的放在前面，已完成的放在后面
        
        let entry = SimpleEntry(date: entryDate, storeData: storeData, missionListMissionModel1: storeData.missionListMissionModel1 ?? [], missionListMissionModel2: storeData.missionListMissionModel2 ?? [], missionListMissionModel3: storeData.missionListMissionModel3 ?? [], missionListMissionModel4: storeData.missionListMissionModel4 ?? [])
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let storeData : StoreData
    var missionListMissionModel1 : [MissionModel]
    var missionListMissionModel2 : [MissionModel]
    var missionListMissionModel3 : [MissionModel]
    var missionListMissionModel4 : [MissionModel]
}
struct New2QuadrantWidgetEntryView : View {
    var entry: Provider.Entry
    var shouldShowHeader : Bool = false
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    CustomView(backgroundColor: Color(red: 250/255, green: 234/255, blue: 235/255),
                               headerTextColor: Color(red: 250/255, green: 125/255, blue: 125/255),
                               headerText: "imp. & urg.",
                               //                                      headerText: entry.storeData.showText,
                               items: entry.storeData.missionListMissionModel1 ?? [], shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    
                    CustomView(backgroundColor: Color(red: 249/255, green: 246/255, blue: 241/255),
                               headerTextColor: Color(red: 236/255, green: 134/255, blue: 0/255),
                               headerText: "not imp. & urg.",
                               items: entry.storeData.missionListMissionModel2 ?? [], shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                }
                HStack(spacing: 0) {
                    CustomView(backgroundColor: Color(red: 239/255, green: 247/255, blue: 248/255),
                               headerTextColor: Color(red: 26/255, green: 146/255, blue: 174/255),
                               headerText: "imp. & not urg.",
                               items: entry.storeData.missionListMissionModel3 ?? [], shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    
                    CustomView(backgroundColor: Color(red: 242/255, green: 245/255, blue: 237/255),
                               headerTextColor: Color(red: 116/255, green: 155/255, blue: 0/255),
                               headerText: "not imp. & not urg.",
                               items: entry.storeData.missionListMissionModel4 ?? [], shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                }
            }
        }
    }
}


struct CustomView: View {
    let backgroundColor: Color
    let headerTextColor: Color
    let headerText: String
    let items: [MissionModel]
    let shouldShowHeader: Bool
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack {
//            if(shouldShowHeader == true) {
//                RoundedRectangle(cornerRadius: 5)
//                    .fill(backgroundColor)
//                    .frame(height: 30)
//                    .overlay(
//                        Text(headerText)
//                            .foregroundColor(headerTextColor).font(.system(size: 12, weight: .bold))
//                    )
//            }
            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor)
                .overlay(
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(items.prefix(getMaxItems()), id: \.self) { item in
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
                                                .font(.system(size: 12)).foregroundColor(headerTextColor).lineLimit(1)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .background(Color.clear)
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    Spacer() // Spacer to align elements in the row
                                }
                                
                            }
                            
                            //                            HStack {
                            //                                Text(item).font(.system(size: 12)).foregroundColor(headerTextColor).lineLimit(1)
                            //                                Spacer()
                            //                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 5).padding(.vertical, 5)
                    
                )
        }
    }
    
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall: // Small widget
            return 2
        case .systemMedium: // Medium widget
            return 4
        case .systemLarge: // Large widget
            //            return 13
            return 9
            //            return 6
        @unknown default: // Any unknown widget size
            return 6
        }
    }
}

struct New2QuadrantWidget: Widget {
    let kind: String = "New2QuadrantWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                New2QuadrantWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                New2QuadrantWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Quadrant".localizable())
        .description("")
        .supportedFamilies([ .systemLarge, .systemMedium])
    }
}

//#Preview(as: .systemSmall) {
//    New2QuadrantWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
