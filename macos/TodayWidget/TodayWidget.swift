//
//  TodayWidget.swift
//  TodayWidget
//
//  Created by 林智彬 on 2023/8/29.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), missionData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        guard let missionData = try?
                JSONDecoder().decode(MissionData.self, from: primaryData) else {
            let missionData = MissionData(missionList: []);
            
            let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: MissionData(missionList: []))

            completion(entry)
            return;
        }
        let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: missionData)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    
//    let items: [String]
    let missionData : MissionData?
//    let date: Date
}

struct TodayWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            HStack {
                Color.red.frame(width: 4, height: 10).padding(.trailing, 4)
                Text("今天待完成任务2123")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
            }
//            VStack(alignment: .leading, spacing: 5) {
//                ForEach(entry.missionData?.missionList ?? [], id: \.self) { item in
//                    HStack {
//                        Text(item)                                         .font(.system(size: 12))
//                            .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
//                        Spacer()
//                    }
//                }
//                Spacer()
//            }.padding(.horizontal, 5).padding(.vertical, 5)
        }
    }
}

//@main
//struct TodayWidget: Widget {
//    let kind: String = "TodayWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            TodayWidgetEntryView(entry: entry, missionData: MissionData(missionList: ["123"]))
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//}
//
//struct TodayWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayWidgetEntryView(entry: SimpleEntry(date: Date()), missionData: MissionData(missionList: ["123"]))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
