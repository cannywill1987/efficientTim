//
//  Test2Widget.swift
//  Test2Widget
//
//  Created by 林智彬 on 2024/10/16.
//

import WidgetKit
import SwiftUI
import AppIntents

struct TimerManager {
    static var timerDuration: Int = 1500 // 默认25分钟
    static var isCountingDown: Bool = true // 标识是否为倒计时
    static var isPaused: Bool = true // 默认状态为暂停
    static var startTime: Date?
}

// TimerIntent: 用于处理计时器操作的AppIntent，支持启动、暂停、重置等操作
struct TimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Timer Task"
    static var description: IntentDescription = IntentDescription("Manage Timer")

    @Parameter(title: "Action")
    var action: TimerAction
    
    init() { }
    init(action: TimerAction) {
        self.action = action
    }
    
    func perform() async throws -> some IntentResult {
        switch action {
        case .start:
            TimerManager.isPaused = false
            TimerManager.startTime = Date()
            WidgetCenter.shared.reloadAllTimelines()
        case .pause:
            TimerManager.isPaused = true
            WidgetCenter.shared.reloadAllTimelines()
        case .reset:
            TimerManager.isPaused = true
            TimerManager.timerDuration = TimerManager.isCountingDown ? 1500 : 0
            TimerManager.startTime = nil
            WidgetCenter.shared.reloadAllTimelines()
        case .addMinute:
            if TimerManager.isPaused {
                TimerManager.timerDuration += 60
                WidgetCenter.shared.reloadAllTimelines()
            }
        case .subtractMinute:
            if TimerManager.isPaused && TimerManager.timerDuration > 60 {
                TimerManager.timerDuration -= 60
                WidgetCenter.shared.reloadAllTimelines()
            }
        case .toggleCountdown:
            if TimerManager.isPaused {
                TimerManager.isCountingDown.toggle()
                TimerManager.timerDuration = TimerManager.isCountingDown ? 1500 : 0
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        return .result()
    }
}

// TimerAction: 定义计时器可执行的各种操作
enum TimerAction: String, AppEnum {
    case start = "Start"
    case pause = "Pause"
    case reset = "Reset"
    case addMinute = "AddMinute"
    case subtractMinute = "SubtractMinute"
    case toggleCountdown = "ToggleCountdown"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Timer Action"
    }

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .start: "Start",
            .pause: "Pause",
            .reset: "Reset",
            .addMinute: "Add 1 Minute",
            .subtractMinute: "Subtract 1 Minute",
            .toggleCountdown: "Toggle Countdown/Countup"
        ]
    }
}

// Provider: 提供Widget时间线，控制Widget的状态和内容更新
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), deliveryTimerDown: Date()...Date().addingTimeInterval(Double(TimerManager.timerDuration)), deliveryTimerUp: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), isCountingDown: TimerManager.isCountingDown)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), deliveryTimerDown: Date()...Date().addingTimeInterval(Double(TimerManager.timerDuration)), deliveryTimerUp: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), isCountingDown: TimerManager.isCountingDown)
        completion(entry)
    }

    // getTimeline: 生成时间线条目并决定何时刷新Widget的显示
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        var endDate = currentDate.addingTimeInterval(Double(TimerManager.timerDuration))
        
        if let startTime = TimerManager.startTime, !TimerManager.isPaused {
            let elapsedTime = Date().timeIntervalSince(startTime)
            if TimerManager.isCountingDown {
                endDate = startTime.addingTimeInterval(Double(TimerManager.timerDuration) - elapsedTime)
            } else {
                endDate = startTime.addingTimeInterval(elapsedTime)
            }
        } else if TimerManager.isPaused {
            endDate = currentDate.addingTimeInterval(Double(TimerManager.timerDuration))
        }
        
        let entry = SimpleEntry(date: currentDate, deliveryTimerDown: currentDate...endDate, deliveryTimerUp: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), isCountingDown: TimerManager.isCountingDown)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let deliveryTimerDown: ClosedRange<Date>
    let deliveryTimerUp: ClosedRange<Date>
    let isCountingDown: Bool
}



struct Test2WidgetEntryView : View {
    var entry: Provider.Entry
     
    // formatSeconds: 将秒数格式化为“mm:ss”的时间格式
    // currentDisplayedTime: 获取当前需要显示的时间（暂停时保留当前时间）
    func currentDisplayedTime() -> Int {
        if let startTime = TimerManager.startTime, !TimerManager.isPaused {
            let elapsedTime = Int(Date().timeIntervalSince(startTime))
            if TimerManager.isCountingDown {
                return max(TimerManager.timerDuration - elapsedTime, 0)
            } else {
                return TimerManager.timerDuration + elapsedTime
            }
        }
        return TimerManager.timerDuration
    }
    
    
     // formatSeconds: 将秒数格式化为“mm:ss”的时间格式
     func formatSeconds(_ seconds: Int) -> String {
         let minutes = seconds / 60
         let remainingSeconds = seconds % 60
         return String(format: "%02d:%02d", minutes, remainingSeconds)
     }
     
     // body: 定义Widget的视图布局，包括倒计时/正计时的显示和操作按钮
     var body: some View {
         VStack {
             Text(TimerManager.isCountingDown ? "倒计时: " : "正计时: ")
             Group {
                 if TimerManager.isPaused || TimerManager.startTime == nil {
                     
                     Text(formatSeconds(currentDisplayedTime()))
                                      .font(.system(size: 25)).fontWeight(.bold)
                                      .font(.caption2)
                                      .frame(maxWidth: .infinity)
                                      .multilineTextAlignment(.center)
                                      .padding()
                 } else {
                     Text(timerInterval: entry.isCountingDown ? entry.deliveryTimerDown : entry.deliveryTimerUp, countsDown: entry.isCountingDown)
                         .font(.system(size: 25)).fontWeight(.bold)
                         .font(.caption2)
                         .frame(maxWidth: .infinity)
                         .multilineTextAlignment(.center)
                         .padding()
                 }
             }
             HStack {
                 Button(intent: TimerIntent(action: TimerManager.isPaused ? .start : .pause)) {
                     Image(systemName: TimerManager.isPaused ? "play.fill" : "pause.fill")
                         .font(.largeTitle)
                         .foregroundColor(.blue)
                 }
                 Button(intent: TimerIntent(action: .reset)) {
                     Image(systemName: "stop.fill")
                         .font(.largeTitle)
                         .foregroundColor(.red)
                 }
                 Button(intent: TimerIntent(action: .toggleCountdown)) {
                     Image(systemName: TimerManager.isCountingDown ? "arrow.counterclockwise" : "arrow.clockwise")
                         .font(.largeTitle)
                         .foregroundColor(.green)
                 }
                 Button(intent: TimerIntent(action: .addMinute)) {
                     Image(systemName: "plus.circle")
                         .font(.largeTitle)
                         .foregroundColor(.orange)
                 }
                 Button(intent: TimerIntent(action: .subtractMinute)) {
                     Image(systemName: "minus.circle")
                         .font(.largeTitle)
                         .foregroundColor(.purple)
                 }
             }
         }
         .padding()
     }
}

struct Test2Widget: Widget {
    let kind: String = "Test2Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                Test2WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Test2WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("11111111111")
        .description("2222222222.")
    }
}
