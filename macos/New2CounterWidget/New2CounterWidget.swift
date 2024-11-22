// 导入WidgetKit和SwiftUI框架
import WidgetKit
import SwiftUI
import AppIntents

// TimerManager: 管理计时器的状态和数据
struct TimerManager {
    static var beginTimestamp: Int = 0;
    static var endTimestamp: Int = 0;
    static var timerDuration: Int = 1500 // Default 25 minutes
    static var isCountingDown: Bool = true // Indicates whether it's counting down
    static var isPaused: Bool = true // Default state is paused
    static var startTime: Date? // Timer's start time
    static var totalElapsedTime: TimeInterval = 0 // Total elapsed time
    static var hasRequest: Bool = false // 是否发起请求
    static var isPauseClick: Bool = false // 暂停按钮是否点击
    static var isStopClick: Bool = false // 停止是否点击
}

/**得到当前秒单位时间戳**/
func getCurrentTimeStampBySeconds() -> Int{
    let timeInterval: TimeInterval = Date().timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return timeStamp * 1000;
}

// TimerIntent: 用于处理计时器操作的AppIntent，支持启动、暂停、重置等操作
struct TimerIntent: AppIntent {
    // 使用AppStorage存储计时器时长，适用于共享应用和小组件的状态
    @AppStorage("timerDuration", store: UserDefaults(suiteName: Params.groupName)) var timerDuration : Int = 1500 // 25分钟
    
    static var title: LocalizedStringResource = "Timer Task" // 定义Intent的标题
    static var description: IntentDescription = IntentDescription("Manage Timer") // 定义Intent的描述

    @Parameter(title: "Action")
    var action: TimerAction // 定义计时器的操作参数
    
    // 初始化函数
    init() { }
    init(action: TimerAction) {
        self.action = action
    }
    
    // perform: 执行相应的计时器操作
    func perform() async throws -> some IntentResult {
        switch action {
            // In the 'start' case:
            case .start:
                TimerManager.beginTimestamp = getCurrentTimeStampBySeconds();
                TimerManager.hasRequest = false;
                TimerManager.isPaused = false
                TimerManager.startTime = Date() // Set startTime to current date
                WidgetCenter.shared.reloadAllTimelines()
                TimerManager.isPauseClick = false;
                TimerManager.isStopClick = false;
            // In the 'pause' case:
            case .pause:
                TimerManager.isPauseClick = true;
                TimerManager.isPaused = true
                TimerManager.endTimestamp = getCurrentTimeStampBySeconds();
                if let startTime = TimerManager.startTime {
                    TimerManager.totalElapsedTime += Date().timeIntervalSince(startTime) // Accumulate elapsed time
                    TimerManager.startTime = nil // Clear startTime
                }
                WidgetCenter.shared.reloadAllTimelines()

            // In the 'reset' case:
            case .reset:
            if let startTime = TimerManager.startTime {
                TimerManager.totalElapsedTime += Date().timeIntervalSince(startTime) // Accumulate elapsed time
                TimerManager.startTime = nil // Clear startTime
            }
                TimerManager.isPaused = true
                TimerManager.timerDuration = TimerManager.isCountingDown ? timerDuration : 0
                TimerManager.startTime = nil
//                TimerManager.totalElapsedTime = 0 // Reset total elapsed time
                TimerManager.isStopClick = true;

                WidgetCenter.shared.reloadAllTimelines()
        case .addMinute:
            if TimerManager.isPaused { // 如果计时器处于暂停状态
                TimerManager.timerDuration += 60 // 增加一分钟
                timerDuration = TimerManager.timerDuration // 更新存储值
                WidgetCenter.shared.reloadAllTimelines() // 刷新所有小组件时间线
            }
        case .subtractMinute:
            if TimerManager.isPaused && TimerManager.timerDuration > 60 { // 如果计时器处于暂停状态且时长大于一分钟
                TimerManager.timerDuration -= 60 // 减少一分钟
                timerDuration = TimerManager.timerDuration // 更新存储值
                WidgetCenter.shared.reloadAllTimelines() // 刷新所有小组件时间线
            }
        case .toggleCountdown:
            if TimerManager.isPaused { // 如果计时器处于暂停状态
                TimerManager.isCountingDown.toggle() // 切换倒计时/正计时状态
                TimerManager.timerDuration = TimerManager.isCountingDown ? timerDuration : 0 // 根据模式更新计时器时长
                WidgetCenter.shared.reloadAllTimelines() // 刷新所有小组件时间线
            }
        }
        return .result() // 返回Intent的结果
    }
}

// TimerAction: 定义计时器可执行的各种操作
enum TimerAction: String, AppEnum {
    case start = "Start" // 启动计时器
    case pause = "Pause" // 暂停计时器
    case reset = "Reset" // 重置计时器
    case addMinute = "AddMinute" // 增加一分钟
    case subtractMinute = "SubtractMinute" // 减少一分钟
    case toggleCountdown = "ToggleCountdown" // 切换倒计时/正计时
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Timer Action" // 定义枚举的显示类型
    }

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .start: "Start", // 启动操作的显示名
            .pause: "Pause", // 暂停操作的显示名
            .reset: "Reset", // 重置操作的显示名
            .addMinute: "Add 1 Minute", // 增加一分钟的显示名
            .subtractMinute: "Subtract 1 Minute", // 减少一分钟的显示名
            .toggleCountdown: "Toggle Countdown/Countup" // 切换倒计时/正计时的显示名
        ]
    }
}

// Provider: 提供Widget时间线，控制Widget的状态和内容更新
struct Provider: TimelineProvider {
    @AppStorage("timerDuration", store: UserDefaults(suiteName: Params.groupName)) var timerDuration : Int = 1500 // 25分钟
    @AppStorage("uid", store: UserDefaults(suiteName: Params.groupName)) var uid : String = ""

    // placeholder: 提供Widget的占位视图
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), deliveryTimerDown: Date()...Date().addingTimeInterval(Double(TimerManager.timerDuration)), deliveryTimerUp: Date.now...(Date.now.addingTimeInterval(1000)), isCountingDown: TimerManager.isCountingDown)
    }

    // getSnapshot: 获取Widget的快照视图
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), deliveryTimerDown: Date()...Date().addingTimeInterval(Double(TimerManager.timerDuration)), deliveryTimerUp: Date.now...(Date.now.addingTimeInterval(10000000)), isCountingDown: TimerManager.isCountingDown)
        completion(entry) // 返回快照条目
    }

    // getTimeline: 生成时间线条目并决定何时刷新Widget的显示
    
    // getTimeline: 生成时间线条目并决定何时刷新Widget的显示
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let elapsedTime: TimeInterval
        if let startTime = TimerManager.startTime, !TimerManager.isPaused {
            // Timer is running
            elapsedTime = TimerManager.totalElapsedTime + Date().timeIntervalSince(startTime)
            print("Timer started at: \(startTime)")
        } else {
            // Timer is paused
            elapsedTime = TimerManager.totalElapsedTime
            print("Timer is paused. Total elapsed time: \(elapsedTime) seconds")
            Task {
                if TimerManager.hasRequest == false && TimerManager.isStopClick {
                    TimerManager.totalElapsedTime = 0
                    TimerManager.hasRequest = true
                    let res:BaseResponse? = await URLSessionRequest.insertStatsModel(params: [
                        "title": TimerManager.isCountingDown ? "countDown".localizable() : "countUp".localizable(),
                        "type": 0,
                        "focus_duration": 0,
                        "tagNames": "",
                        "category": NSNull(),
                        "color": 0,
                        "icon": 0,
                        "device_id": "",
                        "value": Int(elapsedTime * 1000),
                        "begin_time": TimerManager.beginTimestamp,
                        "finish_time": getCurrentTimeStampBySeconds() ,
                        "duration": 0,
                        "folder_id": NSNull(),
                        "mission_id": "",
                        "uid":uid
                    ])
                    print("err \(res)")

                }
                            
                        }
        }

        var endDate: Date

        if TimerManager.isCountingDown {
            let remainingTime = Double(timerDuration) - elapsedTime
            endDate = currentDate.addingTimeInterval(remainingTime)
            print("Timer is counting down. Remaining time: \(remainingTime) seconds")
            if remainingTime <= 0 {
                print("Timer has ended.")
                Task {
                    if TimerManager.hasRequest == false && TimerManager.isStopClick {
                        TimerManager.totalElapsedTime = 0
                        TimerManager.hasRequest = true
                        let res:BaseResponse? = await URLSessionRequest.insertStatsModel(params: [
                            "title": TimerManager.isCountingDown ? "countDown".localizable() : "countUp".localizable(),
                            "type": 0,
                            "focus_duration": 0,
                            "tagNames": "",
                            "category": NSNull(),
                            "color": 0,
                            "icon": 0,
                            "device_id": "",
                            "value": Int(timerDuration * 1000),
                            "begin_time": TimerManager.beginTimestamp,
                            "finish_time": getCurrentTimeStampBySeconds() ,
                            "duration": 0,
                            "folder_id": NSNull(),
                            "mission_id": "",
                            "uid": uid                        ])
                        print("err \(res)")

                    }
                                
                //                    let res:ResourceResponse? = await URLSessionRequest.requestSceneList(scene: "timehello_game");
                            }
            }
        } else {
            let totalTime = Double(timerDuration) + elapsedTime
            endDate = currentDate.addingTimeInterval(totalTime)
            print("Timer is counting up. Total time: \(totalTime) seconds")
        }

        let entry = SimpleEntry(date: currentDate, deliveryTimerDown: currentDate...endDate, deliveryTimerUp: Date.now.addingTimeInterval(-elapsedTime)...(Date.now.addingTimeInterval(1000000000)), isCountingDown: TimerManager.isCountingDown)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

// SimpleEntry: 定义时间线条目的结构
struct SimpleEntry: TimelineEntry {
    let date: Date // 当前日期
    let deliveryTimerDown: ClosedRange<Date> // 倒计时的时间范围
    let deliveryTimerUp: ClosedRange<Date> // 正计时的时间范围
    let isCountingDown: Bool // 标识是否为倒计时
}

// Test2WidgetEntryView: 定义Widget的视图布局
struct Test2WidgetEntryView : View {
    var entry: Provider.Entry // 时间线条目
    @AppStorage("timerDuration", store: UserDefaults(suiteName: Params.groupName)) var timerDuration : Int = 1500 // 25分钟
    @AppStorage("uid", store: UserDefaults(suiteName: Params.groupName)) var uid : String = ""
    @Environment(\.widgetFamily) var family

    func shouldShowBigButtons() -> Bool {
        if (family == .systemSmall) {
            return false;
        } else {
            return true;
        }
    }
    
     // currentDisplayedTime: 获取当前需要显示的时间（暂停时保留当前时间）
    func currentDisplayedTime() -> Int {
        let elapsedTime: Int
        if let startTime = TimerManager.startTime, !TimerManager.isPaused {
            // Timer is running
            elapsedTime = Int(TimerManager.totalElapsedTime + Date().timeIntervalSince(startTime))
        } else {
            // Timer is paused
            elapsedTime = Int(TimerManager.totalElapsedTime)
        }

        if TimerManager.isCountingDown {
            return max(timerDuration - elapsedTime, 0)
        } else {
            return elapsedTime
        }
    }
     
     // formatSeconds: 将秒数格式化为“mm:ss”的时间格式
     func formatSeconds(_ seconds: Int) -> String {
         let minutes = seconds / 60 // 计算分钟数
         let remainingSeconds = seconds % 60 // 计算剩余的秒数
         return String(format: "%02d:%02d", minutes, remainingSeconds) // 格式化时间为“mm:ss”
     }
      
     // body: 定义Widget的视图布局，包括倒计时/正计时的显示和操作按钮
     var body: some View {
         VStack {
//             Text(uid) // 显示倒计时或正计时状态
Text(TimerManager.isCountingDown ? "countDown".localizable() : "countUp".localizable()) // 显示倒计时或正计时状态
             Group {
                 if TimerManager.isPaused || TimerManager.startTime == nil {
                     Text(formatSeconds(currentDisplayedTime()))
                         .font(.system(size: 25)).fontWeight(.bold) // 显示当前时间，字体大小为25，加粗显示
                         .frame(maxWidth: .infinity) // 设置最大宽度以填充视图
                         .multilineTextAlignment(.center) // 居中对齐
                         .padding() // 添加内边距
                 } else {
                     Text(timerInterval: entry.isCountingDown ? entry.deliveryTimerDown : (entry.deliveryTimerUp), countsDown: entry.isCountingDown) // 显示计时器时间段
                         .font(.system(size: 25)).fontWeight(.bold) // 字体大小为25，加粗显示
                         .frame(maxWidth: .infinity) // 设置最大宽度以填充视图
                         .multilineTextAlignment(.center) // 居中对齐
                         .padding() // 添加内边距
                 }
             }
             HStack {
                 Button(intent: TimerIntent(action: TimerManager.isPaused ? .start : .pause)) {
                     Image(systemName: TimerManager.isPaused ? "play.fill" : "pause.fill") // 显示播放或暂停按钮
                         .font(.largeTitle) // 使用大标题样式
                         .foregroundColor(.blue) // 设置按钮颜色为蓝色
                 }
                 Button(intent: TimerIntent(action: .reset)) {
                     Image(systemName: "stop.fill") // 显示停止按钮
                         .font(.largeTitle) // 使用大标题样式
                         .foregroundColor(.red) // 设置按钮颜色为红色
                 }
                 if(TimerManager.isPaused || TimerManager.startTime == nil) {
                     Button(intent: TimerIntent(action: .toggleCountdown)) {
                         Image(systemName: TimerManager.isCountingDown ? "arrow.counterclockwise" : "arrow.clockwise") // 显示切换倒计时/正计时按钮
                             .font(.largeTitle) // 使用大标题样式
                             .foregroundColor(.green) // 设置按钮颜色为绿色
                     }
                 }
                 if(shouldShowBigButtons()) {
                     if(TimerManager.isCountingDown && (TimerManager.isPaused || TimerManager.startTime == nil)) {
                         Button(intent: TimerIntent(action: .addMinute)) {
                             Image(systemName: "plus.circle") // 显示增加一分钟按钮
                                 .font(.largeTitle) // 使用大标题样式
                                 .foregroundColor(.orange) // 设置按钮颜色为橙色
                         }
                         Button(intent: TimerIntent(action: .subtractMinute)) {
                             Image(systemName: "minus.circle") // 显示减少一分钟按钮
                                 .font(.largeTitle) // 使用大标题样式
                                 .foregroundColor(.purple) // 设置按钮颜色为紫色
                         }
                     }
                 }
             }
         }
         .padding() // 为整体视图添加内边距
     }
}

// Test2Widget: 定义小组件配置
struct Test2Widget: Widget {
    let kind: String = "Test2Widget" // 小组件的唯一标识符

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                Test2WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget) // 设置小组件背景
            } else {
                Test2WidgetEntryView(entry: entry)
                    .padding() // 为视图添加内边距
                    .background() // 设置视图背景
            }
        }
        .configurationDisplayName("timer".localizable()) // 小组件的显示名称
        .description("timer_desc".localizable()) // 小组件的描述
    }
}
