//
//  New2ClockInWidget.swift
//  New2ClockInWidget
//
//  Created by 林智彬 on 2024/11/13.
//

import WidgetKit
import SwiftUI
import AppIntents

// TimerManager: 管理计时器的状态和数据
//struct TimerManager {
//    static var beginTimestamp: Int = 0;
//    static var endTimestamp: Int = 0;
//    static var timerDuration: Int = 1500 // Default 25 minutes 1500 / 60
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

// TimerIntent: 用于处理计时器操作的AppIntent，支持启动、暂停、重置等操作
struct TimerIntent: AppIntent {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()

    init() {
        
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
//        NotificationCenter.default.post(name: NSNotification.Name( Params.ACTION_HANDLE_NOTIFICATION_POSTMESSAGE) , object: self, userInfo: ["action": "handleUpdateFlomoMissionModelList"]);
            NetworkRequest.shared.console(pairParameters: ["id": self.missionID ?? ""])
            let objectId = self.missionID ?? "";
            let timestamp = TimerIntent.getCurrentTimeStampByMilliSeconds();
            if let responseData:[String: Any]? = await NetworkRequest.shared.startRequestWithPost(pairParameters: ["objectId":objectId, "timestamp": timestamp], url: Apis.updateFlomoClickInsMissionModel) {
                do {
                    if responseData != nil && (responseData!["success"] as! Bool){
                        let percent: Double = (responseData?["data"] ?? 0) as! Double;
                        var flomoMissionData:FlomoMissionData?;
                        do {
                            flomoMissionData = try JSONDecoder().decode(FlomoMissionData.self, from: primaryData)
                        } catch {
                            print("Could not write to file")
                        }
                        //                                flomoMissionData.
                        let dateString: String = TimerIntent.formatTimestampToDateString(timestamp: Int(timestamp));
                        var missionModel: MissionModel?;
                        var list:[FlomoMissionModelList] = flomoMissionData?.listFlomoMissionModelList ?? [];
                        for i in 0..<list.count {
                            //                                    print("Index \(i): \(list[i])")
                            var model: FlomoMissionModelList = list[i];
                            let dateString2: String = TimerIntent.formatTimestampToDateString(timestamp: Int(model.time));
                            
                            for j in 0..<model.listMissionModel.count {
                                var flomoMissionModel: FlomoMissionModel = model.listMissionModel[j];
                                if(flomoMissionModel.objectId == objectId && dateString2 == dateString) {
                                    flomoMissionModel.percent = percent;
                                    model.listMissionModel[j] = flomoMissionModel;
                                    break;
                                }
                                print("\(flomoMissionModel)");
                            }
                            list[i] = model;
                        }
                        flomoMissionData?.listFlomoMissionModelList  = list;
                        guard let data = try? JSONEncoder().encode(flomoMissionData) else {
                            return .result()
                        }
   
                        let missionData = try?
                        JSONDecoder().decode(FlomoMissionData.self, from: data)
                        primaryData = data //类似存储在 shareprefrerence
                        WidgetCenter.shared.reloadAllTimelines()
                        print("请求成功")
                    } else {
                        print("请求失败")
                    }
                    //                            // 将 responseData 转换为 JSON 数据
                    //                            let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    //
                    //                            // 使用 JSONDecoder 将数据解析为 BaseResponse 类型
                    //                            let decoder = JSONDecoder()
                    //                            decoder.keyDecodingStrategy = .convertFromSnakeCase // 自动将下划线命名转换为驼峰命名
                    //                            let baseResponse = try decoder.decode(BaseResponse.self, from: jsonData)
                    //
                    //                            // 打印解析结果
                    //                            if baseResponse.success {
                    //                                print("请求成功，数据为: \(baseResponse)")
                    ////                                return baseResponse;
                    //                            } else {
                    //                                print("请求失败，错误信息: \(baseResponse.message)")
                    //                                //                                return nil;
                    //                            }
                } catch {
                    print("JSON 解析失败: \(error)")
                    //                            return nil;
                }
            }
        return .result()
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


struct Provider: TimelineProvider {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), listMissionModel: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), listMissionModel: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var flomoMissionData:FlomoMissionData?;
        do {
            flomoMissionData = try JSONDecoder().decode(FlomoMissionData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        let list = flomoMissionData?.listFlomoMissionModelList ?? [];
        if list.count > 0 {
            for index in 0...list.count - 1 {
                let flomoMissionModelList:FlomoMissionModelList = list[index]
                let time = flomoMissionModelList.time;
                let entryDate = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                let calendar = Calendar.current
                let entry: SimpleEntry
                if calendar.isDateInToday(entryDate) {
                    let date = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
                    entry = SimpleEntry(date: Date(), listMissionModel: flomoMissionModelList.listMissionModel)
                    print("entryDate is in today")
                } else {
                    entry = SimpleEntry(date: entryDate, listMissionModel: flomoMissionModelList.listMissionModel)
                    print("entryDate is not in today")
                }
                entries.append(entry)
            }
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        //
        //
        
        //
        //        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate)
        //            entries.append(entry)
        //        }
        
        //        let timeline = Timeline(entries: entries, policy: .atEnd)
        //        completion(timeline)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    var listMissionModel: [FlomoMissionModel]
}


struct New2ClockInWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack{
            HStack {
                Color.yellow.frame(width: 4, height: 10).padding(.trailing, 0)
                Text("clockInToday".localizable())
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                Spacer()
            }
            if family == .systemSmall {
                ItemView(listMissionModel: entry.listMissionModel)
            } else {
                GridView(listMissionModel: entry.listMissionModel)
            }
            
        }.padding(EdgeInsets(top: 6, leading: 4, bottom: 0, trailing: 0))
    }
}


struct ItemView: View {
    
    var listMissionModel: [FlomoMissionModel]
    let radius: Double = 15
    var percent: Double = 0.3
    var isChecked: Bool = true
    @Environment(\.widgetFamily) var family
    
    init(listMissionModel: [FlomoMissionModel]) {
        self.listMissionModel = listMissionModel
    }
    
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall: return 4
        case .systemMedium: return 5
        case .systemLarge: return 13
        @unknown default: return 6
        }
    }
    
    var body: some View {
        VStack {
            ForEach(listMissionModel.prefix(getMaxItems()), id: \.self) { item in
                MissionItemView(item: item, radius: radius)
            }
            if listMissionModel.isEmpty && listMissionModel.count > getMaxItems() {
                HStack {
                    Text("......")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                }.padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 4))
            }
            Spacer()
        }
    }
}

struct MissionItemView: View {
    var item: FlomoMissionModel
    var radius: Double

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color(hex: UInt((item.color ?? 0xff8800))))
                    .frame(width: geometry.size.width * CGFloat(min(item.percent ?? 0, 1)))
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                if #available(iOSApplicationExtension 17.0, *) {
                    Button(intent: TimerIntent(missionID: item.objectId ?? "")) {
                        Rectangle()
                            .fill(Color(hex: UInt((item.color ?? 0xff8800))))
                            .frame(width: geometry.size.width)
                            .opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                    }.buttonStyle(PlainButtonStyle())
                } else {
                    // Fallback on earlier versions
                }
            }
            HStack {
                Text("\(item.title ?? "") \(item.percent)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                Spacer()
                Image((item.percent ?? 0) < 1 ? "ic_uncheck" : "ic_check")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
            }
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 4))
        }
        .frame(height: 25)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
    }
}

struct GridView: View {
    var listMissionModel: [FlomoMissionModel]
    let radius:Double = 15;
    var percent:Double = 0.3;
    var isChecked: Bool = true;
    @Environment(\.widgetFamily) var family
    
    init(listMissionModel: [FlomoMissionModel]) {
        self.listMissionModel = listMissionModel
    }
    
    var body: some View {
        HStack {
            VStack {
                ForEach(listMissionModel.prefix(getMaxItems()).indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                    ItemRow(item: listMissionModel[index])
                }
                Spacer()
            }
            VStack {
                ForEach(listMissionModel.prefix(getMaxItems()).indices.filter { $0 % 2 != 0 }, id: \.self) { index in
                    ItemRow(item: listMissionModel[index])
                }
                Spacer()
            }
        }
    }
    
    func ItemRow(item: FlomoMissionModel) -> some View {
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                        .frame(width: geometry.size.width * CGFloat((item.percent ?? 0) < 1 ? (item.percent ?? 0) : 1))
                        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                    if #available(iOSApplicationExtension 17.0, *) {
                        Button(intent: TimerIntent(missionID: item.objectId ?? "")) {
                            
                            Rectangle()
                                .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                .frame(width: geometry.size.width)
                                .opacity(0.2)
                                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                        } .buttonStyle(PlainButtonStyle())
                    } else {
                        // Fallback on earlier versions
                    }
//                        .background(Color.clear)
                }
                HStack {
                    Text("\(item.title ?? "") \(item.percent)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    Spacer()
                    Image((item.percent ?? 0) < 1 ? "ic_uncheck" : "ic_check")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 14, height: 14)
                }.padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing:4))
            }
            .frame(height: 25)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))

    }
    
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium:
            return 8
        case .systemLarge:
            return 18
        @unknown default:
            return 6
        }
    }
}

struct New2ClockInWidget: Widget {
    let kind: String = "New2ClockInWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                New2ClockInWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                New2ClockInWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//#Preview(as: .systemSmall) {
//    New2ClockInWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
