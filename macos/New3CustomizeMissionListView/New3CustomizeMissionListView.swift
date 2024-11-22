//
//  MissionListView.swift
//  MissionListView
//
//  Created by 林智彬 on 2024/10/15.
//

import WidgetKit
import SwiftUI
import AppIntents


struct TimerManager {
    static var objectID: String = "";
}

// A provider that supplies the timeline data for the widget
struct Provider: TimelineProvider {
    // Access stored primary data for the widget
    @AppStorage("CustomizeMissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryDataMissionListView : Data = Data()
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

// Intent to handle the button action
struct TimerIntent2: AppIntent {
    @AppStorage("CustomizeMissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryDataMissionListView : Data = Data()
    
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


// A simple entry for the widget that includes a date and mission data
struct SimpleEntry: TimelineEntry {
    let date: Date
    let missionData: MissionData?
}

// The view displayed by the widget, showing mission data
struct MissionListViewEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header section with today's title
            HStack {
                Color.yellow.frame(width: 4, height: 10).padding(.trailing, 2) // Yellow line as a visual marker
                //                Text("11111111\(TimerManager.title)")
                //                Text(entry.date, style: .time)
                Text(entry.missionData?.title ?? "") // Localized label for "today"
                    .font(.system(size: 15, weight: .bold)) // Bold font for today's text
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255)) // Dark gray color for text
                Spacer() // Spacer to push content to the end of the line
            }.padding(.trailing, 4)
            
            // Display each mission item, up to the maximum allowed
            ForEach(entry.missionData?.listMissionModel.prefix(getMaxItems()) ?? [], id: \.self) { item in
                ZStack {
                    HStack(alignment: .center)  {
                        // Check or Uncheck Icon based on isFinished value
                        Button(intent: TimerIntent2(missionID: item.objectId ?? "")) {
                            Image((item.isFinished ?? false) ? "ic_check" : "ic_uncheck") // Load the appropriate image
                                .resizable() // Make the image resizable
                                .frame(width: 14, height: 14) // Set the size of the image
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: 14, maxHeight: 14)
                        .background(Color.clear)
                        
                        
                        // Display the mission title
                        Button(intent: TimerIntent2(missionID: item.objectId ?? "")) {
                            Text("\(item.title ?? "")")
                                .font(.system(size: 12)) // Font size for mission title
                                .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255)) // Dark gray color for text
                                .padding(.bottom, 2) // Padding below each item
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
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


// Widget configuration definition
struct MissionListView: Widget {
    let kind: String = "MissionListView" // The identifier for the widget
    
    var body: some WidgetConfiguration {
        // Static configuration of the widget using the provided timeline data provider
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MissionListViewEntryView(entry: entry) // Widget's main view
                .containerBackground(.fill.tertiary, for: .widget) // Background configuration for newer versions
        }
        .contentMarginsDisabled() // Disable default content margins for the widget
        .configurationDisplayName("customize_mission".localizable()) // Display name for the widget configuration
        .description("") // Description for the widget configuration
    }
}

// Preview provider for the widget in the development environment
struct MissionListView_Previews: PreviewProvider {
    static var previews: some View {
        // Show a preview of the widget in different family sizes
        MissionListViewEntryView(entry: SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: [])))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
