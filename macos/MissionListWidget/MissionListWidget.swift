//
//  MissionListWidget.swift
//  MissionListWidget
//
//  Created by 林智彬 on 2023/8/30.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData2 : Data = Data()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []), list: ["111111"])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
//        completion(entry)
        var storeData:StoreData?;
        do {
          storeData = try JSONDecoder().decode(StoreData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        guard let missionData = try?
                JSONDecoder().decode(MissionData.self, from: primaryData) else {
            
                
            let missionData = MissionData(listMissionModel: []);
            
            let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []), list: [])

            completion(entry)
            return;
        }
        let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: missionData, list: storeData?.missionList1 ?? [])
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 500 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, missionData: MissionData(listMissionModel: []), list: [])
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missionData : MissionData?
    let list: [String]
}

struct MissionListWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(entry.list ?? [], id: \.self) { item in
                HStack {
                    Text(item)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                }
            }
            
            HStack {
                Color.yellow.frame(width: 4, height: 10).padding(.trailing, 4)
                Text("今天 今天待完成任务12123")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                Spacer()
            }
            
            ForEach(entry.missionData?.listMissionModel ?? [], id: \.self) { item in
                HStack {
                    Text(item.title)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    Spacer()
                    Text("今天")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 168/255, green: 168/255, blue: 168/255))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
//            Spacer()
        }.padding(10)
    }
}

@main
struct MissionListWidget: Widget {
    let kind: String = "MissionListWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MissionListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MissionListWidget_Previews: PreviewProvider {
    static var previews: some View {
        MissionListWidgetEntryView(entry: SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []), list: ["ewf"]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
