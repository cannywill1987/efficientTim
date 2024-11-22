//
//  NewClockinWeekendWidget.swift
//  NewClockinWeekendWidget
//
//  Created by 林智彬 on 2024/11/7.
//

import WidgetKit
import SwiftUI
import AppIntents

struct TimerIntent2: AppIntent {
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
    @Parameter(title: "Timestamp")
    var timestamp: Int?
    
    @Parameter(title: "Mission ID")
    var missionID: String?
    init(missionID: String, timestamp: Int?) {
        self.missionID = missionID
        self.timestamp = timestamp
    }
    
    /**得到当前毫秒时间戳**/
    static  func getCurrentTimeStampByMilliSeconds() -> CLongLong{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond;
    }
    
    func perform() async throws -> some IntentResult {
        Task {
            let objectId = self.missionID ?? "";
//            let timestamp = TimerIntent2.getCurrentTimeStampByMilliSeconds();
//            NetworkRequest.shared.console(pairParameters: ["objectId":objectId, "timestamp": self.timestamp])
            if let responseData:[String: Any]? = await NetworkRequest.shared.startRequestWithPost(pairParameters: ["objectId":objectId, "timestamp": self.timestamp], url: Apis.updateFlomoClickInsMissionModel) {
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
                        let dateString: String = TimerIntent2.formatTimestampToDateString(timestamp: Int(timestamp ?? 0));
//                        var missionModel: MissionModel?;
                        var list:[FlomoMissionModelList] = flomoMissionData?.listFlomoMissionModelList ?? [];
                        for i in 0..<list.count {
                            //                                    print("Index \(i): \(list[i])")
                            var model: FlomoMissionModelList = list[i];
                            let dateString2: String = TimerIntent2.formatTimestampToDateString(timestamp: Int(model.time));
                            
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
                            return
                        }
   
                        let missionData = try?
                        JSONDecoder().decode(FlomoMissionData.self, from: data)
                        primaryData = data //类似存储在 shareprefrerence
                        WidgetCenter.shared.reloadAllTimelines()
                        print("请求成功")
                    } else {
                        print("请求失败")
                    }
                } catch {
                    print("JSON 解析失败: \(error)")
                }
            }
        }
        return .result()
    }
    
}

struct Provider: TimelineProvider {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [] );
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: [] );
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var tasksMap: [String:TaskItem] = [:]
        let calendar = Calendar.current
        let currentDate = Date()
        var flomoMissionData: FlomoMissionData?
        
        // 尝试解码数据
        do {
            flomoMissionData = try JSONDecoder().decode(FlomoMissionData.self, from: primaryData)
        } catch {
            print("Could not decode FlomoMissionData from stored primaryData")
        }
        
        // 获取任务列表
        let list = flomoMissionData?.listFlomoMissionModelList ?? []

        
        // 遍历任务列表，拼接一周数据
        //每个 flomoMissionModelList 有是按天排列 一个个时间排列
        for flomoMissionModelList in list {
            let time = flomoMissionModelList.time //一天 一天下面有多个任务
            let entryDate = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
            
            let month: Int = Calendar.current.component(.month, from: entryDate)
            let day: Int = Calendar.current.component(.day, from: entryDate)
            if (month == 11 && day == 10) {
                print("")
            }
            if (month == 11 && day == 12) {
                print("")
            }
            // 将完成比例填充到一周的进度中
            let dayOfWeek = calendar.component(.weekday, from: entryDate) - 1 // 从0（周日）到6（周六）

                // 对每个任务进行处理，生成从周日到周六的完成比例
                for missionModel in flomoMissionModelList.listMissionModel {
//                    if (flomoMissionModelList.listMissionModel.count == 0) {
//
//                        continue
//                    }
                    // 获取每周的完成率数组
//                    var weeklyCompletionRates: [Double] = Array(repeating: 0.0, count: 7)
                    
                    
                    // 创建任务的 Task 实例
                    let title: String = missionModel.title ?? "Untitled Task"
                    let color: Color = Color(hex: missionModel.color ?? 0xff8800)  // 任务颜色
                    
                    var task: TaskItem? = tasksMap[missionModel.objectId ?? ""]
                    if task == nil {
                        // 获取周几（1表示周日，2表示周一...7表示周六）
                        let weekday = calendar.component(.weekday, from: entryDate)
                        
                        task = TaskItem(objectId: missionModel.objectId ?? "", icon: "", title: title, color: color, completionRate: Array(repeating: -1, count: 7), isToday: calendar.isDateInToday(entryDate), weekendOfDay: weekday, timestamp: Int(round(entryDate.timeIntervalSince1970*1000)))
                        
                        task?.completionRate[dayOfWeek] = (missionModel.percent ?? 0)
                        tasksMap[missionModel.objectId ?? ""] = task
                    } else {
                        let weekday = calendar.component(.weekday, from: entryDate)
                        task?.objectId = missionModel.objectId ?? ""
                        task?.color = color
                        //                        task?.completionRate = completionRateMap[title] ?? []
                        task?.completionRate[dayOfWeek] = (missionModel.percent ?? 0)
                        task?.isToday = calendar.isDateInToday(entryDate)
                        task?.weekendOfDay = weekday
                        tasksMap[missionModel.objectId ?? ""] = task
                        
                    }
//                    if (missionModel.title == "早起") {
//                        print("");
//                    }
//                    if (missionModel.title == "吃早餐") {
//                        print("");
//                    }
//                }
            }
//            var conditionSatisfied = false //是否满足7天需求
            
            
            // 创建新的 SimpleEntry
            var tasks: [TaskItem] = []
            for (key, task) in tasksMap {
                tasks.append(task)
            }
            tasks.sort { $0.title < $1.title }
            if dayOfWeek == 6 {
                //更新时间要提前一天
                let time = flomoMissionModelList.time - 7 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let time1 = flomoMissionModelList.time - 6 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let time2 = flomoMissionModelList.time - 5 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let time3 = flomoMissionModelList.time - 4 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let time4 = flomoMissionModelList.time - 3 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let time5 = flomoMissionModelList.time - 2 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let time6 = flomoMissionModelList.time - 1 * 24 * 60 * 60 * 1000 //一天 一天下面有多个任务
                let entryDate = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                
                if calendar.isDate(entryDate, equalTo: entryDate, toGranularity: .weekOfYear) {
                    let currentDate = Date().addingTimeInterval(100)
                    let entry = SimpleEntry(date: currentDate, tasks: tasks)
                    entries.append(entry)
                }
                
                let entry = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time) / 1000), tasks: tasks)
                entries.append(entry)
                
                let entry1 = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time1) / 1000), tasks: tasks)
                entries.append(entry1)
                
                let entry2 = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time2) / 1000), tasks: tasks)
                entries.append(entry2)
                
                let entry3 = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time3) / 1000), tasks: tasks)
                entries.append(entry3)
                
                let entry4 = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time4) / 1000), tasks: tasks)
                entries.append(entry4)
                
                let entry5 = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time5) / 1000), tasks: tasks)
                entries.append(entry5)
                
                let entry6 = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(time6) / 1000), tasks: tasks)
                entries.append(entry6)
                
                tasksMap = [:]
            }
        }
        
        // 定义 Timeline，并完成
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    //    var listMissionModel: [FlomoMissionModel]
    var tasks: [TaskItem]
}

struct TaskItem: Identifiable {
    var objectId: String
    var id = UUID()
    var icon: String
    var title: String
//    var status: [Bool]  // 一周的任务状态
    var color: Color    // 每个任务的方框颜色
    var completionRate: [Double]
    var isToday: Bool
    var weekendOfDay: Int
    var timestamp: Int;
}

struct NewClockinWeekendWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    let daysOfWeek = ["sun".localizable(), "mon".localizable(), "tue".localizable(), "wed".localizable(), "thur".localizable(), "fri".localizable(), "sat".localizable()]
    // 获取周几（1表示周日，2表示周一...7表示周六）
    func isToday(index: Int) -> Bool{
        var todayIndex: Int = Calendar.current.component(.weekday, from: entry.date)
        if (todayIndex == 7) {
            todayIndex = 0
        } else {
            todayIndex -= todayIndex
        }
        if (todayIndex == index) {
            return true
        } else {
            return false
        }
    }
    
    func shouldShowBigButtons() -> Bool {
        if (family == .systemSmall) {
            return false;
        } else {
            return true;
        }
    }
    
    var body: some View {
        VStack {
            // 顶部显示星期几
            HStack {
//                Text("\(entry.date)").foregroundColor(.white)
                Image(systemName: "crown.fill")
                    .foregroundColor(.orange)
                
                Spacer()
                ForEach(Array(daysOfWeek.enumerated()), id: \.element) { index, day in
                    Text("\(day)")
                        .foregroundColor(isToday(index: index) ? .blue : .white)  // 高亮周四
                        .frame(width: 20)
                        .cornerRadius(4)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
//            Divider()
            
            // 任务列表
            ForEach(entry.tasks.prefix(6)) { task in
                HStack {
                    Text("\(task.title)")
                        .foregroundColor(.white)
                    Spacer()
                    ForEach(0..<7) { dayIndex in
                        Button(intent: TimerIntent2(missionID: task.objectId ?? "", timestamp: task.timestamp + dayIndex * 24 * 60 * 60 *  1000)) {
                            Rectangle()
                                .fill(task.color.opacity((dayIndex < task.completionRate.count && task.completionRate[dayIndex] != -1) ? (task.completionRate[dayIndex] + 0.1) : 0))  // 根据每天的完成比例设置透明度
                                .frame(width: 20, height: 20)
                                .cornerRadius(4)
                        }                .buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.vertical, 4)
            }
            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


struct NewClockinWeekendWidget: Widget {
    let kind: String = "NewClockinWeekendWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                NewClockinWeekendWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewClockinWeekendWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("clockInToday".localizable())
        .description("")
        .supportedFamilies([ .systemLarge, .systemExtraLarge])
    }
}
