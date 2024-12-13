//
//  EventReminderManager.swift
//  Runner
//
//  Created by 林智彬 on 2024/12/6.
//

import EventKit

class EventReminderManager {
    private let eventStore = EKEventStore()
    
    // 单例模式（可选）
    static let shared = EventReminderManager()
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
        completion(events)
    }
    
    // MARK: - 获取提醒事项
    func fetchReminders(completion: @escaping ([EKReminder]) -> Void) {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            completion(reminders ?? [])
        }
    }
    
    // MARK: - 同步事件到提醒
    func syncEventsToReminders(startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        fetchEvents(startDate: startDate, endDate: endDate) { [weak self] events in
            guard let self = self else { return }
            for event in events {
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
}
