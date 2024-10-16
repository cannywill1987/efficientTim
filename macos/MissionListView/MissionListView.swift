//
//  MissionListView.swift
//  MissionListView
//
//  Created by 林智彬 on 2024/10/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: "S4CLCWPCGH.com.timespeed.timehello")) var primaryData : Data = Data()
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: "S4CLCWPCGH.com.timespeed.timehello")) var primaryData2 : Data = Data()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard let missionData = try?
                JSONDecoder().decode(MissionData.self, from: primaryData) else {
            let missionData = MissionData(listMissionModel: []);
            let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
            completion(entry)
            return;
        }
        let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: missionData)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        guard let missionData = try?
                JSONDecoder().decode(MissionData.self, from: primaryData) else {
            let missionData = MissionData(listMissionModel: []);
            let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: []))
            completion(Timeline(entries: [entry], policy: .atEnd))
            return;
        }
        let entry:SimpleEntry = SimpleEntry(date: Date(), missionData: missionData)
        
//        completion(entry)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
        
//        var entries: [SimpleEntry] = []
//        var missionData:MissionData?;
//        do {
//            missionData = try JSONDecoder().decode(MissionData.self, from: primaryData)
//        } catch {
//            print("Could not write to file")
//        }
//        let currentDate = Date()
//        for hourOffset in 0 ..< 500 {
//            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, missionData: missionData)
//            entries.append(entry)
//        }
//        
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missionData : MissionData?
//    let list: [String]
}

struct MissionListViewEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Color.yellow.frame(width: 4, height: 10).padding(.trailing, 2)
                Text("today".localizable())
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                Spacer()
            }.padding(.trailing, 4)
            
            ForEach(entry.missionData?.listMissionModel.prefix(getMaxItems()) ?? [], id: \.self) { item in
                HStack {
                    Text(item.title ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255)).padding(.bottom, 2)
                    Spacer()
                    //                    Text("今天-\(entry.missionData?.listMissionModel.count ?? 0)")
                    //                        .font(.system(size: 12))
                    //                        .foregroundColor(Color(red: 168/255, green: 168/255, blue: 168/255))
                    //                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            Spacer()
        }.padding(10).background(Color.white)
    }
    
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall:
            return 5
        case .systemMedium:
            return 5
        case .systemLarge:
            return 13
        @unknown default:
            return 6
        }
    }
}

struct MissionListView: Widget {
    let kind: String = "MissionListView"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(macOS 14.0, *) {
                MissionListViewEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                MissionListViewEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MissionListView_Previews: PreviewProvider {
    static var previews: some View {
        MissionListViewEntryView(entry: SimpleEntry(date: Date(), missionData: MissionData(listMissionModel: [])))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

