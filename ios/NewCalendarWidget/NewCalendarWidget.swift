//
//  NewCalendarWidget.swift
//  NewCalendarWidget
//
//  Created by 林智彬 on 2024/11/17.
//

import WidgetKit
import SwiftUI
import AppIntents

struct TimerManager {
    static let mediumCalendar = Calendar.current
    static var mediumCurrentDate = Date()
    static var mediumSelectedDate: Date? = Date()
    static var mediumCurrentPage:Int = 0
    static var mediumTotalPages: Int = 0
    static let largeCalendar = Calendar.current
    static var largeCurrentDate = Date()
}

// MARK: - AppIntents Enum
enum CalendarAction: String, AppEnum {
    case mediumPreviousMonth = "mediumPreviousMonth"
    case mediumNextMonth = "mediumNextMonth"
    case mediumResetToToday = "mediumResetToToday"
    case mediumSelectDate = "mediumSelectDate"
    case mediumNextPage = "mediumNextPage"
    case mediumPreviousPage = "mediumPreviousPage"
    case largePreviousMonth = "largePreviousMonth"
    case largeNextMonth = "largeNextMonth"
    case largeResetToToday = "largeResetToToday"
    case clickFinishMission = "clickFinishMission"
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Calendar Action")
    
    
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .mediumPreviousMonth: "mediumPreviousMonth", // 启动操作的显示名
            .mediumNextMonth: "mediumNextMonth", // 暂停操作的显示名
            .mediumResetToToday: "mediumResetToToday", // 重置操作的显示名
            .mediumSelectDate: "mediumSelectDate",
            .mediumPreviousPage: "mediumPreviousPage",
            .mediumNextPage: "mediumPreviousPage",
            .largePreviousMonth: "largePreviousMonth",
            .largeNextMonth: "largeNextMonth",
            .largeResetToToday: "largeResetToToday",
            .clickFinishMission: "clickFinishMission"
        ]
    }
}



// MARK: - AppIntent to Handle Actions
struct CalendarActionIntent: AppIntent {
    @AppStorage("MissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryDataMissionListView : Data = Data()
    @AppStorage("QuadrantWidget", store: UserDefaults(suiteName: Params.groupName)) var primaryDataQuadrant : Data = Data()
    @AppStorage("CalendarMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    static var title: LocalizedStringResource = "执行日历操作"
    let calendar = Calendar.current
    
    @Parameter(title: "操作类型")
    var action: CalendarAction
    @Parameter(title: "日历")
    var dayDate: Date
    @Parameter(title: "objectId")
    var objectId: String
    // 初始化函数
    init() { }
    init(action: CalendarAction) {
        self.action = action
    }
    
    init(action: CalendarAction, dayDate: Date) {
        self.action = action
        self.dayDate = dayDate
    }
    
    init(action: CalendarAction, dayDate: Date, objectId: String) {
        self.action = action
        self.dayDate = dayDate
        self.objectId = objectId
    }
    
    func perform() async throws -> some IntentResult {
        // 通过 AppIntents 处理的核心逻辑
        print("用户选择了操作：\(action.rawValue)")
        
        switch action {
            // In the 'start' case:
        case .mediumPreviousMonth:
            TimerManager.mediumCurrentDate = calendar.date(byAdding: .month, value: -1, to: TimerManager.mediumCurrentDate) ?? TimerManager.mediumCurrentDate
            break;
        case .mediumNextMonth:
            TimerManager.mediumCurrentDate = calendar.date(byAdding: .month, value: 1, to: TimerManager.mediumCurrentDate) ?? TimerManager.mediumCurrentDate
            break;
        case .mediumResetToToday:
            TimerManager.mediumCurrentDate = Date()
            break;
        case .mediumSelectDate:
            TimerManager.mediumSelectedDate = dayDate
            break;
        case .mediumPreviousPage:
            if TimerManager.mediumCurrentPage > 0 {
                TimerManager.mediumCurrentPage = TimerManager.mediumCurrentPage - 1
            }
            break;
        case .mediumNextPage:
            if TimerManager.mediumCurrentPage < TimerManager.mediumTotalPages - 1 {
                withAnimation {
                    TimerManager.mediumCurrentPage = TimerManager.mediumCurrentPage + 1
                }
            }
            break;
        case .largePreviousMonth:
            TimerManager.largeCurrentDate = calendar.date(byAdding: .month, value: -1, to: TimerManager.largeCurrentDate) ?? TimerManager.largeCurrentDate
            break;
        case .largeNextMonth:
            TimerManager.largeCurrentDate = calendar.date(byAdding: .month, value: 1, to: TimerManager.largeCurrentDate) ?? TimerManager.largeCurrentDate
            break;
        case .largeResetToToday:
            TimerManager.largeCurrentDate = Date()
            break;
        case .clickFinishMission:
            var myCalendarMissionStoreData:MyCalendarMissionData?;
            do {
                myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
            } catch {
            }
            
            
            var missionID = self.objectId;
            if let responseData:[String: Any]? = await NetworkRequest.shared.startRequestWithPost(pairParameters: ["objectId":self.objectId ?? "", "isFinished": true], url: Apis.updateMissionModelOfFinished) {
                if responseData != nil && (responseData!["success"] as! Bool){
                    
                    
                    guard var storeDataQuadrant = try?
                            JSONDecoder().decode(StoreData.self, from: primaryDataQuadrant) else {
                        return .result()
                    }
                    
                    var missionModelQuadrant: MissionModel?;
                    if let index = storeDataQuadrant.missionListMissionModel1?.firstIndex(where: { $0.objectId == self.objectId }) {
                        storeDataQuadrant.missionListMissionModel1![index].isFinished = !(storeDataQuadrant.missionListMissionModel1?[index].isFinished ?? false)
                        missionModelQuadrant = storeDataQuadrant.missionListMissionModel1?[index]
                    }
                    if let index = storeDataQuadrant.missionListMissionModel2?.firstIndex(where: { $0.objectId == self.objectId }) {
                        storeDataQuadrant.missionListMissionModel2![index].isFinished = !(storeDataQuadrant.missionListMissionModel2?[index].isFinished ?? false)
                        missionModelQuadrant = storeDataQuadrant.missionListMissionModel2?[index]
                    }
                    if let index = storeDataQuadrant.missionListMissionModel3?.firstIndex(where: { $0.objectId == self.objectId }) {
                        storeDataQuadrant.missionListMissionModel3![index].isFinished = !(storeDataQuadrant.missionListMissionModel3?[index].isFinished ?? false)
                        missionModelQuadrant = storeDataQuadrant.missionListMissionModel3?[index]
                    }
                    if let index = storeDataQuadrant.missionListMissionModel4?.firstIndex(where: { $0.objectId == self.objectId }) {
                        storeDataQuadrant.missionListMissionModel4![index].isFinished = !(storeDataQuadrant.missionListMissionModel4?[index].isFinished ?? false)
                        missionModelQuadrant = storeDataQuadrant.missionListMissionModel4?[index]
                    }
                    
                    missionModelQuadrant!.isFinished = true;
                    let storeDataToEncode = storeDataQuadrant
                    guard let data = try? JSONEncoder().encode(storeDataToEncode) else {
                        return .result()
                    }
                    
                    guard var missionDataMissionListView = try?
                            JSONDecoder().decode(MissionData.self, from: primaryDataMissionListView) else {
                        return .result()
                    }
                    var missionModel: MissionModel?;
                    if let index = missionDataMissionListView.listMissionModel.firstIndex(where: { $0.objectId == missionID }) {
                        missionDataMissionListView.listMissionModel[index].isFinished = !(missionDataMissionListView.listMissionModel[index].isFinished ?? false)
                        missionModel = missionDataMissionListView.listMissionModel[index]
                    }
                    var res = !(missionModel?.isFinished ?? false);
                    let missionDataToEncode = missionDataMissionListView
                    guard let data = try? JSONEncoder().encode(missionDataToEncode) else {
                        return .result()
                    }
                    primaryDataMissionListView = data //类似存储在 shareprefrerence
                    
                    
                    var myCalendarMissionStoreData:MyCalendarMissionData?;
                    do {
                        myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
                    } catch {
                        print("Could not write to file")
                    }
                    var modelTmp:MissionModel? = nil
                    for index in 0..<(myCalendarMissionStoreData?.listMissionModelList.count ?? 0){
                        let missionModelList:MissionModelList? = myCalendarMissionStoreData?.listMissionModelList[index] ?? nil
                        if missionModelList != nil {
                            for index2 in 0..<(missionModelList?.listMissionModel.count ?? 0){
                                let model:MissionModel? = missionModelList?.listMissionModel[index2] ?? nil
                                if model != nil && model?.objectId == self.objectId {
                                    modelTmp = model
                                    modelTmp?.isFinished = true
                                }
                            }
                        }
                    }
                    guard let data = try? JSONEncoder().encode(myCalendarMissionStoreData) else {
                        return .result()
                    }
                    primaryData = data //类似存储在 shareprefrerence
                    
                    break;
                }
            }
        }
        
        
        return .result()
    }
}

// MARK: - Widget Entry
struct CalendarWidgetEntry: TimelineEntry {
    let date: Date
    let missionModelList: [MissionModelList]
    let currentPage: Int
}

// MARK: - Widget View
struct CalendarWidgetView: View {
    var entry: CalendarWidgetEntry
    
    @Environment(\.widgetFamily) var family
    
    
    var body: some View {
        //        let sampleMission = MissionModelList(time: Int(Date().addingTimeInterval(7 * 24 * 60 * 60).timeIntervalSince1970 * 1000), lunar: "初七", listMissionModel: [
        //            MissionModel(objectId: "1", title: "测试任务1", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "2", title: "测试任务2", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "3", title: "测试任务3", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "4", title: "测试任务4", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "5", title: "测试任务5", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "6", title: "测试任务6", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "7", title: "测试任务7", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "8", title: "测试任务8", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil)
        //        ])
        if family == .systemMedium {
            MediumCalendarComponent2(missionModelList: entry.missionModelList)
                .padding(.top, 50)
                .padding(.bottom, 50)
        } else if family == .systemLarge {
            LargeCalendarComponent(missionModelList: entry.missionModelList)
                .padding(.top, 50)
                .padding(.bottom, 50)
        }
    }
}

struct MediumCalendarComponent2: View {
    let calendar = Calendar.current
    //    @State var currentDate = Date()
    //    @State var selectedDate: Date? = nil
    //    @State var currentPage:Int = 0
    var daysInMonth: [Int] {
        let range = calendar.range(of: .day, in: .month, for: TimerManager.mediumCurrentDate)!
        return range.map { $0 }
    }
    var missionModelList: [MissionModelList] = []
    
    init(missionModelList: [MissionModelList]) {
        self.missionModelList = missionModelList
    }
    
    func getMissionModels(dayTimestamp: Int) -> [MissionModel]? {
        for missionList in missionModelList {
            let time = missionList.time
            if areDatesEqual(date1Timestamp: time, date2Timestamp: dayTimestamp) {
                return missionList.listMissionModel
            }
        }
        return nil
    }
    
    func areDatesEqual(date1Timestamp: Int, date2Timestamp: Int) -> Bool {
        // 将毫秒时间戳转换为秒
        let date1 = Date(timeIntervalSince1970: TimeInterval(date1Timestamp) / 1000)
        let date2 = Date(timeIntervalSince1970: TimeInterval(date2Timestamp) / 1000)
        
        // 使用 Calendar 提取年份、月份和日期
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        // 检查年份、月份和日期是否完全相等
        return components1.year == components2.year &&
        components1.month == components2.month &&
        components1.day == components2.day
    }
    
    func isToday(timestampMilli: Int) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(timestampMilli) / 1000)
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    func isSelectedDate(timestampMilli: Int) -> Bool {
        if TimerManager.mediumSelectedDate == nil {
            return false;
        }
        let date = Date(timeIntervalSince1970: TimeInterval(timestampMilli) / 1000)
        let calendar = Calendar.current
        //        return calendar.isDateInToday(date)
        let components1 = calendar.dateComponents([.year, .month, .day], from: TimerManager.mediumSelectedDate!)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = components1.year ?? 0
        let month = components1.month ?? 0
        let day = components1.day ?? 0
        //        if year == 2024 && month == 11 && day == 24 {
        //            print("")
        //        }
        if components1.year == components2.year &&
            components1.month == components2.month &&
            components1.day == components2.day {
            return true
        } else {
            return false
        }
        
    }
    
    func getTotalPages(maxMissionsPerPage: Int) -> Int {
        let dayTimestamp = Int((TimerManager.mediumSelectedDate ?? Date()).timeIntervalSince1970 * 1000)
        let missions = getMissionModels(dayTimestamp: dayTimestamp) ?? []
        //        let maxMissionsPerPage = 5
        let totalPages = (missions.count + maxMissionsPerPage - 1) / maxMissionsPerPage
        TimerManager.mediumTotalPages = totalPages
        return totalPages
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 1) {
                // 顶部年月标题和左右切换按钮
                HStack {
                    if #available(iOSApplicationExtension 17.0, *) {
                        Button(intent:  CalendarActionIntent(action: .mediumPreviousMonth, dayDate: Date(),objectId: "")) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                            
                        }.buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                    } else {
                        // Fallback on earlier versions
                    }
                    Text(TimerManager.mediumCurrentDate, formatter: monthFormatter)
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                    if #available(iOSApplicationExtension 17.0, *) {
                        Button(intent:  CalendarActionIntent(action: .mediumNextMonth, dayDate: Date(),objectId: "")) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                        }.buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                    } else {
                        // Fallback on earlier versions
                    }
                    Spacer()
                    if #available(iOSApplicationExtension 17.0, *) {
                        Button(intent:  CalendarActionIntent(action: .mediumResetToToday, dayDate: Date(),objectId: "")) {
                            Image(systemName: "scope")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                        }.buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .padding(.leading, 17)
                .padding(.trailing, 12)
                
                // 顶部星期标题行
                HStack(spacing: 1) {
                    ForEach(["sun".localizable(), "mon".localizable(), "tue".localizable(), "wed".localizable(), "thur".localizable(), "fri".localizable(), "sat".localizable()], id: \ .self) { dayOfWeek in
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .opacity(0) // 如果是今天，则显示蓝色圈圈
                                .frame(width: 20, height: 20) // 圈圈大小可以根据需求调整
                            Text(dayOfWeek)
                                .foregroundColor(.white)
                                .font(.system(size: 10, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        //                        .frame(maxWidth: .infinity )
                        .frame(height: 30)
                    }
                }.padding(.top, 0)
                    .padding(.trailing, 12)
                    .padding(.leading, 12)
                
                let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: TimerManager.mediumCurrentDate))!
                let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
                let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: TimerManager.mediumCurrentDate)!
                let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonthDate)!
                let previousMonthDays = Array(previousMonthRange)
                let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: TimerManager.mediumCurrentDate)!
                let nextMonthRange = calendar.range(of: .day, in: .month, for: nextMonthDate)!
                let nextMonthDays = Array(nextMonthRange)
                let totalSlots = daysInMonth.count + firstWeekday
                let rows = totalSlots / 7 + (totalSlots % 7 == 0 ? 0 : 1)
                let lastWeekday = (firstWeekday + daysInMonth.count - 1) % 7
                
                ForEach(0..<rows, id: \ .self) { rowIndex in
                    HStack(spacing: 1) {
                        ForEach(0..<7, id: \ .self) { columnIndex in
                            let dayIndex = rowIndex * 7 + columnIndex - firstWeekday
                            if rowIndex == 0 && columnIndex < firstWeekday {
                                // 填充上个月的日期
                                let day = previousMonthDays[previousMonthDays.count - firstWeekday + columnIndex]
                                let dayDate = calendar.date(bySetting: .day, value: day, of: previousMonthDate) ?? Date()
                                let dayTimestamp:Int = Int(calendar.startOfDay(for: dayDate).timeIntervalSince1970 * 1000)
                                let list = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                                DayView2(timestampMilli: dayTimestamp, day: "\(day)", missions: list, onTap: {
                                    TimerManager.mediumSelectedDate = dayDate
                                }, isSelected: isSelectedDate(timestampMilli: dayTimestamp), dayInt: day, monthDate: previousMonthDate)
                                .opacity(0.5) // 显示为淡色表示不是
                            } else if dayIndex >= 0 && dayIndex < daysInMonth.count {
                                // 当前月的日期
                                let day = daysInMonth[dayIndex]
                                let monthDate = calendar.date(from: calendar.dateComponents([.year, .month], from: TimerManager.mediumCurrentDate)) ?? Date()
                                let dayDate2 = calendar.date(bySetting: .day, value: day, of: monthDate) ?? Date()
                                let dayTimestamp = Int(dayDate2.timeIntervalSince1970 * 1000)
                                let list = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                                let calendar = Calendar.current
                                let startOfMonth2 = calendar.date(from: calendar.dateComponents([.year, .month], from: TimerManager.mediumCurrentDate))
                                DayView2(timestampMilli: dayTimestamp, day: "\(day)", missions: list, onTap: {
                                    TimerManager.mediumSelectedDate = monthDate
                                }, isSelected: isSelectedDate(timestampMilli: dayTimestamp), dayInt: day, monthDate: monthDate)
                            } else if rowIndex == rows - 1 && columnIndex > lastWeekday {
                                // 填充下个月的日期
                                let day = nextMonthDays[columnIndex - lastWeekday - 1]
                                let dayDate = calendar.date(bySetting: .day, value: day, of: nextMonthDate) ?? Date()
                                let dayTimestamp = Int(dayDate.timeIntervalSince1970 * 1000)
                                let list = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                                
                                DayView2(timestampMilli: dayTimestamp, day: "\(day)", missions: list, onTap: {
                                    TimerManager.mediumSelectedDate = dayDate
                                }, isSelected: isSelectedDate(timestampMilli: dayTimestamp), dayInt: day, monthDate: nextMonthDate)
                                .opacity(0.5) // 显示为淡色表示不是
                            } else {
                                DayView2(timestampMilli: 0, day: "", missions: [], onTap: {}, isSelected: false, dayInt: 1, monthDate: Date()) // 用空的DayView保持对称
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 5)
            
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 250)
            //            .background(Color.red) // 修改日历背景为红色
            
            // 右侧任务列表
            VStack(alignment: .leading, spacing: 1) {
                if let selectedDate = TimerManager.mediumSelectedDate {
                    let dayTimestamp = Int(selectedDate.timeIntervalSince1970 * 1000)
                    let missions = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                    let maxMissionsPerPage = 7
                    //                    let totalPages = (missions.count + maxMissionsPerPage - 1) / maxMissionsPerPage
                    let totalPages = getTotalPages(maxMissionsPerPage: maxMissionsPerPage)
                    
                    if !missions.isEmpty {
                        
                        HStack {
                            Spacer()
                            if #available(iOSApplicationExtension 17.0, *) {
                                Button(intent: CalendarActionIntent(action: .mediumPreviousPage, dayDate: Date(),objectId: "")) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(TimerManager.mediumCurrentPage > 0 ? .white : .gray)
                                        .font(.system(size: 12, weight: .bold))
                                }.frame(width: 12, height: 12).buttonStyle(PlainButtonStyle())
                                    .background(Color.clear)
                            } else {
                                // Fallback on earlier versions
                            }
                            
                            Text("\(TimerManager.mediumCurrentPage + 1) / \(TimerManager.mediumTotalPages)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                            if #available(iOSApplicationExtension 17.0, *) {
                                Button(intent: CalendarActionIntent(action: .mediumNextPage, dayDate: Date(),objectId: "")) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(TimerManager.mediumCurrentPage < TimerManager.mediumTotalPages - 1 ? .white : .gray)
                                        .font(.system(size: 12, weight: .bold)).buttonStyle(PlainButtonStyle())
                                        .background(Color.clear)
                                }.frame(width: 12, height: 12)
                                    .buttonStyle(PlainButtonStyle())
                                        .background(Color.clear)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        .frame(height: 14)
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                        VStack(alignment: .trailing, spacing: 1) {
                            if TimerManager.mediumCurrentPage * maxMissionsPerPage < missions.count {
                                ForEach(missions[(TimerManager.mediumCurrentPage * maxMissionsPerPage)..<min((TimerManager.mediumCurrentPage + 1) * maxMissionsPerPage, missions.count)], id: \.self) { mission in
                                    let model: MissionModel? = mission as MissionModel // 必须加上 否则会有subtype解析错误
                                    let objectId: String = model?.objectId ?? ""
                                    
                                    if #available(iOSApplicationExtension 17.0, *) {
                                        Button(intent: CalendarActionIntent(action: .clickFinishMission, dayDate: Date(),objectId: objectId ?? "")) {
                                            
                                            HStack {
                                                Image((mission.isFinished ?? false) ? "ic_check" : "ic_uncheck") // Load the appropriate image
                                                    .resizable() // Make the image resizable
                                                    .frame(width: 12, height: 12) // Set the size of the image
                                                
                                                Text(mission.title ?? "任务")
                                                    .lineLimit(1)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 12))
                                                Spacer()
                                                //                                    if isToday(timestampMilli: dayTimestamp) {
                                                //                                        Text("今天")
                                                //                                            .foregroundColor(.blue)
                                                //                                            .font(.system(size: 16, weight: .bold))
                                                //                                    }
                                            }
                                            .padding(.vertical, 2)
                                            
                                        }
                                    } else {
                                        // Fallback on earlier versions
                                        HStack {
                                            Image((mission.isFinished ?? false) ? "ic_check" : "ic_uncheck") // Load the appropriate image
                                                .resizable() // Make the image resizable
                                                .frame(width: 12, height: 12) // Set the size of the image
                                            
                                            Text(mission.title ?? "任务")
                                                .lineLimit(1)
                                                .foregroundColor(.white)
                                                .font(.system(size: 12))
                                            Spacer()
                                            //                                    if isToday(timestampMilli: dayTimestamp) {
                                            //                                        Text("今天")
                                            //                                            .foregroundColor(.blue)
                                            //                                            .font(.system(size: 16, weight: .bold))
                                            //                                    }
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                                
                            }
                            Spacer()
                        }.frame(height: 135)
                    } else {
                    }
                }
                //                Spacer()
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            //            .frame(height: .infinity)
            
            .background(Color.black)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
}

struct DayView2: View {
    let calendar = Calendar.current
    let timestampMilli: Int
    let day: String
    let missions: [MissionModel]
    let onTap: () -> Void
    let isSelected: Bool
    let height:Double = 20
    let dayInt:Int
    let monthDate: Date
    // 判断给定的时间戳是否是今天
    func isToday(timestampMilli: Int) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(timestampMilli) / 1000)
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            if #available(iOSApplicationExtension 17.0, *) {
                Button(intent: CalendarActionIntent(action: .mediumSelectDate, dayDate: calendar.date(bySetting: .day, value: dayInt, of: monthDate) ?? Date(),objectId: "")) {
                    ZStack {
                        Circle()
                            .fill(isToday(timestampMilli: timestampMilli) ? Color.yellow : Color.clear) // 修改日期背景为黄色
                            .strokeBorder(isSelected ? Color.yellow : Color.clear, lineWidth: 1) // 修改日期背景为黄色
                            .frame(width: height, height: height) // 圈圈大小可以根据需求调整
                        Text(day)
                            .foregroundColor(isSelected == false && missions.count > 0 ? .blue : .white)
                        
                            .font(.system(size: 10, weight: .bold))
                        //                        .frame(maxWidth: .infinity, alignment: .center)
                            .frame(width: height, height: height, alignment: .center)
                        
                    }
                    //                .frame(maxWidth: .infinity )
                    .frame(width: height, height: height)
                    .padding(.bottom, 2)
                    .padding(.leading, 2)
                } .buttonStyle(PlainButtonStyle())
                    .background(Color.clear)
            } else {
                // Fallback on earlier versions
            }
            //            .onTapGesture {
            //                onTap()
            //            }
        } .frame(width: height, height: height)
    }
}

// MARK: - Widget Provider
struct CalendarWidgetProvider: TimelineProvider {
    @AppStorage("CalendarMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    
    
    func placeholder(in context: Context) -> CalendarWidgetEntry {
        CalendarWidgetEntry(date: Date(), missionModelList: [MissionModelList(time: Int(Date().addingTimeInterval(7 * 24 * 60 * 60).timeIntervalSince1970 * 1000), lunar: "初七", listMissionModel: [
            MissionModel(objectId: "1", title: "测试任务1", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "2", title: "测试任务2", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "3", title: "测试任务3", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "4", title: "测试任务4", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "5", title: "测试任务5", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "6", title: "测试任务6", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "7", title: "测试任务7", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "8", title: "测试任务8", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil)
        ])], currentPage: 0)
        
        //        CalendarWidgetEntry(date: Date(), missionModelList: [MissionModelList(time: Int(Date().addingTimeInterval(7 * 24 * 60 * 60).timeIntervalSince1970 * 1000), lunar: "初七", listMissionModel: [
        //            MissionModel(objectId: "1", title: "测试任务1", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "2", title: "测试任务2", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "3", title: "测试任务3", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "4", title: "测试任务4", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "5", title: "测试任务5", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "6", title: "测试任务6", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "7", title: "测试任务7", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
        //            MissionModel(objectId: "8", title: "测试任务8", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil)
        //        ])], currentPage: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CalendarWidgetEntry) -> Void) {
        let entry = CalendarWidgetEntry(date: Date(), missionModelList: [MissionModelList(time: Int(Date().addingTimeInterval(7 * 24 * 60 * 60).timeIntervalSince1970 * 1000), lunar: "初七", listMissionModel: [
            MissionModel(objectId: "1", title: "测试任务1", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "2", title: "测试任务2", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "3", title: "测试任务3", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "4", title: "测试任务4", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "5", title: "测试任务5", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "6", title: "测试任务6", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "7", title: "测试任务7", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "8", title: "测试任务8", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil)
        ])], currentPage: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarWidgetEntry>) -> Void) {
        // 当前时间
        let currentDate = Date()
        var myCalendarMissionStoreData:MyCalendarMissionData?
        do {
            myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        
        // 第二天0点的时间
        let calendar = Calendar.current
        guard let nextUpdateDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: currentDate)) else {
            // 如果时间计算失败，返回默认的时间线
            let timeline = Timeline(entries: [CalendarWidgetEntry(date: currentDate, missionModelList: myCalendarMissionStoreData?.listMissionModelList ?? [], currentPage: 0)], policy: .atEnd)
            completion(timeline)
            return
        }
        
        // 构建时间线条目
        let entry = CalendarWidgetEntry(date: currentDate, missionModelList: myCalendarMissionStoreData?.listMissionModelList ?? [], currentPage: 0)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        
        // 返回时间线
        completion(timeline)
        //        let entries = [CalendarWidgetEntry(date: Date(), missionModelList: [], currentPage: 0)]
        //        let timeline = Timeline(entries: entries, policy: .atEnd)
        //        completion(timeline)
    }
}

struct LargeCalendarComponent: View {
    let calendar = Calendar.current
    //    @State var currentDate = Date()
    var daysInMonth: [Int] {
        let range = calendar.range(of: .day, in: .month, for: TimerManager.largeCurrentDate)!
        return range.map { $0 }
    }
    var missionModelList: [MissionModelList] = []
    
    init(missionModelList: [MissionModelList]) {
        self.missionModelList = missionModelList
    }
    
    func getMissionModels(dayTimestamp: Int) -> [MissionModel]? {
        for missionList in missionModelList {
            let time = missionList.time
            if areDatesEqual(date1Timestamp: time, date2Timestamp: dayTimestamp) {
                return missionList.listMissionModel
            }
        }
        return nil
    }
    
    func areDatesEqual(date1Timestamp: Int, date2Timestamp: Int) -> Bool {
        // 将毫秒时间戳转换为秒
        let date1 = Date(timeIntervalSince1970: TimeInterval(date1Timestamp) / 1000)
        let date2 = Date(timeIntervalSince1970: TimeInterval(date2Timestamp) / 1000)
        
        // 使用 Calendar 提取年份、月份和日期
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        // 检查年份、月份和日期是否完全相等
        return components1.year == components2.year &&
        components1.month == components2.month &&
        components1.day == components2.day
    }
    
    var body: some View {
        VStack(spacing: 1) {
            // 顶部年月标题和左右切换按钮
            HStack {
                if #available(iOSApplicationExtension 17.0, *) {
                    Button(intent: CalendarActionIntent(action: .largePreviousMonth, dayDate: Date(), objectId: "")) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                    }.buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
                } else {
                    // Fallback on earlier versions
                }
                Text(TimerManager.largeCurrentDate, formatter: monthFormatter)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                if #available(iOSApplicationExtension 17.0, *) {
                    Button(intent: CalendarActionIntent(action: .largeNextMonth, dayDate: Date(), objectId: "")) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                    }.buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
                if #available(iOSApplicationExtension 17.0, *) {
                    Button(intent: CalendarActionIntent(action: .largeResetToToday, dayDate: Date(), objectId: "")) {
                        Image(systemName: "scope")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }.buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
                } else {
                    // Fallback on earlier versions
                }
            }
            .padding(.top, 4)
            .padding(.trailing, 14)
            .padding(.leading, 14)
            .frame(height: 60)
            VStack() {
                // 顶部星期标题行
                HStack(spacing: 1) {
                    ForEach(["sun".localizable(), "mon".localizable(), "tue".localizable(), "wed".localizable(), "thur".localizable(), "fri".localizable(), "sat".localizable()], id: \ .self) { dayOfWeek in
                        Text(dayOfWeek)
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .bold))
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                
                let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: TimerManager.largeCurrentDate))!
                let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
                let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: TimerManager.largeCurrentDate)!
                let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonthDate)!
                let previousMonthDays = Array(previousMonthRange)
                let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: TimerManager.largeCurrentDate)!
                let nextMonthRange = calendar.range(of: .day, in: .month, for: nextMonthDate)!
                let nextMonthDays = Array(nextMonthRange)
                let totalSlots = daysInMonth.count + firstWeekday
                let rows:Int = Int(totalSlots / 7 + (totalSlots % 7 == 0 ? 0 : 1))
                let lastWeekday = (firstWeekday + daysInMonth.count - 1) % 7
                
                ForEach(0..<rows, id: \ .self) { rowIndex in
                    HStack(spacing: 1) {
                        ForEach(0..<7, id: \ .self) { columnIndex in
                            let dayIndex = rowIndex * 7 + columnIndex - firstWeekday
                            if rowIndex == 0 && columnIndex < firstWeekday {
                                //                            // 填充上个月的日期
                                let day = previousMonthDays[previousMonthDays.count - firstWeekday + columnIndex]
                                let dayDate = calendar.date(bySetting: .day, value: day, of: previousMonthDate) ?? Date()
                                let dayTimestamp:Int = Int(calendar.startOfDay(for: dayDate).timeIntervalSince1970 * 1000)
                                //                            var missions: [MissionModel] = []
                                let list = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                                
                                DayView(timestampMilli: dayTimestamp, day: "\(day)", missions: list, row: rows)
                                
                                    .opacity(0.5) // 显示为淡色表示不是
                                
                            } else if dayIndex >= 0 && dayIndex < daysInMonth.count {
                                // 当前月的日期
                                let day = daysInMonth[dayIndex]
                                                     let monthDate = calendar.date(from: calendar.dateComponents([.year, .month], from: TimerManager.mediumCurrentDate)) ?? Date()
                                                     let dayDate2 = calendar.date(bySetting: .day, value: day, of: monthDate) ?? Date()
                                                     let dayTimestamp = Int(dayDate2.timeIntervalSince1970 * 1000)
                                                     let list = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                                                     let calendar = Calendar.current
                                                     let startOfMonth2 = calendar.date(from: calendar.dateComponents([.year, .month], from: TimerManager.mediumCurrentDate))
                                DayView(timestampMilli: dayTimestamp, day: "\(day)", missions: list, row: rows)
                                
                            } else if rowIndex == rows - 1 && columnIndex > lastWeekday {
                                // 填充下个月的日期
                                let day = nextMonthDays[columnIndex - lastWeekday - 1]
                                let dayDate = calendar.date(bySetting: .day, value: day, of: nextMonthDate) ?? Date()
                                let dayTimestamp = Int(dayDate.timeIntervalSince1970 * 1000)
                                let list = getMissionModels(dayTimestamp: dayTimestamp) ?? []
                                
                                DayView(timestampMilli: dayTimestamp, day: "\(day)", missions: list, row: rows)
                                    .opacity(0.5) // 显示为淡色表示不是
                            } else {
                                DayView(timestampMilli: 0, day: "", missions: [], row: rows) // 用空的DayView保持对称
                            }
                        }
                    }
                }
            }        .frame(height: 340)
            
        }
        .padding(.horizontal, 1)
        .frame(height: 400)
        .background(Color.black)
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }
}

struct DayView: View {
    let timestampMilli: Int
    let day: String
    let missions: [MissionModel]
    let row: Int
    
    // 判断给定的时间戳是否是今天
    func isToday(timestampMilli: Int) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(timestampMilli) / 1000)
        let calendar = Calendar.current
        
        return calendar.isDateInToday(date)
    }
    
    var body: some View {
        let count = row == 5 ? 3 : 2
        VStack(alignment: .leading, spacing: 2) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .opacity(isToday(timestampMilli: timestampMilli) ? 1 : 0) // 如果是今天，则显示蓝色圆圈
                    .frame(width: 13, height: 13) // 圆圈大小可以根据需求调整
                Text(day)
                    .foregroundColor(.white)
                    .font(.system(size: 10, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                //                Text("rows-\(row)")
                //                    .foregroundColor(.white)
                //                    .font(.system(size: 10, weight: .bold))
                //                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .padding(.top, 0)
            .padding(.leading, 2)
            
            if missions.count > (count - 1) {
                // 显示前两个任务和剩余任务数
                ForEach(missions.prefix(count - 1), id: \ .self) { mission in
                    Text(mission.title ?? "任务")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue))
                }
                HStack {
                    Text(missions[count - 1].title ?? "任务")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.system(size: 8))
                        .lineLimit(1)
                        .background(RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue))
                        .padding(.trailing, 1)
                    Text("+\(missions.count - count)")
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue))
                        .font(.system(size: 8))
                }
                .padding(.bottom,1)
                
            } else {
                // 显示所有任务
                ForEach(missions.prefix(count), id: \ .self) { mission in
                    Text(mission.title ?? "任务")
                        .foregroundColor(.white)
                        .font(.system(size: 8))
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .background(RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue))
                }
            }
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 3)
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(maxHeight: row == 5 ? 30 : 20)
            .aspectRatio(1, contentMode: .fit))
        //
    }
}





struct ContentView2: View {
    var body: some View {
        let sampleMission = MissionModelList(time: Int(Date().addingTimeInterval(7 * 24 * 60 * 60).timeIntervalSince1970 * 1000), lunar: "初七", listMissionModel: [
            MissionModel(objectId: "1", title: "测试任务1", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "2", title: "测试任务2", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "3", title: "测试任务3", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil),
            MissionModel(objectId: "4", title: "测试任务4", lunar: "初七", background_url: nil, end_time: nil, priorityStatus: nil, isFinished: false, isDelayed: false, color: nil)
        ])
        
        LargeCalendarComponent(missionModelList: [sampleMission])
            .padding(.top, 50)
            .padding(.bottom, 50)
    }
}


// MARK: - Widget Definition
//struct CalendarWidget: Widget {
//    let kind: String = "CalendarWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: CalendarWidgetProvider()) { entry in
//            CalendarWidgetView(entry: entry)
//        }
//        .configurationDisplayName("日历小组件")
//        .description("显示任务日历并支持交互操作")
//        .supportedFamilies([.systemMedium, .systemLarge])
//    }
//}


struct NewCalendarWidget: Widget {
    let kind: String = "NewCalendarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                CalendarWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CalendarWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .supportedFamilies([ .systemMedium,.systemLarge, .systemExtraLarge])
        .configurationDisplayName("configuration_display_name".localizable())
        .description("description".localizable())
        .supportedFamilies([ .systemMedium, .systemLarge, .systemExtraLarge])
        
    }
}

//#Preview(as: .systemSmall) {
//    NewCalendarWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
