//
//  DeviceActivityMonitorExtension.swift
//  MyDeviceActivityMonitorExtension
//
//  Created by 林智彬 on 2024/4/1.
//

import Foundation
import DeviceActivity
import MobileCoreServices
import ManagedSettings
import DeviceActivity
import FamilyControls
import UserNotifications
import SwiftUI



class DeviceActivityUtil {
    static func convertDateComponentsToString(dateComponents: DateComponents) -> String {
        //        let dateComponents = DateComponents(hour: hour, minute: minute)
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
// 应该是会自动执行
@available(iOS 16.0, *)
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    // MARK: 存储要限制的应用信息的变量
        @AppStorage("value", store: UserDefaults(suiteName: Params.APP_GROUP))
        var value:Int = 1;
    //
    //    // MARK: 存储要限制的应用信息的变量
        @AppStorage("value", store: UserDefaults(suiteName: Params.APP_GROUP))
        var value2:Int = 2;
    
    func isTodayInWeekend(weekend: [Bool]) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // 注意: 在西方的日历系统中，周日是1，周一是2，以此类推，周六是7
        // 所以我们需要将其转换为数组的索引，周日是0，周一是1，以此类推，周六是6
        let index = (weekday - 1) % 7
        return weekend[index]
    }
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
//        NotificationManager.shared.requestNotificationCreate(
//            title: "locascreen_start_in_five_minute",
//            subtitle: "22222222"
//        )
        
        print("interval did start")
        let timelineItem:TimelineItem? = SharepreferenceManager.shareInstance().getTimelineItem(id: activity.rawValue, forKey: SharePreferenceKey.TimelineKey) ?? nil;
        let weekend = timelineItem?.weekend ?? [true,true,false,false,false,false,false]; // [日，一，二，三，四，五，六]
        NotificationManager.shared.requestNotificationCreate(
            title: "测试用",
            subtitle: "\(timelineItem?.id)")
        if(timelineItem != nil) {
            if(isTodayInWeekend(weekend: weekend) && timelineItem?.isOn == true) {
                NotificationManager.shared.requestNotificationCreate(
                    title: "locascreen_start".localizable(),
                    subtitle: "\(DeviceActivityUtil.convertDateComponentsToString(dateComponents: timelineItem!.startTime))-\(DeviceActivityUtil.convertDateComponentsToString(dateComponents: timelineItem!.endTime))",
                    userInfo: ["ACTION" : Params.START_MONITORING, "ACTIVITY_NAME": activity.rawValue]
                )
                
                timelineItem?.isRunning = true
//                store.clearAllSettings();
                store.shield.applications = Set(timelineItem?.applicationTokens ?? [])
                store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(Set(timelineItem?.activityCategoryTokens ?? []), except: Set())
                store.shield.webDomains = Set(timelineItem?.webDomainTokens ?? [])
                
                //more rules
                        store.media.denyExplicitContent = true
                        
                        //prevent app removal
                        store.application.denyAppRemoval = true
                        print("deny app removal: ",  store.application.denyAppRemoval ?? false)
                        
                        //prevent set date time
                        store.dateAndTime.requireAutomaticDateAndTime = true
            }
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        NotificationManager.shared.requestNotificationCreate(
            title: "locascreen_start_in_five_minute",
            subtitle: "33333333"
        )
        let timelineItem:TimelineItem? = SharepreferenceManager.shareInstance().getTimelineItem(id: activity.rawValue, forKey: SharePreferenceKey.TimelineKey) ?? nil;
        store.shield.applications = nil
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.clearAllSettings()
        timelineItem?.isRunning = false
        if(timelineItem != nil) {
            NotificationManager.shared.requestNotificationCreate(
                title: "scheduled_task_has_ended".localizable(),
//                subtitle: activity.rawValue,
                subtitle: "\(DeviceActivityUtil.convertDateComponentsToString(dateComponents: timelineItem!.startTime))-\(DeviceActivityUtil.convertDateComponentsToString(dateComponents: timelineItem!.endTime))",
                userInfo: ["ACTION" : Params.END_MONITORING, "ACTIVITY_NAME": activity.rawValue]
            )
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivity.DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        store.shield.applications = nil // 해당 이벤트가 충족되면 제한 해제
//        NotificationManager.shared.requestNotificationCreate(
//            title: "locascreen_start_in_five_minute",
//            subtitle: "44444444"
//        )
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        NotificationManager.shared.requestNotificationCreate(
            title: "locascreen_start_in_five_minute",
            subtitle: "555555555"
        )
        // Handle the warning before the interval starts.
        //MARK: 如果用户开启了通知，则执行
//        let timelineItem:TimelineItem? = SharepreferenceManager.shareInstance().getTimelineItem(id: activity.rawValue, forKey: SharePreferenceKey.TimelineKey) ?? nil;
//        if(timelineItem != nil) {
//            NotificationManager.shared.requestNotificationCreate(
//                title: "locascreen_start_in_five_minute".localizable(),
//                subtitle: "\(DeviceActivityUtil.convertDateComponentsToString(dateComponents: timelineItem!.startTime))-\(DeviceActivityUtil.convertDateComponentsToString(dateComponents: timelineItem!.endTime))"
//            )
//        }
        //        if isUserNotificationOn {
        //            if activity == .dailySleep { //MARK: 睡眠日程开始通知
        //                NotificationManager.shared.requestNotificationCreate(
        //                    title: "睡眠计划即将开始。",
        //                    subtitle: "在\(warningTime)分钟后开始设定的睡眠计划"
        //                )
        //            } else if activity == .additionalTime {
        //                if additionalCount < 2 { //MARK: 第一次延长后的睡眠日程开始通知
        //                    NotificationManager.shared.requestNotificationCreate(
        //                        title: "约定的时间即将到来。",
        //                        subtitle: "在\(additionalMinute)分钟后开始设定的睡眠计划"
        //                    )
        //                } else { //MARK: 2회째 연장 이후 수면 스케줄 시작 알림
        //                    NotificationManager.shared.requestNotificationCreate(
        //                        title: "最后的约定即将结束。",
        //                        subtitle: "在\(additionalMinute)分钟后重新开始设定的睡眠计划"
        //                    )
        //                }
        //            }
        //        }
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        NotificationManager.shared.requestNotificationCreate(
            title: "intervalWillEndWarning",
            subtitle: "555555555"
        )
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivity.DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        let schedule = DeviceActivityCenter().schedule(for: activity)
             let warningTime = schedule?.warningTime
        NotificationManager.shared.requestNotificationCreate(
            title: "eventWillReachThresholdWarning",
            subtitle: "555555555"
        )
        // Handle the warning before the event reaches its threshold.
    }
    
}
