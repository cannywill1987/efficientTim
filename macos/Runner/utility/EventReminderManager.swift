//
//  EventReminderManager.swift
//  Runner
//
//  Created by 林智彬 on 2024/12/6.
//

import EventKit
import AppKit

class EventReminderManager {
    let eventStore = EKEventStore()
    
    // 单例模式（可选）
    static let shared = EventReminderManager()
    private var ekEvents: [EKEvent] = [];
    private var ekReminders: [EKReminder] = [];
    private init() {}
    
    // MARK: - 授权方法
    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { (eventGranted, eventError) in
            guard eventGranted else {
                completion(false, eventError)
                return
            }
            self.eventStore.requestAccess(to: .reminder) { (reminderGranted, reminderError) in
                completion(reminderGranted, reminderError)
            }
        }
    }
    
    // MARK: - 获取日历事件
    func fetchEvents(startDate: Date, endDate: Date, completion: @escaping ([EKEvent]) -> Void) {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        //        customEvents = Utility.convertEventsToCustomEvents(events: events)
        
        completion(events)
    }
    
    // MARK: - 获取提醒事项
    func fetchReminders(completion: @escaping ([EKReminder]) -> Void) {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            self.ekReminders = reminders ?? []
            completion(self.ekReminders)
        }
    }
    
    
    
    
    // MARK: - 同步事件到提醒
    func syncEventsToReminders(startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        fetchEvents(startDate: startDate, endDate: endDate) { [weak self] customEvents in
            guard let self = self else { return }
            for event in customEvents {
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = event.title
                reminder.notes = event.notes
                reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.startDate)
                reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                
                do {
                    try self.eventStore.save(reminder, commit: true)
                } catch {
                    completion(false, error)
                    return
                }
            }
            completion(true, nil)
        }
    }
    
    // MARK: - 同步提醒到日历事件
    func syncRemindersToEvents(completion: @escaping (Bool, Error?) -> Void) {
        fetchReminders { [weak self] reminders in
            guard let self = self else { return }
            for reminder in reminders {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = reminder.title
                event.notes = reminder.notes
                event.startDate = reminder.dueDateComponents?.date
                event.endDate = reminder.dueDateComponents?.date?.addingTimeInterval(3600) // 默认持续1小时
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                
                do {
                    try self.eventStore.save(event, span: .thisEvent, commit: true)
                } catch {
                    completion(false, error)
                    return
                }
            }
            completion(true, nil)
        }
    }
    
    // 可以自动更新或者创建
    func updateEvent(id: String?, ekEvent: EKEvent, completion: @escaping (Bool, Error?) -> Void) {
        // 通过 customEvent 的 ID 查找目标事件
        
        // 如果事件是新建的（没有 eventIdentifier），创建一个新的 EKEvent
        let event: EKEvent
        // ,代表与&&
        if id != nil, let existingEvent = eventStore.event(withIdentifier: id!) {
            event = existingEvent
        } else {
            event = EKEvent(eventStore: eventStore)
        }
        
        // 设置事件属性
        event.title = ekEvent.title
        event.location = ekEvent.location
        event.startDate = ekEvent.startDate
        event.endDate = ekEvent.endDate
        event.isAllDay = ekEvent.isAllDay
        event.notes = ekEvent.notes
        
        // 设置日历
        event.calendar = ekEvent.calendar ?? eventStore.defaultCalendarForNewEvents
        
        // 添加重复规则
        if let recurrenceRules = ekEvent.recurrenceRules {
            event.recurrenceRules = recurrenceRules
        }
        
        // 保存事件
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            print("Event saved successfully: \(event.eventIdentifier ?? "unknown identifier")")
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    /// 更新或创建 EKReminder
    func updateReminder(id: String?, ekReminder: EKReminder, completion: @escaping (Bool, Error?) -> Void) {
        // 通过 ID 查找目标 Reminder
        let reminder: EKReminder
        if let id = id, let existingReminder = eventStore.calendarItem(withIdentifier: id) as? EKReminder {
            reminder = existingReminder
        } else {
            reminder = EKReminder(eventStore: eventStore)
        }
        
        // 设置 Reminder 属性
        reminder.title = ekReminder.title
        reminder.notes = ekReminder.notes
        reminder.dueDateComponents = ekReminder.dueDateComponents
        reminder.startDateComponents = ekReminder.startDateComponents
        reminder.isCompleted = ekReminder.isCompleted
        reminder.priority = ekReminder.priority
        reminder.alarms = ekReminder.alarms
        
        // 设置所属日历
        reminder.calendar = ekReminder.calendar ?? eventStore.defaultCalendarForNewReminders()
        
        // 添加重复规则
        if let recurrenceRules = ekReminder.recurrenceRules {
            reminder.recurrenceRules = recurrenceRules
        }
        //           let result = Utility.convertToEKReminder(from: [reminder], eventStore: EventReminderManager.shared.eventStore)
        
        let res:[[String: Any]] = EventReminderManager.serializeReminderList(customReminders: [reminder])
        // 创建数据字典
        let data: [String: Any] = [
            "success": true,
            "data":res
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("jsonData \(jsonString)")
            }
        } catch {
            // 捕获 JSON 转换错误
        }
        //   let result = Utility.convertToEKReminder(from: reminder, eventStore: eventStore);
        print("result");
        // 保存 Reminder
        do {
                           try eventStore.save(reminder, commit: true)
                           print("Reminder saved successfully: \(reminder.calendarItemIdentifier)")
                           completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    func createEvent(ekEvent: EKEvent, completion: @escaping (Bool, Error?) -> Void) {
        // 通过 customEvent 的 ID 查找目标事件
        //        guard let targetEvent = customEvents.first(where: { $0.id == customEvent.id }) else {
        //            completion(false, NSError(domain: "EventNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found in customEvents"]))
        //            return
        //        }
        
        // 开始同步操作
        //        let ekEvent = targetEvent.ekEvent
        
        // 如果事件是新建的（没有 eventIdentifier），创建一个新的 EKEvent
        let event: EKEvent
        if let existingEvent = eventStore.event(withIdentifier: ekEvent.eventIdentifier) {
            event = existingEvent
        } else {
            event = EKEvent(eventStore: eventStore)
        }
        
        // 设置事件属性
        event.title = ekEvent.title
        event.location = ekEvent.location
        event.startDate = ekEvent.startDate
        event.endDate = ekEvent.endDate
        event.isAllDay = ekEvent.isAllDay
        event.notes = ekEvent.notes
        
        // 设置日历
        event.calendar = ekEvent.calendar ?? eventStore.defaultCalendarForNewEvents
        
        // 添加重复规则
        if let recurrenceRules = ekEvent.recurrenceRules {
            event.recurrenceRules = recurrenceRules
        }
        
        // 保存事件
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            print("Event saved successfully: \(event.eventIdentifier ?? "unknown identifier")")
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    //打开指定的提醒事项
    func openReminder(withIdentifier identifier: String) {
        let eventStore = EKEventStore()
        
        // 检查权限
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    // 跳转到提醒事项 App
                    if let url = URL(string: "x-apple-reminderkit://") { // 替换为 Reminders 应用的正确 URL
                        if NSWorkspace.shared.open(url) {
                            print("Opened Reminders app successfully.")
                        } else {
                            print("Failed to open Reminders app.")
                        }
                    } else {
                        print("Invalid URL for Reminders app.")
                    }
                }
            } else {
                print("Access to reminders not granted.")
            }
        }
    }
    
    
  
    func openCalendarApp(at timestamp: Int64) {
        // 将毫秒时间戳转换为秒时间戳
        let secondsTimestamp = timestamp / 1000
        // 构建 URL Scheme
        if let url = URL(string: "calshow:\(secondsTimestamp)") {
            if NSWorkspace.shared.open(url) {
                print("Opened Calendar app successfully.")
            } else {
                print("Failed to open Calendar app.")
            }
        } else {
            print("Invalid URL for Calendar app.")
        }
    }
    
    /**得到当前毫秒时间戳**/
    static  func getCurrentTimeStampByMilliSeconds() -> CLongLong{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond;
    }
    
    static func serializeRecurrenceRule(_ rule: EKRecurrenceRule) -> [String: Any] {
        var recurrenceDict: [String: Any] = [:]
        
        recurrenceDict["frequency"] = rule.frequency.rawValue // 日、周、月、年等
        recurrenceDict["interval"] = rule.interval // 间隔
        recurrenceDict["endDate"] = rule.recurrenceEnd?.endDate?.description ?? NSNull()
        
        if let daysOfTheWeek = rule.daysOfTheWeek {
            recurrenceDict["daysOfTheWeek"] = daysOfTheWeek.map { $0.dayOfTheWeek.rawValue }
        }
        if let daysOfTheMonth = rule.daysOfTheMonth {
            recurrenceDict["daysOfTheMonth"] = daysOfTheMonth
        }
        if let monthsOfTheYear = rule.monthsOfTheYear {
            recurrenceDict["monthsOfTheYear"] = monthsOfTheYear
        }
        if let setPositions = rule.setPositions {
            recurrenceDict["setPositions"] = setPositions
        }
        
        return recurrenceDict
    }
    
    static func serializeEvent(event: EKEvent) -> [String: Any] {
        //        let event = customEvent
        var structuredLocationData: [String: Any] = [:]
        if let structuredLocation = event.structuredLocation {
            structuredLocationData = [
                "title": structuredLocation.title ?? NSNull(),
                "geoLocation": [
                    "latitude": structuredLocation.geoLocation?.coordinate.latitude,
                    "longitude": structuredLocation.geoLocation?.coordinate.longitude
                ],
                "radius": structuredLocation.radius
            ]
        }
        
        let recurrenceRule = event.recurrenceRules?.first
        var recurrenceData: [String: Any] = [:]
        if let rule = recurrenceRule {
            recurrenceData = serializeRecurrenceRule(rule)
        }
        
        return [
            "id": event.eventIdentifier, // 添加唯一 ID
            "title": event.title ?? NSNull(),
            "location": event.location ?? NSNull(),
            "structuredLocation": structuredLocationData,
            "startDate": event.startDate?.description ?? NSNull(),
            "endDate": event.endDate?.description ?? NSNull(),
            "allDay": event.isAllDay,
            "recurrence": recurrenceData,
        ]
    }
    
    //    static func serializeCustomEventList(customEvents: [EKEvent]) -> [[String: Any]] {
    //        return customEvents.map { serializeCustomEvent(customEvent: $0) }
    //    }
    
    static func serializeEventList(events: [EKEvent]) -> [[String: Any]] {
        return events.map { serializeEvent(event: $0) }
    }
    
    //    static func serializeEvent(event: EKEvent) -> [String: Any] {
    //        var structuredLocationData: [String: Any] = [:]
    //        if let structuredLocation = event.structuredLocation {
    //            structuredLocationData = [
    //                "title": structuredLocation.title ?? NSNull(),
    //                "geoLocation": [
    //                    "latitude": structuredLocation.geoLocation?.coordinate.latitude,
    //                    "longitude": structuredLocation.geoLocation?.coordinate.longitude
    //                ],
    //                "radius": structuredLocation.radius
    //            ]
    //        }
    //
    //        let recurrenceRule = event.recurrenceRules?.first
    //        var recurrenceData: [String: Any] = [:]
    //        if let rule = recurrenceRule {
    //            recurrenceData = serializeRecurrenceRule(rule)
    //        }
    //
    //        return [
    //            "location": event.location ?? NSNull(),
    //            "structuredLocation": structuredLocationData,
    //            "startDate": event.startDate?.description ?? NSNull(),
    //            "endDate": event.endDate?.description ?? NSNull(),
    //            "allDay": event.isAllDay,
    ////            "floating": event.isFloating,
    //            "recurrence": recurrenceData,
    ////            "travelTime": event.travelTime ?? NSNull(),
    //            "startLocation": event.structuredLocation?.geoLocation?.description ?? NSNull()
    //        ]
    //    }
    
    //    static func serializeEventList(events: [EKEvent]) -> [[String: Any]] {
    //        return events.map { serializeEvent(event: $0) }
    //    }
    
    func deleteEvent(withIdentifier identifier: String, completion: @escaping (Bool, Error?) -> Void) {
        let eventStore = EKEventStore()
        
        // 检查权限
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                DispatchQueue.global().async {
                    // 查找事件
                    if let event = eventStore.event(withIdentifier: identifier) {
                        do {
                            // 删除事件
                            try eventStore.remove(event, span: .thisEvent, commit: true)
                            DispatchQueue.main.async {
                                print("Event deleted successfully: \(identifier)")
                                completion(true, nil)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Failed to delete event: \(error.localizedDescription)")
                                completion(false, error)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Event not found for identifier: \(identifier)")
                            completion(false, NSError(domain: "EventNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found"]))
                        }
                    }
                }
            } else {
                print("Access to events not granted.")
                completion(false, error)
            }
        }
    }
    
    func deleteReminder(withIdentifier identifier: String, completion: @escaping (Bool, Error?) -> Void) {
        let eventStore = EKEventStore()

        // 检查权限
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted {
                DispatchQueue.global().async {
                    // 查找提醒事项
                    if let reminder = eventStore.calendarItem(withIdentifier: identifier) as? EKReminder {
                        do {
                            // 删除提醒事项
                            try eventStore.remove(reminder, commit: true)
                            DispatchQueue.main.async {
                                print("Reminder deleted successfully: \(identifier)")
                                completion(true, nil)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Failed to delete reminder: \(error.localizedDescription)")
                                completion(false, error)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Reminder not found for identifier: \(identifier)")
                            completion(false, NSError(domain: "ReminderNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Reminder not found"]))
                        }
                    }
                }
            } else {
                print("Access to reminders not granted.")
                completion(false, error)
            }
        }
    }
    
    static func serializeReminder(reminder: EKReminder) -> [String: Any] {
        var reminderDict: [String: Any] = [:]
        
        // 唯一标识符
        reminderDict["id"] = reminder.calendarItemExternalIdentifier
        
        // 开始时间 (毫秒时间戳)
        if let startDate = reminder.startDateComponents?.date {
            reminderDict["startDate"] = startDate.timeIntervalSince1970 * 1000 // 转换为毫秒
        } else {
            reminderDict["startDate"] = NSNull()
        }
        
        // 截止时间 (毫秒时间戳)
        if let dueDate = reminder.dueDateComponents?.date {
            reminderDict["dueDate"] = dueDate.timeIntervalSince1970 * 1000 // 转换为毫秒
        } else {
            reminderDict["dueDate"] = NSNull()
        }
        
        // 完成状态
        reminderDict["isCompleted"] = reminder.isCompleted
        reminderDict["completionDate"] = reminder.completionDate?.timeIntervalSince1970 ?? NSNull()
        
        // 优先级
        reminderDict["priority"] = reminder.priority
        
        // 标题和备注（继承自 EKCalendarItem）
        reminderDict["title"] = reminder.title ?? NSNull()
        reminderDict["notes"] = reminder.notes ?? NSNull()
        
        // 日历信息
        reminderDict["calendar"] = reminder.calendar?.title ?? NSNull()
        
        // Tags (扩展逻辑: 从备注中解析 Tags 或自定义字段中获取)
        if let notes = reminder.notes, notes.contains("Tags:") {
            let tags = notes.split(separator: "\n").first { $0.starts(with: "Tags:") }
            reminderDict["tags"] = tags?.replacingOccurrences(of: "Tags: ", with: "") ?? NSNull()
        } else {
            reminderDict["tags"] = NSNull() // 如果没有 Tags
        }
        
        // Alarms
        if let alarms = reminder.alarms {
            var alarmList: [[String: Any]] = []
            for alarm in alarms {
                var alarmDict: [String: Any] = [:]
                if alarm.relativeOffset != 0 {
                    alarmDict["type"] = "relative"
                    alarmDict["offset"] = alarm.relativeOffset * 1000 // 转换为毫秒
                }
                if let absoluteDate = alarm.absoluteDate {
                    alarmDict["type"] = "absolute"
                    alarmDict["date"] = absoluteDate.timeIntervalSince1970 * 1000 // 转换为毫秒
                }
                if let structuredLocation = alarm.structuredLocation {
                    alarmDict["type"] = "location"
                    alarmDict["location"] = [
                        "title": structuredLocation.title ?? "",
                        "latitude": structuredLocation.geoLocation?.coordinate.latitude ?? NSNull(),
                        "longitude": structuredLocation.geoLocation?.coordinate.longitude ?? NSNull(),
                        "radius": structuredLocation.radius
                    ]
                }
                alarmList.append(alarmDict)
            }
            reminderDict["alarms"] = alarmList
        } else {
            reminderDict["alarms"] = NSNull()
        }
        
        // Recurrence Rules
        if let recurrenceRules = reminder.recurrenceRules, !recurrenceRules.isEmpty {
            reminderDict["recurrence"] = recurrenceRules.map { serializeRecurrenceRule($0) }
        } else {
            reminderDict["recurrence"] = NSNull()
        }
        
        return reminderDict
    }
    
    //    static func serializeReminderList(reminders: [EKReminder]) -> [[String: Any]] {
    //        return reminders.map { serializeReminder(reminder: $0) }
    //    }
    
    //    static func serializeCustomReminder(customReminder: EKReminder) -> [String: Any] {
    //        let reminder = customReminder
    //        var reminderDict: [String: Any] = [:]
    //
    ////        1.    calendarItemIdentifier 的作用范围：
    ////        •    它是当前设备上的唯一标识符，用于标识特定的提醒或事件。
    ////        •    如果删除提醒并重新创建，即使内容相同，calendarItemIdentifier 也会变化。
    ////        2.    calendarItemExternalIdentifier 的用途：
    ////        •    它用于跨设备或备份恢复时的识别。
    ////        •    在某些情况下（例如，提醒被移动到另一个日历），calendarItemExternalIdentifier 可能会变化。
    //        // 添加唯一 ID
    //        reminderDict["id"] = reminder.calendarItemIdentifier
    //
    //        print("Unique Identifier: \(reminder.calendarItemIdentifier)")
    //           print("External Identifier: \(reminder.calendarItemExternalIdentifier ?? "N/A")")
    //
    //        // 开始时间 (毫秒时间戳)
    //        if let startDate = reminder.startDateComponents?.date {
    //            reminderDict["startDate"] = startDate.timeIntervalSince1970 * 1000 // 转换为毫秒
    //        } else {
    //            reminderDict["startDate"] = NSNull()
    //        }
    //
    //        // 截止时间 (毫秒时间戳)
    //        if let dueDate = reminder.dueDateComponents?.date {
    //            reminderDict["dueDate"] = dueDate.timeIntervalSince1970 * 1000 // 转换为毫秒
    //        } else {
    //            reminderDict["dueDate"] = NSNull()
    //        }
    //
    //        // 完成状态
    //        reminderDict["isCompleted"] = reminder.isCompleted
    //        reminderDict["completionDate"] = reminder.completionDate?.timeIntervalSince1970 ?? NSNull()
    //
    //        // 优先级
    //        reminderDict["priority"] = reminder.priority
    //
    //        // 标题和备注（继承自 EKCalendarItem）
    //        reminderDict["title"] = reminder.title ?? NSNull()
    //        reminderDict["notes"] = reminder.notes ?? NSNull()
    //
    //        // 日历信息
    //        reminderDict["calendar"] = reminder.calendar?.title ?? NSNull()
    //
    //        return reminderDict
    //    }
    
    static func serializeReminderList(customReminders: [EKReminder]) -> [[String: Any]] {
        return customReminders.map { serializeReminder(reminder: $0) }
    }
    
    //    static func convertEventsToCustomEvents(events: [EKEvent]) -> [CustomEvent] {
    //        return events.map { CustomEvent(from: $0) }
    //    }
    
    //    static func convertRemindersToCustomReminders(reminders: [EKReminder]) -> [CustomReminder] {
    //        return reminders.map { CustomReminder(from: $0) }
    //    }
    
    static func createCustomEvent(from data: [String: Any], eventStore: EKEventStore) -> EKEvent? {
        //        guard let id = data["_id"] as? String else {
        //            print("Error: Missing required '_id'")
        //            return nil
        //        }
        
        // 创建新的 EKEvent
        let ekEvent = EKEvent(eventStore: eventStore)
        //        ekEvent.eventIdentifier = id
        // 设置事件属性
        ekEvent.title = data["title"] as? String ?? "Untitled"
        ekEvent.location = data["group_id"] as? String
        //        ekEvent.alarms = ekEvent.
        if let startTime = data["start_time"] as? TimeInterval {
            ekEvent.startDate = Date(timeIntervalSince1970: startTime / 1000) // 转换为秒
        }
        if let endTime = data["end_time"] as? TimeInterval {
            ekEvent.endDate = Date(timeIntervalSince1970: endTime / 1000) // 转换为秒
        }
        ekEvent.isAllDay = false
        ekEvent.notes = data["message"] as? String ?? ""
        
        // 设置颜色 (自定义逻辑：如果需要保存颜色，可以扩展 EKEvent 或保存到其他字段)
        if let colorValue = data["color"] as? UInt {
            ekEvent.calendar = eventStore.defaultCalendarForNewEvents
            ekEvent.calendar?.cgColor = CGColor(red: CGFloat((colorValue & 0xFF0000) >> 16) / 255.0,
                                                green: CGFloat((colorValue & 0x00FF00) >> 8) / 255.0,
                                                blue: CGFloat(colorValue & 0x0000FF) / 255.0,
                                                alpha: 1.0)
        }
        
        // 设置优先级 (假设将 priorityStatus 转为 EKEvent 的可用属性)
        if let priorityStatus = data["priorityStatus"] as? Int {
            ekEvent.availability = priorityStatus == 3 ? .busy : .free
        }
        
        //        id: id, ekEvent: ekEvent
        // 创建 CustomEvent 对象
        //        let customEvent = CustomEvent(from: ekEvent)
        //        print("id \(ekEvent.eventIdentifier)")
        ////        if ekEvent.eventIdentifier == nil {
        ////            ekEvent.eventIdentifier = id;
        ////        }
        //        customEvent.id = id
        return ekEvent
    }
    /// 生成当天日期的时间点（绝对时间）并返回毫秒时间戳
    /// - Parameters:
    ///   - hour: 小时
    ///   - minute: 分钟
    ///   - second: 秒
    /// - Returns: 毫秒时间戳 (`Int64`)
    static func generateAbsoluteTimeInMilliseconds() -> Int64? {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        
        if let date = calendar.date(from: components) {
            return Int64(date.timeIntervalSince1970 * 1000) // 转换为毫秒时间戳
        } else {
            return nil
        }
    }
    
    static func generateAbsoluteDateFromMilliseconds(timestamp: Int64) -> Int64? {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000) // 将毫秒时间戳转换为 Date 对象

        // 提取年、月、日的组件
        var components = calendar.dateComponents([.year, .month, .day], from: date)

        // 将时间重置为当天的年、月、日
        if let absoluteDate = calendar.date(from: components) {
            return Int64(absoluteDate.timeIntervalSince1970 * 1000) // 返回毫秒时间戳
        } else {
            return nil
        }
    }
    
    static func isArrayEmptyOrAllFalse(_ array: [Bool]?) -> Bool {
        // 如果数组为 nil 或为空，直接返回 true
        guard let array = array, !array.isEmpty else {
            return true
        }
        // 判断数组中是否所有元素都为 false
        return array.allSatisfy { !$0 }
    }

    static func hasValueInArray(_ array: [Bool]?) -> Bool {
        // 如果数组非空且至少有一个 true，返回 true
        return !(isArrayEmptyOrAllFalse(array))
    }
    
    static func convertToEKReminder(from data: [String: Any], eventStore: EKEventStore) -> EKReminder? {
        let reminder = EKReminder(eventStore: eventStore)
        
        // 设置标题
        reminder.title = data["title"] as? String ?? "Untitled"
        if reminder.title == "工作日重复-21:00提醒-55555555555555a" {
            
        }
        // 设置备注
        reminder.notes = data["message"] as? String
        
        
        
        //        ) + (data["daily_end_time"] as? TimeInterval ?? 0)
        // 设置截止时间
        if(data["repetiveType"] as? Int == 1) {
            if let endTime1 = data["end_time"] as? TimeInterval, let endTime2 = data["daily_end_time"] as? TimeInterval {
                let dueDateComponents = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: Date(timeIntervalSince1970: (endTime1 + endTime2) / 1000)
                )
                reminder.dueDateComponents = dueDateComponents
            } else {
                reminder.dueDateComponents = nil
            }
        } else {
            if let endTime1 = data["end_time"] as? TimeInterval{
                let dueDateComponents = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: Date(timeIntervalSince1970: (endTime1) / 1000)
                )
                reminder.dueDateComponents = dueDateComponents
            } else {
                reminder.dueDateComponents = nil
            }
        }
        
        
        
        // 设置开始时间
        if let startTime = data["start_time"] as? TimeInterval {
            let startDateComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: Date(timeIntervalSince1970: startTime / 1000)
            )
            reminder.startDateComponents = startDateComponents
        } else {
            reminder.startDateComponents = nil
        }
        
        // 设置完成状态
        reminder.isCompleted = data["isFinished"] as? Bool ?? false
        
        // 设置优先级
        if let priorityStatus = data["priorityStatus"] as? Int {
            reminder.priority = mapPriorityToReminderPriority(priorityStatus)
        }
        
        // 配置重复规则
        if let repetiveType = data["repetiveType"] as? Int,
           let repetiveValue = data["repetiveValue"] as? Int,
           let repeativeDate = data["repetive_end_time"] as? Int,
           let repetiveWeekDay = data["repetiveWeekDay"] as? [Bool] {
            if let recurrenceRule = configureRecurrenceRule(
                repetiveType: repetiveType,
                repetiveValue: repetiveValue,
                repeativeDate: repeativeDate,
                repetiveWeekDay: repetiveWeekDay
            ) {
                reminder.recurrenceRules = [recurrenceRule]
            }
        }
        // 设置提醒时间 (alarms)
        if data["repetiveType"] as! Int == 2 { //按周
            let hasVal = hasValueInArray(data["repetiveWeekDay"] as? [Bool]) == true;
            if hasVal == true, let alertTime = data["alert_time"] as? TimeInterval {
                let baseDate = Date(timeIntervalSince1970: TimeInterval(generateAbsoluteTimeInMilliseconds() ?? 0) / 1000)
                let alertDate = baseDate.addingTimeInterval(alertTime / 1000) // 将 alert_time 从毫秒转换为秒并添加
                let alarm = EKAlarm(absoluteDate: alertDate)
                reminder.alarms = [alarm]
            } else {
                // 周一就周一几点提醒
                if  let endTime1 = data["end_time"] as? TimeInterval, let alertTime = data["alert_time"] as? TimeInterval {
                    let baseDate = Date(timeIntervalSince1970: TimeInterval(generateAbsoluteDateFromMilliseconds(timestamp: Int64(endTime1)) ?? 0) / 1000)
                    let alertDate = baseDate.addingTimeInterval(alertTime / 1000) // 将 alert_time 从毫秒转换为秒并添加
                    let alarm = EKAlarm(absoluteDate: alertDate)
                    reminder.alarms = [alarm]
                }
            }
        } else if data["repetiveType"] as! Int == 3 { // 按月
            if  let endTime1 = data["end_time"] as? TimeInterval, let alertTime = data["alert_time"] as? TimeInterval {
                let baseDate = Date(timeIntervalSince1970: TimeInterval(generateAbsoluteDateFromMilliseconds(timestamp: Int64(endTime1)) ?? 0) / 1000)
                let alertDate = baseDate.addingTimeInterval(alertTime / 1000) // 将 alert_time 从毫秒转换为秒并添加
                let alarm = EKAlarm(absoluteDate: alertDate)
                reminder.alarms = [alarm]
            }
        } else if data["repetiveType"] as! Int == 4 { // 按年
//            if  let endTime1 = data["end_time"] as? TimeInterval, let alertTime = data["alert_time"] as? TimeInterval {
//                let baseDate = Date(timeIntervalSince1970: TimeInterval(endTime1 ?? 0) / 1000)
//                let alertDate = baseDate.addingTimeInterval(alertTime / 1000) // 将 alert_time 从毫秒转换为秒并添加
//                let alarm = EKAlarm(absoluteDate: alertDate)
//                reminder.alarms = [alarm]
//            }
        }  else {
            if let alertTime = data["alert_time"] as? TimeInterval {
                let alertDate = Date(timeIntervalSince1970: TimeInterval(alertTime ?? 0) / 1000)
                //                let alertDate = baseDate.addingTimeInterval(alertTime / 1000) // 将 alert_time 从毫秒转换为秒并添加
                let alarm = EKAlarm(absoluteDate: alertDate)
                reminder.alarms = [alarm]
            }
        }
        // 设置提醒的所属日历
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        return reminder
    }
    
    // 优先级映射方法
    static func mapPriorityToReminderPriority(_ priorityStatus: Int) -> Int {
        switch priorityStatus {
        case 0:
            return 1 // 高优先级
        case 1:
            return 5 // 中优先级
        case 2:
            return 9 // 低优先级
        default:
            return 0 // 无优先级
        }
    }
    
    // 配置重复规则
    static func configureRecurrenceRule(
        repetiveType: Int,
        repetiveValue: Int,
        repeativeDate: Int, // 毫秒时间戳
        repetiveWeekDay: [Bool]
    ) -> EKRecurrenceRule? {
        // 确定重复的频率
        let frequency: EKRecurrenceFrequency
        switch repetiveType {
        case 1:
            frequency = .daily
        case 2:
            frequency = .weekly
        case 3:
            frequency = .monthly
        case 4:
            frequency = .yearly
        default:
            return nil
        }
        
        // 重复间隔
        let interval = repetiveValue
        
        // 设置重复的结束日期
        let recurrenceEnd: EKRecurrenceEnd?
        if repeativeDate > 0 {
            // 将毫秒时间戳转换为 Date
            let endDate = Date(timeIntervalSince1970: TimeInterval(repeativeDate) / 1000)
            recurrenceEnd = EKRecurrenceEnd(end: endDate)
        } else {
            recurrenceEnd = nil
        }
        
        // 如果是按周重复，处理指定的星期几
        if frequency == .weekly {
            var daysOfTheWeek: [EKRecurrenceDayOfWeek] = []
            
            // 按星期一到星期日的顺序生成 daysOfTheWeek
            let adjustedWeekDayIndex = [2, 3, 4, 5, 6, 7, 1] // 将周日放到最后
            for (adjustedIndex, originalIndex) in adjustedWeekDayIndex.enumerated() {
                if repetiveWeekDay[adjustedIndex] {
                    if let day = EKWeekday(rawValue: originalIndex) {
                        daysOfTheWeek.append(EKRecurrenceDayOfWeek(day))
                    }
                }
            }
            
            // 按周重复，设置 daysOfTheWeek
            return EKRecurrenceRule(
                recurrenceWith: frequency,
                interval: interval,
                daysOfTheWeek: daysOfTheWeek,
                daysOfTheMonth: nil,
                monthsOfTheYear: nil,
                weeksOfTheYear: nil,
                daysOfTheYear: nil,
                setPositions: nil,
                end: recurrenceEnd
            )
        }
        
        // 返回常规的重复规则
        return EKRecurrenceRule(recurrenceWith: frequency, interval: interval, end: recurrenceEnd)
    }
}
