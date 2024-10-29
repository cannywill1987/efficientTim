//
//  NewNoteWidget.swift
//  NewNoteWidget
//
//  Created by 林智彬 on 2024/10/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("WQBMissionStoreDataNote2", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    
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

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let missionData : WQBMissionModel?

}

struct NewNote1WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text("123")
    NoteViewWidget(missionData: entry.missionData, subTitle: "note2".localizable())
       }
}


struct NewNote2Widget: Widget {
    let kind: String = "NewNoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                NewNote1WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewNote1WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("note2".localizable())
        .description("note_desc".localizable())
    }
}
