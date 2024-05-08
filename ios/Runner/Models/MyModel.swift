//
//  MyModel.swift
//  Runner
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

@available(iOS 16.0, *)
class MyModel: ObservableObject {
    // MARK: 存储要限制的应用信息的变量
    //    @AppStorage("value", store: UserDefaults(suiteName: Params.APP_GROUP))
    //    var value:Int = 1;
    //
    //    // MARK: 存储要限制的应用信息的变量
    //    @AppStorage("value", store: UserDefaults(suiteName: Params.APP_GROUP))
    //    var value2:Int = 2;
    static let shared = MyModel()
    let store = ManagedSettingsStore()
    
    func isTodayInWeekend(weekend: [Bool]) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // 注意: 在西方的日历系统中，周日是1，周一是2，以此类推，周六是7
        // 所以我们需要将其转换为数组的索引，周日是0，周一是1，以此类推，周六是6
        let index = (weekday - 1) % 7
        return weekend[index]
    }
    
    private init() {
        activitySelection = FamilyActivitySelection(includeEntireCategory: true)
    }
    
    @Published var activitySelection = FamilyActivitySelection() {
        willSet {
            print ("got here \(newValue)")
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            let webCategories = newValue.webDomainTokens
            //            selectionToDiscourage.categoryTokens = newValue.categoryTokens
            //            selectionToDiscourage.webDomainTokens = newValue.webDomainTokens
            //            applicationTokensArray = Array(applications)
            //            categoriesTokensArray = Array(categories)
            
            //            //开始禁用app
            //                        store.shield.applications = applications.isEmpty ? nil : applications
            //                        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
            //                        store.shield.webDomains = webCategories
        }
    }
    
    func stopMonitoring(activityName: String) {
        store.clearAllSettings()
        //可以同时关闭多个
        DeviceActivityCenter().stopMonitoring([DeviceActivityName(activityName)])
        
        
        //        DeviceActivityCenter().stopMonitoring( [.daily])
        //        DeviceActivityCenter().stopMonitoring(activities);
        //        store.shield.applications = nil
        //        store.shield.applicationCategories = nil
        //        store.shield.webDomains = nil
        //        store.
    }
    
    func createDateFromHourAndMinute(hour: Int, minute: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents)
    }
    
    func startMonitorByActivityName(activityName: String) {
        let timelineItem:TimelineItem? = SharepreferenceManager.shareInstance().getTimelineItem(id: activityName, forKey: SharePreferenceKey.TimelineKey) ?? nil;
        let weekend = timelineItem?.weekend ?? [true,true,false,false,false,false,false]; // [日，一，二，三，四，五，六]
        if(timelineItem != nil) {
            if(isTodayInWeekend(weekend: weekend) && timelineItem?.isOn == true) {
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
    
    func startMonitoring(activityName: String, intervalStart: DateComponents, intervalEnd: DateComponents, applicationTokens: Set<ApplicationToken>, categoryTokens: Set<ActivityCategoryToken>, webDomainTokens: Set<WebDomainToken>) {
        // todo 这个可用 临时去掉
        let startAt = DateComponents(hour: intervalStart.hour ?? 0, minute: intervalStart.minute ?? 0)
        let endAt = DateComponents(hour: intervalEnd.hour ?? 0, minute: intervalEnd.minute ?? 0)
        
//        let startAt = DateComponents(hour: 0, minute: 0)
//        let endAt = DateComponents(hour: 23, minute: 59)
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startAt,
            intervalEnd: endAt,
            repeats: true,
            warningTime: DateComponents(minute: 1)) // 미리 알림 시간
        let events: [DeviceActivityEvent.Name: DeviceActivity.DeviceActivityEvent] = [DeviceActivityEvent.Name(rawValue: activityName): DeviceActivityEvent(applications:self.activitySelection.applicationTokens, categories: self.activitySelection.categoryTokens, webDomains: self.activitySelection.webDomainTokens, threshold: DateComponents(minute: 30))]
        do {
            DeviceActivityCenter().stopMonitoring([DeviceActivityName(activityName)])
            //            DeviceActivityCenter().stopMonitoring([.daily])
        }
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(DeviceActivityName(activityName), during: schedule, events: events)
        }
        catch {
            print ("Could not start monitoring \(error)")
        }
        startMonitor2(for: DeviceActivityName(activityName), intervalStart: intervalStart, intervalEnd: intervalEnd)
        
        //生成starttime
        //        let s = DateComponents(hour: intervalStart.hour ?? 0, intervalStart.minute ?? 0)
        //        let startAt = Calendar.current.date(from:  )!
        //        let endAt = Calendar.current.date(from: DateComponents(hour: intervalStart.hour, intervalStart.minute) )!
        // let s = DateComponents(hour: intervalStart.hour ?? 0, intervalStart.minute ?? 0)
        // let startAt = Calendar.current.date(from:  )!
        //        let startAt = Calendar.current.dateComponents(from: DateComponents(hour: intervalStart.hour, minute: intervalStart.minute) )!
        //        let endAt = Calendar.current.date(from: DateComponents(hour: intervalEnd.hour, minute: intervalEnd.minute) )!
        //              let endAt = Calendar.current.date(from: intervalEnd)!
        //              value = value + 3;
        //let schedule = DeviceActivitySchedule(intervalStart: Calendar.current.dateComponents([.hour, .minute], from: startAt), intervalEnd: Calendar.current.dateComponents([.hour, .minute], from: endAt), repeats: true, warningTime: DateComponents(minute: 1)) // 提前通知时间
        
        // Schedule restriction 15 minutes after started
        //       let now = Date()
        //  let fiveMinutesStart = Calendar.current.date(byAdding: .minute, value:2, to: now)
        
        //      let fiveMinutesLater = Calendar.current.date(byAdding: .minute, value:17, to: now)
        //        let startAt = createDateFromHourAndMinute(hour: intervalStart.hour ?? 0, minute: intervalStart.minute ?? 0)
        //        let endAt = createDateFromHourAndMinute(hour: intervalEnd.hour ?? 0, minute: intervalEnd.minute ?? 0)
        //let s = Calendar.current.dateComponents([.hour, .minute], from: startAt)
        //        let schedule = DeviceActivitySchedule(intervalStart: startAt, intervalEnd: endAt, repeats: true, warningTime: DateComponents(minute: 1))
        //let schedule = DeviceActivitySchedule(intervalStart: Calendar.current.dateComponents([.hour, .minute], from: startAt), intervalEnd: Calendar.current.dateComponents([.hour, .minute], from: endAt), repeats: true, warningTime: DateComponents(minute: 1)) // 提前通知时间
        //        let schedule = DeviceActivitySchedule(intervalStart: Calendar.current.dateComponents([.hour, .minute, .weekday], from: fiveMinutesStart ?? now),
        //  intervalEnd: Calendar.current.dateComponents([.hour, .minute, .weekday], from: fiveMinutesLater ?? now),
        //repeats: true,
        //warningTime: DateComponents(minute: 1))
        
        //        let schedule = DeviceActivitySchedule(
        //            intervalStart: DateComponents(hour: intervalStart.hour, minute: intervalStart.minute),
        //            intervalEnd: DateComponents(hour: intervalEnd.hour, minute: intervalEnd.minute),
        //            repeats: true,
        //            warningTime: DateComponents(minute: 1)
        //        )
        
        //        let schedule = DeviceActivitySchedule(
        //            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
        //            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
        //            repeats: true,
        //            warningTime: DateComponents(minute: 1)
        //        )
        //              print("value:\(value2) value:\(value)");
        
        //这事一个数组 可以放多种任务
        
        //
        //              let center = DeviceActivityCenter()
        //              do {
        //                  DeviceActivityCenter().stopMonitoring([DeviceActivityName(activityName)])
        //              }
        
        //              catch {
        //                  print ("Could not start monitoring \(error)")
        //              }
        //              do {
        ////                  try center.startMonitoring(DeviceActivityName(activityName), during: schedule)
        //                  try center.startMonitoring(DeviceActivityName.dailySleep, during: schedule, events: events)
        //                  //            try center.startMonitoring(DeviceActivityName(activityName), during: schedule, events: events)
        //              }
        //              catch {
        //                  print ("Could not start monitoring \(error)")
        //              }
        
        //                    store.shield.applications = applicationTokens.isEmpty ? nil : applicationTokens
        //                    store.shield.applicationCategories = categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens)
        //                let schedule = DeviceActivitySchedule(intervalStart: startAt, intervalEnd: endAt, repeats: true, warningTime:  DateComponents(minute: 2))
        
        
        
        //        store.dateAndTime.requireAutomaticDateAndTime = true
        //        store.account.lockAccounts = true
        //        store.passcode.lockPasscode = true
        //        store.siri.denySiri = true
        //        store.appStore.denyInAppPurchases = true
        //        store.appStore.maximumRating = 200
        //        store.appStore.requirePasswordForPurchases = true
        //        store.media.denyExplicitContent = true
        //        store.gameCenter.denyMultiplayerGaming = true
        //        store.media.denyMusicService = false
        
        //lock application
        //            store.shield.applications = applicationTokens.isEmpty ? nil : applicationTokens
        //            store.shield.applicationCategories = categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens)
        //
        //            //more rules
        //            store.media.denyExplicitContent = true
        //
        //            //prevent app removal
        //            store.application.denyAppRemoval = true
        //            print("deny app removal: ",  store.application.denyAppRemoval ?? false)
        //
        //            //prevent set date time
        //            store.dateAndTime.requireAutomaticDateAndTime = true
        
        //
        ////                store.dateAndTime.requireAutomaticDateAndTime = true
        ////                store.dateAndTime.requireAutomaticDateAndTime = true
        ////                store.account.lockAccounts = true
        ////                store.passcode.lockPasscode = true
        ////                store.siri.denySiri = true
        ////                store.appStore.denyInAppPurchases = true
        ////                store.appStore.maximumRating = 200
        ////                store.appStore.requirePasswordForPurchases = true
        ////                store.media.denyExplicitContent = true
        ////                store.gameCenter.denyMultiplayerGaming = true
        ////                store.media.denyMusicService = false
        //        store.shield.applications = self.activitySelection.applicationTokens.isEmpty ? nil : self.activitySelection.applicationTokens
        //        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(self.activitySelection.categoryTokens, except: Set())
        //        store.shield.webDomains = []
        //        //lock application
        //        //        store.shield.applications = applications!.applicationTokens.isEmpty ? nil : applications!.applicationTokens
        //        //        store.shield.applicationCategories = applications!.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications!.categoryTokens)
        //        //
        //                //more rules
        //                store.media.denyExplicitContent = true
        //
        //                //prevent app removal
        //                store.application.denyAppRemoval = true
        //
        //                //prevent set date time
        //                store.dateAndTime.requireAutomaticDateAndTime = true
        //                store.application.blockedApplications = applications!.applications
        
        
    }
    
    
    
    func startMonitor2(for activity: DeviceActivityName,intervalStart: DateComponents, intervalEnd: DateComponents) {
        let timelineItem:TimelineItem? = SharepreferenceManager.shareInstance().getTimelineItem(id: activity.rawValue, forKey: SharePreferenceKey.TimelineKey) ?? nil;
//        let weekend = timelineItem?.weekend ?? [true,true,false,false,false,false,false]; // [日，一，二，三，四，五，六]
        let weekend = [true,true,true,true,true,true,true]; // [日，一，二，三，四，五，六]
        if(timelineItem != nil) {
            if(isTodayInWeekend(weekend: weekend) && timelineItem?.isOn == true) {
                let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
                // if (now >= intervalStart && now <= intervalEnd) || (now >= intervalEnd && now <= intervalStart) {
                //now在intervalStart和intervalEnd之间
                let hourNow = now.hour ?? 0
                let minuteNow = now.minute ?? 0
                let hourStart = intervalStart.hour ?? 0
                let minuteStart = intervalStart.minute ?? 0
                let hourEnd = intervalEnd.hour ?? 0
                let minuteEnd = intervalEnd.minute ?? 0
                
                if (hourNow > hourStart || (hourNow == hourStart && minuteNow >= minuteStart)) && (hourNow < hourEnd || (hourNow == hourEnd && minuteNow <= minuteEnd)) {
                    // now is between intervalStart and intervalEnd
//                    NotificationManager.shared.requestNotificationCreate(
//                        title: "Activity Time",
//                        subtitle: "Your scheduled activity time has started.",
//                        userInfo: ["ACTION" : Params.START_MONITORING, "ACTIVITY_NAME": activity.rawValue]
//                    )
//                    NotificationManager.shared.scheduleDelayedNotification(
//                        title: "Activity Time",
//                        subtitle: "Your scheduled activity time has started.",
//                        userInfo: ["ACTION" : Params.START_MONITORING, "ACTIVITY_NAME": activity.rawValue]
//                    )
                    
                    timelineItem?.isRunning = true
                    store.shield.applications = Set(timelineItem?.applicationTokens ?? [])
                    store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(Set(timelineItem?.activityCategoryTokens ?? []), except: Set())
                    store.shield.webDomains = Set(timelineItem?.webDomainTokens ?? [])
                    store.media.denyExplicitContent = true
                    //prevent app removal
                    store.application.denyAppRemoval = true
                    print("deny app removal: ",  store.application.denyAppRemoval ?? false)
                    
                    //prevent set date time
                    store.dateAndTime.requireAutomaticDateAndTime = true
                }
            }
        }
    }
    @available(iOS 16.0, *)
    func stopAppRestrictions(){
        print("Stop App Restriction")
        store.clearAllSettings()
    }
    
    func saveToStore(apps : Set<Application>){
        store.application.blockedApplications = apps
    }
    
}

@available(iOS 16.0, *)
extension DeviceActivityName {
    static let daily = Self("daily")
}

//
////MARK: Schedule Name List
//extension DeviceActivityName {
//    static let daily = Self("daily")
//}
