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
    case continue2 = "continue2"
    case focusing = "focusing" //专注中 红色计时中
    case pausingFocusing = "pausingFocusing" //专注暂停中
    case relaxing = "relaxing" //休息中 蓝色计时中
    case waitingToFocus = "waitingToFocus" //等待专注中
    case waitingToStartRelaxing = "waitingToStartRelaxing" //等待休息启动
    case pausingRelaixing = "pausingRelaixing" //暂停休息中
    case non = "non" //没任何选择
    
    @available(iOS 16.0, *)
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Timer Action" // 定义枚举的显示类型
    }
    
    @available(iOS 16.0, *)
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .beginStart: "beginStart", // 启动操作的显示名
            .continue2: "continue",
            .beginPause: "beginPause",
            .beginStop: "beginStop",
            .focusing: "focusing", // 启动操作的显示名
            .pausingFocusing: "pausingFocusing", // 暂停操作的显示名
            .relaxing: "relaxing", // 重置操作的显示名
            .waitingToFocus: "waitingToFocus", // 增加一分钟的显示名
            .waitingToStartRelaxing: "waitingToStartRelaxing", // 减少一分钟的显示名
            .pausingRelaixing: "pausingRelaixing", // 切换倒计时/正计时的显示名
            .non: "non"
        ]
    }
}



struct TimerManager {
    static var beginTimestamp: Int = 0;
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
    @State private var isRunning = false // Add boolean variable
    @Environment(\.colorScheme) var colorScheme
    var btnWidth:CGFloat = 77;
    var fontSize:CGFloat = 13;
    func getItem(action: TimerAction) -> TimerIntent2 {
            
            return TimerIntent2(
                action: action,
                objectId: context.state.objectId,
                statusString: context.state.statusString,
                totalTomatees: context.state.totalTomatees,
                numTomatees: context.state.numTomatees,
                focusedDuration: context.state.focusedDuration,
                bgUrl: context.state.bgUrl,
                title: "123",
                text: context.state.text,
                value: context.state.value,
                startTime: context.state.startTime,
                deliveryTimerStartDate: context.state.deliveryTimer?.lowerBound ?? Date(),
                deliveryTimerEndDate: context.state.deliveryTimer?.upperBound ?? Date(),
                counterStatusEnum: context.state.counterStatusEnum,
                isCountDown: context.state.isCountDown
            );
            
            
        }
        
    
    var body: some View {
        ZStack {
            // Left section
            VStack(alignment: .leading, spacing: 5) {
                Text(context.state.title)
                    .font(.system(size: 14)) // Set title font size to 12
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
                    if(context.state.isCountDown) {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .font(.system(size: 25)).fontWeight(.bold) // Set time
                            .font(.caption2)
                    } else {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .font(.system(size: 30)).fontWeight(.bold) // Set time
                            .font(.caption2)
                    }
                } else {
                    Text(context.state.text)
                        .font(.system(size: 30)).fontWeight(.bold) // Set time
                        .font(.caption2)
                }
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
                    if(context.state.counterStatusEnum == 0) { //focusing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginPause)) {
                                Text("Pause")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .disabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 1) { //pausingFucusing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Text("Continue")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .disabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Text("Stop")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                        
                    } else  if(context.state.counterStatusEnum == 2) { //relaxing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Text("Done")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 3) { //waitingToFocus
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Text("Start")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .disabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 4) { // waitingToStartRelaxing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(intent: TimerIntent2( action: .beginStop)) {
                                Text("Start")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 5) { //pausingRelaixing
                    }
                    
                }.frame(height: 60)
                    .padding(.vertical, 10)
                    .padding(.bottom, 35)
            }
            .frame(height: 50)
            .padding(.vertical, 10)
            .padding(.horizontal, 0)
        }.padding(.vertical, 16)
            .padding(.leading, 10).padding(.trailing,5)
        
    }
}

@available(iOS 16.2, *)
struct TimerIntent2: LiveActivityIntent {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    @Parameter(title: "objectId")
    var objectId: String?

    @Parameter(title: "statusString")
    var statusString: String?

    @Parameter(title: "totalTomatees")
    var totalTomatees: Int?
//
    @Parameter(title: "numTomatees")
    var numTomatees: Int?

    @Parameter(title: "focusedDuration")
    var focusedDuration: String?

    @Parameter(title: "bgUrl")
    var bgUrl: String?

    @Parameter(title: "title")
    var title: String?

    @Parameter(title: "text")
    var text: String?

    @Parameter(title: "value")
    var value: Int?

    @Parameter(title: "startTime")
    var startTime: Date?

    @Parameter(title: "deliveryTimerStartDate")
    var deliveryTimerStartDate: Date? // 新增属性，表示 ClosedRange 的起始时间
    
    @Parameter(title: "deliveryTimerEndDate")
        var deliveryTimerEndDate: Date? // 新增属性，表示 ClosedRange 的结束时间

    @Parameter(title: "deliveryTimer")
    var deliveryTimer: Date?
    
    @Parameter(title: "counterStatusEnum")
    var counterStatusEnum: Int?

    @Parameter(title: "isCountDown")
    var isCountDown: Bool?

    @Parameter(title: "Action")
    var action: TimerAction? // 定义计时器的操作参数
    
    
    init() {
        print();
    }
    
                
                init(action: TimerAction
                     ,
                     objectId: String? = nil,
                     statusString: String = "",
                     totalTomatees: Int = 0,
                     numTomatees: Int = 0,
                     focusedDuration: String = "",
                     bgUrl: String = "",
                     title: String = "",
                     text: String = "",
                     value: Int = 0,
                     startTime: Date = Date(),
                     deliveryTimerStartDate: Date = Date(),
                     deliveryTimerEndDate: Date = Date(),
                     counterStatusEnum: Int = 6,
                     isCountDown: Bool = false
                ) {
                    self.action = action
                    self.objectId = objectId
                    self.statusString = statusString
                    self.totalTomatees = totalTomatees
                    self.numTomatees = numTomatees
                    self.focusedDuration = focusedDuration
                    self.bgUrl = bgUrl
                    self.title = title
                    self.text = text
                    self.value = value
                    self.startTime = startTime
                    self.deliveryTimerEndDate = deliveryTimerEndDate ?? Date()
                    self.deliveryTimerStartDate = deliveryTimerStartDate  ?? Date()
                    self.counterStatusEnum = counterStatusEnum
                    self.isCountDown = isCountDown
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
    
    func perform() async throws -> some IntentResult {
        Task {
            switch action {
                // In the 'start' case:
            case .beginPause:
                let objectId = self.missionID ?? "";
                let timestamp = TimerIntent2.getCurrentTimeStampByMilliSeconds();
//                LiveActivityManager.shareInstance().stopActivity();
                NetworkRequest.shared.console(pairParameters: ["id": "3333333"])

                
                 let attributes = IslandAttributes(numberOfPizzas:123, name: "Me")
                let activities = Activity<IslandAttributes>.activities
                for activity in activities {
                    var state:IslandAttributes.ContentState = activity.content.state;
                
                 let contentState = IslandAttributes.ContentState(statusString: "",
                                                                        totalTomatees: 0,
                                                                        numTomatees: 0,
                                                                        focusedDuration: "0mins",
                                                                  bgUrl: self.bgUrl ?? "", title: state.title, text: self.text ?? "", value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), counterStatusEnum: 6, isCountDown: true)
                var activity: Activity<IslandAttributes>? = try Activity.request(attributes: attributes, contentState: contentState, pushType: nil)
                
                await LiveActivityManager.shareInstance().activity?.end(using: contentState,dismissalPolicy: .immediate)
                NetworkRequest.shared.console(pairParameters: ["id": "44444444444"])
                WidgetCenter.shared.reloadAllTimelines()
                }
                break;
            case .beginStart:
                break;
            case .beginStop:
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
            case .continue2:
                break;
            }
            
        }
        return .result()
    }
    
}


/**
 参考
 http://swiftcafe.io/post/dy-island
 */
struct IslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var objectId: String?
        var statusString: String
        var  totalTomatees: Int
        var numTomatees: Int
        var focusedDuration: String
        var bgUrl: String
        var title: String
        var text: String
        var value: Int
        var startTime: Date
        var deliveryTimer: ClosedRange<Date>?
        //    case focusing=0 //专注中 红色计时中
        //    case pausingFucusing=1 //专注暂停中
        //    case relaxing=2 //休息中 蓝色计时中
        //    case waitingToFocus=3 //等待专注中
        //    case waitingToStartRelaxing=4 //等待休息启动
        //    case pausingRelaixing=5 //暂停休息中
        //    case none=6 //没任何选择
        var counterStatusEnum: Int
        var isCountDown: Bool
        
        
    }
    var numberOfPizzas: Int?
    var currentTimeStamp: Int?
    var time: Int?
    var objectId: String?
    // Fixed non-changing properties about your activity go here!
    var name: String
    var counterStatusEnum: Int?
    
}

@available(iOS 17, *)
struct IslandLiveActivity: Widget {
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
                        Text(context.state.title).lineLimit(1)
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
                    Text(context.state.startTime, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)))
                        .font(.caption2)
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
                
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
                    if(context.state.isCountDown) {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .font(.caption2)
                    } else {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .font(.caption2)
                    }
                } else {
                    Text(context.state.text)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .font(.caption2)
                }
            } minimal: {
                //                Text("Min") //最最小状态
                
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
                    if(context.state.isCountDown) {
                        
                        VStack(alignment: .center) {
                            Image(systemName: "timer")
                            Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                                .font(.caption2)
                        }
                    } else {
                        VStack(alignment: .center) {
                            Image(systemName: "timer")
                            Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                                .font(.caption2)
                        }
                    }
                } else {
                    VStack(alignment: .center) {
                        Image(systemName: "timer")
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                            .font(.caption2)
                    }
                }
                //                VStack(alignment: .center) {
                ////                    Image(systemName: "timer")
                //                    Text(timerInterval: context.state.deliveryTimer!, countsDown: true)
                //                        .multilineTextAlignment(.center)
                //                        .monospacedDigit()
                //                        .font(.caption2)
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
    
    static let contentState = IslandAttributes.ContentState(statusString: "",
                                                            totalTomatees: 0,
                                                            numTomatees: 0,
                                                            focusedDuration: "0mins",
                                                            bgUrl: "", title: "", text: "", value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), counterStatusEnum: 6, isCountDown: true)
    
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
