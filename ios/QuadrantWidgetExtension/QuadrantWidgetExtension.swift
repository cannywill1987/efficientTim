//
//  QuadrantWidgetExtension.swift
//  QuadrantWidgetExtension
//
//  Created by 林智彬 on 2023/6/9.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()
    
    @AppStorage("shouldShowHeader") var shouldShowHeader : Bool = true
    
    func placeholder(in context: Context) -> SimpleEntry {
        guard let storeData = try?
                JSONDecoder().decode(StoreData.self, from: primaryData) else {
            let storeData = StoreData(title1: "imp. & urg.", title2: "not imp. & urg.", title3: "imp. & not urg.", title4: "not imp. & not urg.", missionList1: ["mission1", "mission2", "mission3"], missionList2: ["mission4", "mission5", "mission6"], missionList3: ["mission7", "mission8", "mission9"], missionList4: ["mission11", "mission12", "mission13"]);
            
            return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), storeData: storeData)
        }
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), storeData: storeData)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let storeData = StoreData(title1: "imp. & urg.", title2: "not imp. & urg.", title3: "imp. & not urg.", title4: "not imp. & not urg.", missionList1: ["mission1", "mission2", "mission3"], missionList2: ["mission4", "mission5", "mission6"], missionList3: ["mission7", "mission8", "mission9"], missionList4: ["mission11", "mission12", "mission13"]);
//
//        let entry = SimpleEntry(date: Date(), configuration: configuration, storeData: storeData)
        
        
        guard let storeData = try?
                JSONDecoder().decode(StoreData.self, from: primaryData) else {
            let storeData = StoreData(title1: "imp. & urg.", title2: "not imp. & urg.", title3: "imp. & not urg.", title4: "not imp. & not urg.", missionList1: ["mission1", "mission2", "mission3"], missionList2: ["mission4", "mission5", "mission6"], missionList3: ["mission7", "mission8", "mission9"], missionList4: ["mission11", "mission12", "mission13"]);
            
            let entry:SimpleEntry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), storeData: storeData)
            
            completion(entry)
            return;
        }
        let entry2:SimpleEntry =  SimpleEntry(date: Date(), configuration: ConfigurationIntent(), storeData: storeData)
        
        completion(entry2)
    }
    
    //用来展示用的
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //
        //        }
        
        
        let entryDate = Calendar.current.date(byAdding: .hour, value: 0, to: currentDate)!
        //        let storeData = StoreData(showText: "1234")
        
        guard let storeData = try?
                JSONDecoder().decode(StoreData.self, from: primaryData) else {
            return
        }
        
        let entry = SimpleEntry(date: entryDate, configuration: configuration, storeData: storeData)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
        //        guard let storeData = try?
        //                        JSONDecoder().decode(StoreData.self, from: primaryData) else {
        //                    return
        //                }
        
        //                let timeline = Timeline(entries: [entry], policy: .never)
        //                let timeline = Timeline(entries: entries, policy: .atEnd)
        //                completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let storeData : StoreData
}

struct QuadrantWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    var shouldShowHeader : Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    CustomView(backgroundColor: Color(red: 250/255, green: 234/255, blue: 235/255),
                               headerTextColor: Color(red: 250/255, green: 125/255, blue: 125/255),
                               headerText: "not imp. & urg.",
                               //                                      headerText: entry.storeData.showText,
                               items: entry.storeData.missionList1, shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    
                    CustomView(backgroundColor: Color(red: 249/255, green: 246/255, blue: 241/255),
                               headerTextColor: Color(red: 236/255, green: 134/255, blue: 0/255),
                               headerText: "not imp. & urg.",
                               items: entry.storeData.missionList2, shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                }
                HStack(spacing: 10) {
                    CustomView(backgroundColor: Color(red: 239/255, green: 247/255, blue: 248/255),
                               headerTextColor: Color(red: 26/255, green: 146/255, blue: 174/255),
                               headerText: "imp. & not urg.",
                               items: entry.storeData.missionList3, shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    
                    CustomView(backgroundColor: Color(red: 242/255, green: 245/255, blue: 237/255),
                               headerTextColor: Color(red: 116/255, green: 155/255, blue: 0/255),
                               headerText: "not imp. & not urg.",
                               items: entry.storeData.missionList4, shouldShowHeader: shouldShowHeader)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                }
            }
        }
        //        Text("iOS 14 的新的小组件")
        //                     .foregroundColor(.white)
        //                     .lineLimit(2)
        //        ZStack{
        //            Color(.sRGB,red: 0/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
        //            Text("123")
        //        }
        
        
        //
        //        Text(entry.date, style: .time)
        
        //        Text(entry.date, style: .time)
    }
}

struct QuadrantWidgetExtension: Widget {
    let kind: String = "QuadrantWidgetExtension"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            QuadrantWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Four Quadrant")
        .description("Manage the priority of Mission")
        .supportedFamilies([ .systemLarge,.systemExtraLarge])
    }
}

struct QuadrantWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        let storeData = StoreData(title1: "imp. & urg.", title2: "not imp. & urg.", title3: "imp. & not urg.", title4: "not imp. & not urg.", missionList1: ["Task2", "Task3"], missionList2: ["Task4", "Task5", "Task6"], missionList3: ["Task7", "Task8", "Task9"], missionList4: ["Task10", "Task11", "Task12"]);
        
        QuadrantWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), storeData: storeData))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}


struct CustomView: View {
    let backgroundColor: Color
    let headerTextColor: Color
    let headerText: String
    let items: [String]
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
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item)                                         .font(.system(size: 12))
                                    .foregroundColor(headerTextColor)
                                Spacer()
                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 5).padding(.vertical, 5)
                    
                )
        }
    }
}
