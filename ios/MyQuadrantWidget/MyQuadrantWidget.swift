//
//  QuadrantWidget.swift
//  QuadrantWidget
//
//  Created by 林智彬 on 2024/10/15.
//

import WidgetKit
import SwiftUI
import AppIntents

struct TimerManager {
    static var objectID: String = "";
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

// Intent to handle the button action
struct TimerIntent2: AppIntent {
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let storeData : StoreData
    var missionListMissionModel1 : [MissionModel]
    var missionListMissionModel2 : [MissionModel]
    var missionListMissionModel3 : [MissionModel]
    var missionListMissionModel4 : [MissionModel]
}

struct QuadrantWidgetEntryView : View {
    var entry: Provider.Entry
    var shouldShowHeader : Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                HStack(spacing: 10) {
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
                HStack(spacing: 10) {
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

struct QuadrantWidget: Widget {
    let kind: String = "QuadrantWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                QuadrantWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                QuadrantWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Quadrant".localizable())
        .description("")
        .supportedFamilies([ .systemLarge, .systemExtraLarge])
    }
}


struct CustomView: View {
    let backgroundColor: Color
    let headerTextColor: Color
    let headerText: String
    let items: [MissionModel]
    let shouldShowHeader: Bool
    
    var body: some View {
        VStack {
            if(shouldShowHeader == true) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(backgroundColor)
                    .frame(height: 30)
                    .overlay(
                        Text(headerText)
                            .foregroundColor(headerTextColor).font(.system(size: 12, weight: .bold))
                    )
            }
            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor)
                .overlay(
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(items.prefix(6), id: \.self) { item in
                            ZStack {
                                HStack(alignment: .center)  {
                                    // Check or Uncheck Icon based on isFinished value
                                    if #available(iOSApplicationExtension 17.0, *) {
                                        Button(intent: TimerIntent2(missionID: item.objectId ?? "")) {
                                            Image((item.isFinished ?? false) ? "ic_check" : "ic_uncheck") // Load the appropriate image
                                                .resizable() // Make the image resizable
                                                .frame(width: 14, height: 14) // Set the size of the image
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(maxWidth: 14, maxHeight: 14)
                                        .background(Color.clear)
                                    } else {
                                        // Fallback on earlier versions
                                        Image((item.isFinished ?? false) ? "ic_check" : "ic_uncheck") // Load the appropriate image
                                            .resizable() // Make the image resizable
                                            .frame(width: 14, height: 14) // Set the size of the image
                                    }
                                    
                                    
                                    // Display the mission title
                                    if #available(iOSApplicationExtension 17.0, *) {
                                        Button(intent: TimerIntent2(missionID: item.objectId ?? "")) {
                                            Text("\(item.title ?? "")")
                                                .font(.system(size: 12)).foregroundColor(headerTextColor).lineLimit(1)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .background(Color.clear)
                                    } else {
                                        // Fallback on earlier versions
                                        Text("\(item.title ?? "")")
                                            .font(.system(size: 12)).foregroundColor(headerTextColor).lineLimit(1)
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
}
