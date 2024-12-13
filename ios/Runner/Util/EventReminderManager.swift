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
    private var customEvents: [CustomEvent] = [];
    private var customReminders: [CustomReminder] = [];
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
    func fetchEvents(startDate: Date, endDate: Date, completion: @escaping ([CustomEvent]) -> Void) {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        customEvents = Utility.convertEventsToCustomEvents(events: events)
        
        completion(customEvents)
    }
    
    // MARK: - 获取提醒事项
    func fetchReminders(completion: @escaping ([CustomReminder]) -> Void) {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            self.customReminders = Utility.convertRemindersToCustomReminders(reminders: reminders ?? [])
            completion(self.customReminders)
        }
    }
    
    // MARK: - 同步事件到提醒
    func syncEventsToReminders(startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        fetchEvents(startDate: startDate, endDate: endDate) { [weak self] customEvents in
            guard let self = self else { return }
            for event in customEvents {
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = event.ekEvent.title
                reminder.notes = event.ekEvent.notes
                reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.ekEvent.startDate)
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
                event.title = reminder.ekReminder.title
                event.notes = reminder.ekReminder.notes
                event.startDate = reminder.ekReminder.dueDateComponents?.date
                event.endDate = reminder.ekReminder.dueDateComponents?.date?.addingTimeInterval(3600) // 默认持续1小时
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
