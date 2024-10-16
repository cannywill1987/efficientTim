//
//  TestWidget.swift
//  TestWidget
//
//  Created by 林智彬 on 2024/10/16.
//

import WidgetKit
import SwiftUI

import AppIntents
 

struct CountdownManager {
    static var countdownSeconds: Int = 1500 // 默认倒计时为25分钟（1500秒）
    static var isPaused: Bool = true
}

struct CountdownIntent: AppIntent {
    static var title: LocalizedStringResource = "Countdown Task"
    static var description: IntentDescription = IntentDescription("Manage Countdown Timer")

    @Parameter(title: "Action")
    var action: CountdownAction
    
    init() { }
    init(action: CountdownAction) {
        self.action = action
    }
    
    func perform() async throws -> some IntentResult {
        switch action {
        case .start:
            CountdownManager.isPaused = false
        case .pause:
            CountdownManager.isPaused = true
        case .reset:
            CountdownManager.isPaused = true
            CountdownManager.countdownSeconds = 1500 // 重置为25分钟
        }
        return .result()
    }
}
enum CountdownAction: String, AppEnum {
    case start = "Start"
    case pause = "Pause"
    case reset = "Reset"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Countdown Action"
    }

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .start: "Start",
            .pause: "Pause",
            .reset: "Reset"
        ]
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
           SimpleEntry(date: Date(), remainingSeconds: CountdownManager.countdownSeconds)
       }

       func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
           let entry = SimpleEntry(date: Date(), remainingSeconds: CountdownManager.countdownSeconds)
           completion(entry)
       }

       func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
           var entries: [SimpleEntry] = []

           let currentDate = Date()
           var countdownSeconds = CountdownManager.countdownSeconds
           
           // 每秒更新一次倒计时，直到倒计时结束
           for secondOffset in 0..<countdownSeconds {
               let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
               
               if !CountdownManager.isPaused && countdownSeconds > 0 {
                   countdownSeconds -= 1
               }

               let entry = SimpleEntry(date: entryDate, remainingSeconds: countdownSeconds)
               entries.append(entry)
           }

           let timeline = Timeline(entries: entries, policy: .atEnd)
           completion(timeline)
       }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let remainingSeconds: Int
}

struct TestWidgetEntryView : View {
    
    var entry: Provider.Entry
    var body: some View {
        VStack {
            // 显示倒计时
            Text("倒计时: \(formatSeconds(entry.remainingSeconds))")
                .font(.title)
            
            HStack {
                // 开始/暂停按钮
                Button(action: {
                    if CountdownManager.isPaused {
                        Task { try await CountdownIntent(action: .start).perform() }
                    } else {
                        Task { try await CountdownIntent(action: .pause).perform() }
                    }
                }) {
                    Image(systemName: CountdownManager.isPaused ? "play.fill" : "pause.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                
                // 重置按钮
                Button(action: {
                    Task { try await CountdownIntent(action: .reset).perform() }
                }) {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
    
    // 将秒数格式化为分钟和秒
    func formatSeconds(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct TestWidget: Widget {
    let kind: String = "TestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                TestWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TestWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
