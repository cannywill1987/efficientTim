//
//  NoteWidget.swift
//  NoteWidget
//
//  Created by 林智彬 on 2023/10/18.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("WQBMissionStoreDataNote1", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()

    func placeholder(in context: Context) -> SimpleEntry {
        var data:WQBMissionModel?;
        do {
            data = try JSONDecoder().decode(WQBMissionModel.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        return SimpleEntry(date: Date(), missionData: data)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var data:WQBMissionModel?;
        do {
            data = try JSONDecoder().decode(WQBMissionModel.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        
        let entry = SimpleEntry(date: Date(), missionData: data)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var data:WQBMissionModel?;
        do {
            data = try JSONDecoder().decode(WQBMissionModel.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, missionData: data)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)

//        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missionData : WQBMissionModel?

}

struct NoteWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text("123")
        NoteViewWidget(missionData: entry.missionData, subTitle: "note1".localizable())
       }
}

@main
struct NoteWidget: Widget {
    let kind: String = "NoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NoteWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled() 
        .configurationDisplayName("note1".localizable())
        .description("note_desc".localizable())
    }
}

//struct NoteWidget_Previews: PreviewProvider {
//    @AppStorage("WQBMissionStoreDataNote1", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()
//    static var previews: some View {
//        var data:WQBMissionModel?;
//        do {
//            data = try JSONDecoder().decode(WQBMissionModel.self, from: primaryData)
//        } catch {
//            print("Could not write to file")
//        }
//        NoteWidgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
