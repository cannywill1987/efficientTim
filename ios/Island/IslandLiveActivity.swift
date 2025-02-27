//
//  IslandLiveActivity.swift
//  Island
//
//  Created by 林智彬 on 2023/4/12.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

//struct TimerManager {
//    static var beginTimestamp: Int = 0;
//    static var endTimestamp: Int = 0;
//    static var timerDuration: Int = 1500 // Default 25 minutes
//    static var isCountingDown: Bool = true // Indicates whether it's counting down
//    static var isPaused: Bool = true // Default state is paused
//    static var startTime: Date? // Timer's start time
//    static var totalElapsedTime: TimeInterval = 0 // Total elapsed time
//    static var hasRequest: Bool = false // 是否发起请求
//    static var isPauseClick: Bool = false // 暂停按钮是否点击
//    static var isStopClick: Bool = false // 停止是否点击
//}



/**得到当前秒单位时间戳**/
func getCurrentTimeStampBySeconds() -> Int{
    let timeInterval: TimeInterval = Date().timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return timeStamp * 1000;
}



/**
 参考
 http://swiftcafe.io/post/dy-island
 */
struct IslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        
        // Dynamic stateful properties about your activity go here!
        var statusString: String
        var  totalTomatees: Int
        var numTomatees: Int
        var focusedDuration: String
        
        var bgUrl: String
        var title: String
        var text: String
        var value: Int
        var startTime: Date = Date() // Timer's start time
        //        var startTime: Date
        var deliveryTimer: ClosedRange<Date>?
        //    case focusing=0 //专注中 红色计时中
        //    case pausingFucusing=1 //专注暂停中
        //    case relaxing=2 //休息中 蓝色计时中
        //    case waitingToFocus=3 //等待专注中
        //    case waitingToStartRelaxing=4 //等待休息启动
        //    case pausingRelaixing=5 //暂停休息中
        //    case none=6 //没任何选择
        var counterStatusEnum: Int
        var isCountingDown: Bool
//

        var startTimeForElapse: Date? = Date()
        var timerDuration: Int = 1500 // Default 25 minutes
        var objectId: String?
        var beginTimestamp: Int = 0;
        var endTimestamp: Int = 0;
        var isPaused: Bool = false // Default state is paused
        var totalElapsedTime: TimeInterval = 0 // Total elapsed time
        var hasRequest: Bool = false // 是否发起请求
        var isPauseClick: Bool = false // 暂停按钮是否点击
        var isStopClick: Bool = false // 停止是否点击
        var focusDurationInt: Int = 1500 // 专注时长
        var restingDurationInt: Int = 300 // 休息时长
        var action: String? // 定义计时器的操作参数
        //        var isPaused: Bool = false
    }
    var numberOfPizzas: Int?
    var currentTimeStamp: Int?
    var time: Int?
    var objectId: String?
    // Fixed non-changing properties about your activity go here!
    var name: String
    var counterStatusEnum: Int?
}

enum CounterStatusEnum:Int {
    case focusing=0 //专注中 红色计时中
    case pausingFucusing=1 //专注暂停中
    case relaxing=2 //休息中 蓝色计时中
    case waitingToFocus=3 //等待专注中
    case waitingToStartRelaxing=4 //等待休息启动
    case pausingRelaixing=5 //暂停休息中
    case none=6 //没任何选择
}


enum TimerAction: String, AppEnum {
    case beginStart = "beginStart"
    case beginStop = "beginStop"
    case beginPause = "beginPause"
    case beginDone = "beginDone"
    case beginContinue = "beginContinue"
    case focusing = "focusing" //专注中 红色计时中
    case pausingFocusing = "pausingFocusing" //专注暂停中
    case relaxing = "relaxing" //休息中 蓝色计时中
    case waitingToFocus = "waitingToFocus" //等待专注中
    case waitingToStartRelaxing = "waitingToStartRelaxing" //等待休息启动
    case pausingRelaixing = "pausingRelaixing" //暂停休息中
    case non = "non" //没任何选择
    
    case start = "Start" // 启动计时器
    case pause = "Pause" // 暂停计时器
    case reset = "Reset" // 重置计时器
    case addMinute = "AddMinute" // 增加一分钟
    case subtractMinute = "SubtractMinute" // 减少一分钟
    case toggleCountdown = "ToggleCountdown" // 切换倒计时/正计时
    
    @available(iOS 16.0, *)
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Timer Action" // 定义枚举的显示类型
    }
    
    @available(iOS 16.0, *)
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .beginDone: "beginDone",
            .beginStart: "beginStart", // 启动操作的显示名
            .beginContinue: "continue",
            .beginPause: "beginPause",
            .beginStop: "beginStop",
            .focusing: "focusing", // 启动操作的显示名
            .pausingFocusing: "pausingFocusing", // 暂停操作的显示名
            .relaxing: "relaxing", // 重置操作的显示名
            .waitingToFocus: "waitingToFocus", // 增加一分钟的显示名
            .waitingToStartRelaxing: "waitingToStartRelaxing", // 减少一分钟的显示名
            .pausingRelaixing: "pausingRelaixing", // 切换倒计时/正计时的显示名
            .non: "non",
            .start: "Start", // 启动操作的显示名
            .pause: "Pause", // 暂停操作的显示名
            .reset: "Reset", // 重置操作的显示名
            .addMinute: "Add 1 Minute", // 增加一分钟的显示名
            .subtractMinute: "Subtract 1 Minute", // 减少一分钟的显示名
            .toggleCountdown: "Toggle Countdown/Countup" // 切换倒计时/正计时的显示名
        ]
    }
}

@available(iOS 16.2, *)
struct TimerIntent2: LiveActivityIntent {
//    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
//    @AppStorage("timerDuration", store: UserDefaults(suiteName: Params.groupName)) var timerDuration : Int = 1500 // 25分钟
    @AppStorage("uid", store: UserDefaults(suiteName: Params.groupName)) var uid : String = ""

    @Parameter(title: "Action")
    var action: TimerAction? // 定义计时器的操作参数
    
    
    init() {
        print();
    }
    
    
    init(action: TimerAction
//         ,
//         objectId: String? = nil,
//         statusString: String = "",
//         totalTomatees: Int = 0,
//         numTomatees: Int = 0,
//         focusedDuration: String = "",
//         bgUrl: String = "",
//         title: String = "",
//         text: String = "",
//         value: Int = 0,
//         startTime: Date = Date(),
//         deliveryTimerStartDate: Date = Date(),
//         deliveryTimerEndDate: Date = Date(),
//         counterStatusEnum: Int = 6,
//         isCountDown: Bool = false
    ) {
        self.action = action
//        self.objectId = objectId
//        self.statusString = statusString
//        self.totalTomatees = totalTomatees
//        self.numTomatees = numTomatees
//        self.focusedDuration = focusedDuration
//        self.bgUrl = bgUrl
//        self.title = title
//        self.text = text
//        self.value = value
//        self.startTime = startTime
//        self.deliveryTimerEndDate = deliveryTimerEndDate ?? Date()
//        self.deliveryTimerStartDate = deliveryTimerStartDate  ?? Date()
//        self.counterStatusEnum = counterStatusEnum
//        self.isCountDown = isCountDown
    }
    
    static var title: LocalizedStringResource = "Toggle Mission State"
    
    static func formatTimestampToDateString(timestamp: Int) -> String {
        // 将 timestamp 从毫秒转换为秒
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        
        // 设置日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 将日期对象格式化为字符串
        return dateFormatter.string(from: date)
    }
    
    @Parameter(title: "Mission ID")
    var missionID: String?
    init(missionID: String) {
        self.missionID = missionID
    }
    
    /**得到当前毫秒时间戳**/
    static  func getCurrentTimeStampByMilliSeconds() -> CLongLong{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond;
    }
    
    func stopAllActivity() async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            // 结束活动并选择消失策略（例如立即消失）
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
 
    
    func updateAllActivityByStartTimeForElapse(val: Date?) async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            state.startTimeForElapse = val
            // 结束活动并选择消失策略（例如立即消失）
            await activity.update(using: state)
        }
        
    }
    
    func updateAllActivity(counterStatusEnum: Int, totalElapsedTime: TimeInterval, isPause: Bool, startTimeForElapse: Date?, beginTimestamp: Int?, action: String?, timerDuration: Int?) async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            state.counterStatusEnum = counterStatusEnum
            state.totalElapsedTime = totalElapsedTime
            state.isPaused = isPause
            if(timerDuration != nil) {
                state.timerDuration = timerDuration!
            }
            if(beginTimestamp != nil) {
                state.beginTimestamp = beginTimestamp!
            }
            if(action != nil) {
                state.action = action!
            }
            
            //state.beginTimestamp = beginTimestamp
            state.startTimeForElapse = startTimeForElapse
            // 结束活动并选择消失策略（例如立即消失）
            await activity.update(using: state)
        }
    }
    
    //    case focusing=0 //专注中 红色计时中
    //    case pausingFucusing=1 //专注暂停中
    //    case relaxing=2 //休息中 蓝色计时中
    //    case waitingToFocus=3 //等待专注中
    //    case waitingToStartRelaxing=4 //等待休息启动
    //    case pausingRelaixing=5 //暂停休息中
    //    case none=6 //没任何选择
//    var counterStatusEnum: Int
    func updateAllActivityByCounterStatusEnum(val: Int) async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            state.counterStatusEnum = val
            // 结束活动并选择消失策略（例如立即消失）
            await activity.update(using: state)
        }
    }
    
    func updateAllActivityByTotalElapsedTime(totalElapsedTime: TimeInterval) async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            state.totalElapsedTime = totalElapsedTime
            // 结束活动并选择消失策略（例如立即消失）
            await activity.update(using: state)
        }
    }
    
    func getAllActivityByTotalElapsedTime() async -> TimeInterval{
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            return state.totalElapsedTime
        }
        return 0
    }
    
    func getAllActivityByTotalStartTimeElapse() async -> Date?{
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            return state.startTimeForElapse
        }
        return nil
    }
    
    func getAllActivityByState() async -> IslandAttributes.ContentState? {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            return state
        }
        return nil
    }
    
    func getAllActivityByTotalStartTime() async -> Date?{
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            return state.startTime
        }
        return nil
    }
    
    
    func updateAllActivityByBeginTimestamp(beginTimestamp: Int) async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            state.beginTimestamp = beginTimestamp
            // 结束活动并选择消失策略（例如立即消失）
            await activity.update(using: state)
        }
    }
    
    
    func updateAllActivityByPause(isPause: Bool) async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            var state:IslandAttributes.ContentState = activity.content.state;
            state.isPaused = isPause
            // 结束活动并选择消失策略（例如立即消失）
            await activity.update(using: state)
        }
    }
    
//    func currentDisplayedTime(state:IslandAttributes.ContentState) -> Int {
//        let elapsedTime: Int
//        let startTime = state.startTimeForElapse
//        if startTime != nil, !state.isPaused {
//            // Timer is running
//            elapsedTime = Int(state.totalElapsedTime)
//        } else {
//            // Timer is paused
//            elapsedTime = Int(state.totalElapsedTime)
//        }
//        
//        if state.isCountingDown {
//            return max(state.timerDuration - elapsedTime, 0)
//        } else {
//            return elapsedTime
//        }
//    }
    
    
    func perform() async throws -> some IntentResult {
        Task {
            switch action {
            case .beginPause:
                var startDateTime = await getAllActivityByTotalStartTimeElapse()
                if startDateTime == nil {
                    startDateTime = await getAllActivityByTotalStartTime()
                }
                
                var  totalElapsedTime = await getAllActivityByTotalElapsedTime()
                totalElapsedTime +=  Date().timeIntervalSince(startDateTime ?? Date())
                print("totalElapsedTime \(totalElapsedTime)")
                await self.updateAllActivity(counterStatusEnum: 1, totalElapsedTime: totalElapsedTime, isPause: true, startTimeForElapse: nil, beginTimestamp: nil, action: "beginPause", timerDuration: nil)
                break;
            case .beginContinue:
                var  totalElapsedTime = await getAllActivityByTotalElapsedTime()

                await self.updateAllActivity(counterStatusEnum: 0, totalElapsedTime: TimeInterval(totalElapsedTime), isPause: false, startTimeForElapse: Date(), beginTimestamp: nil, action: "beginContinue", timerDuration: nil)
                break;
            case .beginDone:
                Task {
                    try? await Task.sleep(nanoseconds: 1000_000_000) // 3秒自动关闭 方便发起 请求
                    await self.stopAllActivity()
                }
                break;
            case .beginStart:
                let state:IslandAttributes.ContentState? = await getAllActivityByState()

                //0 专注中 红色计时中 3 等待专注中 4 等待休息启动
                await self.updateAllActivity(counterStatusEnum: state?.counterStatusEnum == 0 ? 4 : 3, totalElapsedTime: TimeInterval(0), isPause: true, startTimeForElapse: nil, beginTimestamp: getCurrentTimeStampBySeconds(), action: "beginStart", timerDuration: nil)
                break;
            case .beginStop: // 停止 关闭
                var  totalElapsedTime = await getAllActivityByTotalElapsedTime()
                let state:IslandAttributes.ContentState? = await getAllActivityByState()
//                if TimerManager.hasRequest == false && TimerManager.isStopClick {
//                    TimerManager.totalElapsedTime = 0
//                    TimerManager.hasRequest = true
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000) // 3秒自动关闭 方便发起 请求
                    await self.stopAllActivity()
                }
                //0 专注中 红色计时中 3 等待专注中 4 等待休息启动
//                let nextStatus: Int = state?.counterStatusEnum == 0 ? 4 : 3
//                let ti = nextStatus == 3 ? (state?.restingDurationInt ?? 300): (state?.focusDurationInt ?? 1500)

//                await self.updateAllActivity(counterStatusEnum: nextStatus, totalElapsedTime: 0, isPause: false, startTimeForElapse: Date(), beginTimestamp: nil, action: "beginStop", timerDuration:  ti)
//                currentDisplayedTime(state: state!)
                if (state?.action != "beginStop") {
                    print("\(uid)")
                    let res:BaseResponse? = await URLSessionRequest.insertStatsModel(params: [
                        "title": state?.title ?? ((state?.isCountingDown ?? true) ? "countDown".localizable() : "countUp".localizable()),
                        "type": 0,
                        "focus_duration": 0,
                        "tagNames": "",
                        "category": NSNull(),
                        "color": 0,
                        "icon": 0,
                        "device_id": "",
                        "value": Int(totalElapsedTime * 1000),
                        "begin_time": state?.beginTimestamp,
                        "finish_time": getCurrentTimeStampBySeconds() ,
                        "duration": 0,
                        "folder_id": NSNull(),
                        "mission_id": "",
                        "uid":uid
                    ])
                    print("err \(res)")
                
                }
              
//                }
                
                break;
            case .focusing:
                break;
            case .pausingFocusing:
                break;
            case .relaxing:
                break;
            case .waitingToFocus:
                break;
            case .waitingToStartRelaxing:
                break;
            case .pausingRelaixing:
                break;
            case .non:
                break;
            case .none:
                break;

            case .start:
                //                TimerManager.beginTimestamp = getCurrentTimeStampBySeconds();
                //                TimerManager.hasRequest = false;
                //                TimerManager.isPaused = false
                //                TimerManager.startTime = Date() // Set startTime to current date
                //                WidgetCenter.shared.reloadAllTimelines()
                //                TimerManager.isPauseClick = false;
                //                TimerManager.isStopClick = false;
                break;
            case .pause:
                //                TimerManager.isPauseClick = true;
                //                TimerManager.isPaused = true
                //                TimerManager.endTimestamp = getCurrentTimeStampBySeconds();
                //                if let startTime = TimerManager.startTime {
                //                    TimerManager.totalElapsedTime += Date().timeIntervalSince(startTime) // Accumulate elapsed time
                //                    TimerManager.startTime = nil // Clear startTime
                //                }
                //                WidgetCenter.shared.reloadAllTimelines()
                break;
            case .reset:
                //                if let startTime = TimerManager.startTime {
                //                    TimerManager.totalElapsedTime += Date().timeIntervalSince(startTime) // Accumulate elapsed time
                //                    TimerManager.startTime = nil // Clear startTime
                //                }
                //                TimerManager.isPaused = true
                //                TimerManager.timerDuration = TimerManager.isCountingDown ? timerDuration : 0
                //                TimerManager.startTime = nil
                //                TimerManager.isStopClick = true;
                //                WidgetCenter.shared.reloadAllTimelines()
                break;
            case .addMinute:
                //                if TimerManager.isPaused { // 如果计时器处于暂停状态
                //                    TimerManager.timerDuration += 60 // 增加一分钟
                //                    timerDuration = TimerManager.timerDuration // 更新存储值
                //                    WidgetCenter.shared.reloadAllTimelines() // 刷新所有小组件时间线
                //                }
                break;
            case .subtractMinute:
                //                if TimerManager.isPaused && TimerManager.timerDuration > 60 { // 如果计时器处于暂停状态且时长大于一分钟
                //                    TimerManager.timerDuration -= 60 // 减少一分钟
                //                    timerDuration = TimerManager.timerDuration // 更新存储值
                //                    WidgetCenter.shared.reloadAllTimelines() // 刷新所有小组件时间线
                //                }
                break;
            case .toggleCountdown:
                //                if TimerManager.isPaused { // 如果计时器处于暂停状态
                //                    TimerManager.isCountingDown.toggle() // 切换倒计时/正计时状态
                //                    TimerManager.timerDuration = TimerManager.isCountingDown ? timerDuration : 0 // 根据模式更新计时器时长
                //                    WidgetCenter.shared.reloadAllTimelines() // 刷新所有小组件时间线
                //                }
                break;
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        return .result()
    }
    
}


//case focusing=0 //专注中 红色计时中
//case pausingFucusing=1 //专注暂停中
//case relaxing=2 //休息中 蓝色计时中
//case waitingToFocus=3 //等待专注中
//case waitingToStartRelaxing=4 //等待休息启动
//case pausingRelaixing=5 //暂停休息中
//case none=6 //没任何选择
@available(iOS 17, *)
struct TimerActivityView: View {
    let context: ActivityViewContext<IslandAttributes>
    @AppStorage("uid", store: UserDefaults(suiteName: Params.groupName)) var uid : String = ""
//    @AppStorage("timerDuration", store: UserDefaults(suiteName: Params.groupName)) var timerDuration : Int = 1500 // 25分钟
    @State private var isRunning = false // Add boolean variable
    @Environment(\.colorScheme) var colorScheme
    var btnWidth:CGFloat = 77;
    var fontSize:CGFloat = 13;
    @State private var countdownTimer: Timer?

    init(context: ActivityViewContext<IslandAttributes>) {
        self.context = context
        print("")
//        NetworkRequest.shared.console(pairParameters: ["id": "aaaaaaaaaa"])
        //TimerManager.isPaused = false
    }
    
    func handleEndOfTimer() async {
//        let state: IslandAttributes.ContentState? = context.state
//        let totalElapsedTime = state?.totalElapsedTime ?? 0
//        
//        NetworkRequest.shared.console(pairParameters: ["id": "aaaaaaaaaa"])

        // 确保是计时结束时才进行数据上报
//        if state?.action != "beginStop" {
////            print("\(uid)")
//            let res: BaseResponse? = await URLSessionRequest.insertStatsModel(params: [
//                "title": state?.title ?? ((state?.isCountingDown ?? true) ? "countDown".localizable() : "countUp".localizable()),
//                "type": 0,
//                "focus_duration": 0,
//                "tagNames": "",
//                "category": NSNull(),
//                "color": 0,
//                "icon": 0,
//                "device_id": "",
//                "value": Int(totalElapsedTime * 1000),
//                "begin_time": state?.beginTimestamp,
//                "finish_time": getCurrentTimeStampBySeconds(),
//                "duration": 0,
//                "folder_id": NSNull(),
//                "mission_id": "",
//                "uid": uid
//            ])
//            print("上报数据结果: \(String(describing: res))")
//        }

    }
    
   
    func scheduleTimerForCompletion(after duration: Int) {
        // 确保之前的定时器被销毁
        countdownTimer?.invalidate()

        // 创建一个新的定时器，在 duration 秒后触发
        countdownTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { [self] _ in
            Task {
                // 直接调用上报数据逻辑
                await handleEndOfTimer()
            }
        }
    }

    
     func initDatas() {
        //TimerManager.isPaused = false
//        self.scheduleTimerForCompletion(after: 3)
    }
    
    // formatSeconds: 将秒数格式化为“mm:ss”的时间格式
    func formatSeconds(_ seconds: Int) -> String {
        let minutes = seconds / 60 // 计算分钟数
        let remainingSeconds = seconds % 60 // 计算剩余的秒数
        return String(format: "%02d:%02d", minutes, remainingSeconds) // 格式化时间为“mm:ss”
    }
    
    // currentDisplayedTime: 获取当前需要显示的时间（暂停时保留当前时间）
    func currentDisplayedTime() -> Int {
        let elapsedTime: Int
        let startTime = context.state.startTimeForElapse
        if startTime != nil, !context.state.isPaused {
            // Timer is running
            elapsedTime = Int(context.state.totalElapsedTime)
        } else {
            // Timer is paused
            elapsedTime = Int(context.state.totalElapsedTime)
        }
        
        if context.state.isCountingDown {
            return max(context.state.timerDuration - elapsedTime, 0)
        } else {
            return elapsedTime
        }
    }
    
    func getDeliveredTime() -> ClosedRange<Date>  {
        let elapsedTime: TimeInterval
        let startTime = context.state.startTimeForElapse

        if startTime != nil, !context.state.isPaused {
            // Timer is running
            elapsedTime = TimeInterval(context.state.totalElapsedTime)
        } else {
            // Timer is paused
            elapsedTime = TimeInterval(context.state.totalElapsedTime)
        }
        let remainingTime = Double(context.state.timerDuration) - elapsedTime
        let currentDate = Date()

        let endDate:Date = currentDate.addingTimeInterval(remainingTime)
        
//        let currentDate = Date()
//        var endDate: Date

        
        if context.state.isCountingDown {
            return currentDate...endDate
        } else {
            return Date.now.addingTimeInterval(-elapsedTime)...(Date.now.addingTimeInterval(1000000000))
        }
    }
    
    func getItem(action: TimerAction) -> TimerIntent2 {
        
        return TimerIntent2(
            action: action
        );
        
        
    }
    
    
    var body: some View {
        
        ZStack {
            // Left section
            VStack(alignment: .leading, spacing: 5) {
                //                || TimerManager.startTime == nil
//                if context.state.isPaused {
//                    Text(formatSeconds(currentDisplayedTime()))
//                        .font(.system(size: 25)).fontWeight(.bold) // 显示当前时间，字体大小为25，加粗显示
//                        .frame(maxWidth: .infinity) // 设置最大宽度以填充视图
//                        .multilineTextAlignment(.center) // 居中对齐
//                        .padding() // 添加内边距
//                } else {
//                    Text(timerInterval: getDeliveredTime(), countsDown: context.state.isCountingDown) // 显示计时器时间段
//                        .font(.system(size: 25)).fontWeight(.bold) // 字体大小为25，加粗显示
//                        .frame(maxWidth: .infinity) // 设置最大宽度以填充视图
//                        .multilineTextAlignment(.center) // 居中对齐
//                        .padding() // 添加内边距
//                }
                
                Text("\(context.state.title)")
                    .font(.system(size: 14)) // Set title font size to 12
                
                if context.state.isPaused {
                                   Text(formatSeconds(currentDisplayedTime()))
                        .font(.system(size: 25)).fontWeight(.bold) // Set time
                        .font(.caption2)
                               } else {
                                   Text(timerInterval: getDeliveredTime(), countsDown: context.state.isCountingDown) // 显示计时器时间段
                                       .font(.system(size: 30)).fontWeight(.bold) // Set time
                                       .font(.caption2)
                               }
                
                
//                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
//                    if(context.state.isCountingDown) {
//                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountingDown)
//                            .font(.system(size: 25)).fontWeight(.bold) // Set time
//                            .font(.caption2)
//                    } else {
//                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountingDown)
//                            .font(.system(size: 30)).fontWeight(.bold) // Set time
//                            .font(.caption2)
//                    }
//                } else {
//                    Text(context.state.text)
//                        .font(.system(size: 30)).fontWeight(.bold) // Set time
//                        .font(.caption2)
//                }
                Divider()
                HStack {
                    Image("focusing")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        .aspectRatio(contentMode: ContentMode.fit)
                    Text("\(context.state.numTomatees)")
                        .font(.system(size: 14)).padding(.trailing, 5)
                    Divider().background(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                    Image("resting")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                    
                        .aspectRatio(contentMode: ContentMode.fit)
                    //                        .clipShape(Circle())
                    Text("\(context.state.totalTomatees)")
                        .font(.system(size: 14)).padding(.trailing, 5)
                    Divider().background(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                    Text(context.state.focusedDuration)
                        .font(.system(size: 14))
                }
            }
            // Right section
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if(context.state.counterStatusEnum == 0) { //专注中 红色计时中
                        ZStack {
//                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
//                                .frame(width: btnWidth, height: 40)
//                                .cornerRadius(30)
//                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginPause)) {
                                Image(systemName: "pause.fill") // 显示停止按钮
                                       .font(.largeTitle) // 使用大标题样式
                                       .foregroundColor(.blue) // 设置按钮颜色为红色
                                       .padding() // 给图片增加内边距
                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
                                
//                                Text("Pause")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
//                                //                        .background()
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 0)
//                                    .font(.system(size: fontSize, weight: .bold))
//                                    .cornerRadius(10)
                            }     .buttonStyle(PlainButtonStyle())
                                .background(Color.clear)
//                            .widgetURL(URL(string: "http://www.apple.com"))
//                            .disabled(false)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 1) { // 专注暂停中 //pausingFucusing
                        ZStack {
//                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
//                                .frame(width: btnWidth, height: 40)
//                                .cornerRadius(30)
//                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginContinue)) {
                                Image(systemName: "play.fill") // 显示停止按钮
                                       .font(.largeTitle) // 使用大标题样式
                                       .foregroundColor(.blue) // 设置按钮颜色为红色
                                       .padding() // 给图片增加内边距
                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
//                                Text("Continue")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 0)
//                                    .font(.system(size: fontSize, weight: .bold))
//                                    .cornerRadius(10)
                            }     .buttonStyle(PlainButtonStyle())
                                .background(Color.clear)
//                            .widgetURL(URL(string: "http://www.apple.com"))
//                            .disabled(false)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .frame(width: 60)
                        }.padding(.trailing, 5)
                        ZStack {
//                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
//                                .frame(width: btnWidth, height: 40)
//                                .cornerRadius(30)
//                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Image(systemName: "stop.fill") // 显示停止按钮
                                       .font(.largeTitle) // 使用大标题样式
                                       .foregroundColor(.red) // 设置按钮颜色为红色
                                       .padding() // 给图片增加内边距
                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
                                
//                                Text("Stop")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
//                                
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 0)
//                                    .font(.system(size: fontSize, weight: .bold))
//                                    .cornerRadius(10)
                            }     .buttonStyle(PlainButtonStyle())
                                .background(Color.clear)
//                            .widgetURL(URL(string: "http://www.apple.com"))
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .frame(width: 60)
                        }.padding(.trailing, 5)
                        
                    } else  if(context.state.counterStatusEnum == 2) { //休息中 蓝色计时中
                        ZStack {
//                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
//                                .frame(width: btnWidth, height: 40)
//                                .cornerRadius(30)
//                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginDone)) {
                                Image(systemName: "stop.fill") // 显示停止按钮
                                       .font(.largeTitle) // 使用大标题样式
                                       .foregroundColor(.red) // 设置按钮颜色为红色
                                       .padding() // 给图片增加内边距
                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
//                                Image(systemName: "done.fill") // 显示停止按钮
//                                       .font(.largeTitle) // 使用大标题样式
//                                       .foregroundColor(.red) // 设置按钮颜色为红色
//                                       .padding() // 给图片增加内边距
//                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
                                
//                                Text("Done")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
//                                //                        .background()
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 0)
//                                    .font(.system(size: fontSize, weight: .bold))
//                                    .cornerRadius(10)
                            }     .buttonStyle(PlainButtonStyle())
                                .background(Color.clear)
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 3) { //等待专注中
                        ZStack {
//                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
//                                .frame(width: btnWidth, height: 40)
//                                .cornerRadius(30)
//                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Image(systemName: "play.fill") // 显示停止按钮
                                       .font(.largeTitle) // 使用大标题样式
                                       .foregroundColor(.blue) // 设置按钮颜色为红色
                                       .padding() // 给图片增加内边距
                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
//                                Text("Start")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
//                                //                        .background()
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 0)
//                                    .font(.system(size: fontSize, weight: .bold))
//                                    .cornerRadius(10)
                            }     .buttonStyle(PlainButtonStyle())
                                .background(Color.clear)
//                            .widgetURL(URL(string: "http://www.apple.com"))
//                            .disabled(false)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 4) { //等待休息启动 waitingToStartRelaxing
                        ZStack {
//                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
//                                .frame(width: btnWidth, height: 40)
//                                .cornerRadius(30)
//                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Image(systemName: "play.fill") // 显示停止按钮
                                       .font(.largeTitle) // 使用大标题样式
                                       .foregroundColor(.blue) // 设置按钮颜色为红色
                                       .padding() // 给图片增加内边距
                                       .background(Circle().fill(Color.gray.opacity(0.2))) // 添加淡灰色圆形背景
//                                Text("Start")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
//                                //                        .background()
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 0)
//                                    .font(.system(size: fontSize, weight: .bold))
//                                    .cornerRadius(10)
                            }     .buttonStyle(PlainButtonStyle())
                                .background(Color.clear)
//                            .widgetURL(URL(string: "http://www.apple.com"))
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 5) { // 暂停休息中 //pausingRelaixing
                    }
                    
                }.frame(height: 60)
                    .padding(.vertical, 10)
                    .padding(.bottom, 35)
            }
            .frame(height: 50)
            .padding(.vertical, 10)
            .padding(.horizontal, 0)
        }.padding(.vertical, 16)
            .padding(.leading, 10).padding(.trailing,5).onAppear {
                // 在视图显示时进一步初始化
//                self.initDatas()
            }
        
    }
}






@available(iOS 17, *)
struct IslandLiveActivity: Widget {
    // formatSeconds: 将秒数格式化为“mm:ss”的时间格式
    func formatSeconds(_ seconds: Int) -> String {
        let minutes = seconds / 60 // 计算分钟数
        let remainingSeconds = seconds % 60 // 计算剩余的秒数
        return String(format: "%02d:%02d", minutes, remainingSeconds) // 格式化时间为“mm:ss”
    }
    
    func getDeliveredTime(context: ActivityViewContext<IslandAttributes>) -> ClosedRange<Date>  {
        let elapsedTime: TimeInterval
        let startTime = context.state.startTimeForElapse

        if startTime != nil, !context.state.isPaused {
            // Timer is running
            elapsedTime = TimeInterval(context.state.totalElapsedTime)
        } else {
            // Timer is paused
            elapsedTime = TimeInterval(context.state.totalElapsedTime)
        }
        let remainingTime = Double(context.state.timerDuration) - elapsedTime
        let currentDate = Date()

        let endDate:Date = currentDate.addingTimeInterval(remainingTime)
        
//        let currentDate = Date()
//        var endDate: Date

        
        if context.state.isCountingDown {
            return currentDate...endDate
        } else {
            return Date.now.addingTimeInterval(-elapsedTime)...(Date.now.addingTimeInterval(1000000000))
        }
    }
    
    // currentDisplayedTime: 获取当前需要显示的时间（暂停时保留当前时间）
    func currentDisplayedTime(context: ActivityViewContext<IslandAttributes>) -> Int {
        
        let timerDuration: Int = context.state.timerDuration
        let elapsedTime: Int
        let startTime = context.state.startTimeForElapse
        if startTime != nil, !context.state.isPaused {
            // Timer is running
            elapsedTime = Int(context.state.totalElapsedTime)
        } else {
            // Timer is paused
            elapsedTime = Int(context.state.totalElapsedTime)
        }
        
        if context.state.isCountingDown {
            return max(timerDuration - elapsedTime, 0)
        } else {
            return elapsedTime
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandAttributes.self) { context in
            // Lock screen/banner UI goes here
            //锁屏界面
            TimerActivityView(context: context)
            //            VStack {
            //                Text("Hello")
            //            }
            //            .activityBackgroundTint(Color.cyan)
            //            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Label {
                        Text("\(context.state.title)").lineLimit(1)
//                        Text("\(context.state.title)-\(context.state.totalElapsedTime)-\(context.state.isCountingDown)-\(context.state.isPaused )").lineLimit(1)
                    } icon: {
                        if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 1 || context.state.counterStatusEnum == 3) {
                            Image("focusing")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        } else {
                            Image("resting")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        }
                        
                    }
                    .font(.caption2)
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Text(context.state.startTime, style: .timer)
//                        .multilineTextAlignment(.center)
//                        .frame(width: 40)
//                        .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)))
//                        .font(.caption2)
                    
                    if context.state.isPaused {
                        Text(formatSeconds(currentDisplayedTime(context: context)))
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)))
                            .font(.caption2)
                                   } else {
                                       Text(timerInterval: getDeliveredTime(context: context), countsDown: context.state.isCountingDown) // 显示计时器时间段
                                           .multilineTextAlignment(.center)
                                           .frame(width: 40)
                                           .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)))
                                           .font(.caption2)
                                   }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    TimerActivityView(context: context)
                    //                    Text("Bottom")
                    // more content
                }
            } compactLeading: { //灵动岛 左边 右边
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 1 || context.state.counterStatusEnum == 3) {
                    Image("focusing")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                } else {
                    Image("resting")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                }
            } compactTrailing: {
                //                var countdown: Bool = false; //开始计时
                //case focusing=0 //专注中 红色计时中
                //case pausingFucusing=1 //专注暂停中
                //case relaxing=2 //休息中 蓝色计时中
                //case waitingToFocus=3 //等待专注中
                //case waitingToStartRelaxing=4 //等待休息启动
                //case pausingRelaixing=5 //暂停休息中
                //case none=6 //没任何选择
                if context.state.isPaused {
                    Text(formatSeconds(currentDisplayedTime(context: context)))
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .font(.caption2)
                    
                               } else {
                                   Text(timerInterval: getDeliveredTime(context: context), countsDown: context.state.isCountingDown) // 显示计时器时间段
                                       .font(.system(size: 14)).fontWeight(.bold) // 字体大小为25，加粗显示
                                                        .frame(maxWidth: .infinity) // 设置最大宽度以填充视图
                                                        .multilineTextAlignment(.center) // 居中对齐
                                                        .padding() // 添加内边距
                               }
                
            } minimal: {
                //                Text("Min") //最最小状态
                
                
                if context.state.isPaused {
                    Text(formatSeconds(currentDisplayedTime(context: context)))
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.caption2)
                               } else {
                                   Text(timerInterval: getDeliveredTime(context: context), countsDown: context.state.isCountingDown) // 显示计时器时间段
                                       .multilineTextAlignment(.center)
                                       .monospacedDigit()
                                       .font(.caption2)
                               }
                
//                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
//                    if(context.state.isCountingDown) {
//                        
//                        VStack(alignment: .center) {
//                            Image(systemName: "timer")
//                            Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountingDown)
//                                .multilineTextAlignment(.center)
//                                .monospacedDigit()
//                                .font(.caption2)
//                        }
//                    } else {
//                        VStack(alignment: .center) {
//                            Image(systemName: "timer")
//                            Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountingDown)
//                                .multilineTextAlignment(.center)
//                                .monospacedDigit()
//                                .font(.caption2)
//                        }
//                    }
//                } else {
//                    VStack(alignment: .center) {
//                        Image(systemName: "timer")
//                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountingDown)
//                            .multilineTextAlignment(.center)
//                            .monospacedDigit()
//                            .font(.caption2)
//                    }
//                }
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}



@available(iOS 16.2, *)
struct IslandLiveActivity_Previews: PreviewProvider {
    static let attributes = IslandAttributes(numberOfPizzas:123, name: "Me")
    
    static let contentState = IslandAttributes.ContentState(statusString: "", totalTomatees: 0, numTomatees: 0, focusedDuration: "0mins", bgUrl: "", title: "", text: "", value: 3, counterStatusEnum: 6, isCountingDown: true)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
