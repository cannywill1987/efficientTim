//
//  NewCountdownWidget.swift
//  NewCountdownWidget
//
//  Created by 林智彬 on 2024/11/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct NewCountdownWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            CountdownView(endTime: Date().addingTimeInterval(30 * 86400).timeIntervalSince1970 * 1000)
        }
    }
}

struct CountdownView: View {
    @State var remainTime: Int // Remaining time in seconds
    @State var completed: Bool = false // Completion flag
    let endTime: Double // End time in milliseconds timestamp
    
    init(endTime: Double) {
        let currentTime = Date().timeIntervalSince1970 * 1000
        self.endTime = endTime
        self._remainTime = State(initialValue: Int((endTime - currentTime) / 1000))
    }
    
    var body: some View {
        VStack(alignment: .leading){
            if completed {
                Text("Completed")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                
                HStack(alignment: .bottom) {
                    Text("\(remainTime / 86400)")
                        .font(.system(size: 36, weight: .bold))
                    Text("Day").font(.system(size: 36, weight: .bold))
                    Text(timerInterval: Date()...Date().addingTimeInterval(TimeInterval(remainTime % 86400)), countsDown: true)
                        .font(.system(size: 22, weight: .bold))
                }
                .font(.title)
                .onReceive(timer) { _ in
                    if remainTime > 0 {
                        remainTime -= 1
                    }
                    if remainTime <= 0 {
                        completed = true
                    }
                }
                Text("jeiwjfiwe")
                    .font(.system(size: 26, weight: .bold))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                                   startPoint: .leading,
                                   endPoint: .trailing))
        .cornerRadius(10)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func currentHourMinuteSecond() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

struct NewCountdownWidget: Widget {
    let kind: String = "NewCountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                NewCountdownWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewCountdownWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .systemMedium,.systemLarge, .systemExtraLarge])
//        .configurationDisplayName("configuration_display_name".localizable())
//        .description("description".localizable())
        .supportedFamilies([ .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
