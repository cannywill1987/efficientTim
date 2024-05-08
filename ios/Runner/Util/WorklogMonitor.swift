////
////  WorklogMonitor.swift
////  Runner
////
////  Created by 林智彬 on 2023/8/8.
////
//
//import Foundation
//
//import DeviceActivity
//import ManagedSettings
////import FamilyControls
//
////https://www.youtube.com/watch?v=is57KWv1XH0
//@available(iOS 16.0, *)
//extension ManagedSettingsStore.Name {
//    static let gaming = Self("gaming");
//    static let social = Self("social");
//}
//
//
////1/例：「SNS」力 計30分費 乙 の定義
//@available(iOS 15.0, *)
//let snsEvent = DeviceActivityEvent (
//    categories: [],
//    threshold: DateComponents (minute: 30)
//)
//
//class WorklogMonitor {
//    let decoder: Decoder;
//    
//    public init(
//        decoder: Decoder? = nil
//    ) {
//        self.decoder = decoder!
//    }
//    
//    @available(iOS 16.0, *)
//    static func limitUsageOfApp() {
//        //5点到6点才允许社交app使用
//        try? DeviceActivityCenter().startMonitoring(.activity, during: DeviceActivity.DeviceActivitySchedule(intervalStart: DateComponents(hour:17), intervalEnd: DateComponents(hour: 20), repeats: true));
//    }
//    
//    
//    @available(iOS 16.0, *)
//    static func requestAuthorization() async {
//        let center = AuthorizationCenter.shared
//        do {
//            try await center.requestAuthorization(for: .child)
//        } catch {}
//    }
//    
//    
//    
//    @available(iOS 15.0, *)
//    func worklogGamingSetup() {
//        do {
//            let gamingCategory = try ActivityCategoryToken(from: self.decoder)
//            if #available(iOS 16.0, *) {
//                let gameStore = ManagedSettingsStore(named: .gaming)
//                gameStore.shield.webDomainCategories = .specific([gamingCategory], except:  [])
//            } else {
//                // Fallback on earlier versions
//            }
//        } catch{}
//    }
//    
//    func worklogSocialSetup(decoder: Decoder) {
//        if #available(iOS 15.0, *) {
//            do {
//                let socialCategory = try ActivityCategoryToken(from: decoder)
//                if #available(iOS 16.0, *) {
//                    let socialStore = ManagedSettingsStore(named: .social)
//                    socialStore.shield.webDomainCategories = .specific([socialCategory], except:  [])
//                    let gameStore = ManagedSettingsStore(named: .gaming)
//                } else {
//                    // Fallback on earlier versions
//                }
//                
//            } catch {}
//        } else {
//            // Fallback on earlier versions
//        };
//    }
//    
//    
//    //限制app的使用时长
//    @available(iOS 15.0, *)
//    class WorklogMonitor: DeviceActivityMonitor {
//        let decoder: Decoder;
//        
//        public init(
//            decoder: Decoder? = nil
//        ) {
//            self.decoder = decoder!
//        }
////        let database = BarkDatabase ()
//        //时间开始时 清空所有社交数据
//        override func intervalDidStart (for activity: DeviceActivityName) {
//            super.intervalDidStart (for: activity)
//            if #available(iOS 16.0, *) {
//                //关闭所有设置和通知
//                let socialStore = ManagedSettingsStore(named: .social)
//                socialStore.clearAllSettings ()
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//        //得到时间时 允许打开所有社交数据
//        @available(iOS 15.0, *)
//        override func intervalDidEnd(for activity: DeviceActivityName) {
//            super.intervalDidEnd (for: activity)
//            if #available(iOS 16.0, *) {
//                do {
//                    let socialStore = ManagedSettingsStore(named: .social)
//                    ActivityCategory(token: try Token(from: decoder))
//                    let socialCategory = try ActivityCategoryToken(from: decoder);
//                    socialStore.shield.applicationCategories = .specific([socialCategory])
//                    socialStore.shield.webDomainCategories = .specific( [socialCategory])
//                } catch {}
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
//    
//    
//    @available(iOS 15.0, *)
//    public struct DeviceActivityEvent {
//        public var applications: Set<ApplicationToken>
//        public var categories: Set<ActivityCategoryToken>
//        public var webDomains: Set<WebDomainToken>
//        public var threshold: DateComponents
//        
//        public init (
//            applications: Set<ApplicationToken> = [],
//            categories: Set<ActivityCategoryToken> = [],
//            webDomains: Set<WebDomainToken> = [],
//            threshold: DateComponents
//        ) {
//            self.applications = applications
//            self.categories = categories
//            self.webDomains = webDomains
//            self.threshold = threshold
//        }
//    }
//    
//    
//    
//    public struct DeviceActivitySchedule {
//        public var intervalStart: DateComponents
//        public var intervalEnd: DateComponents
//        public var repeats: Bool
//        public var warningTime: DateComponents?
//        
//        public init(
//            intervalStart: DateComponents, intervalEnd: DateComponents, repeats: Bool,
//            warningTime: DateComponents? = nil
//        ) {
//            self.intervalStart = intervalStart
//            self.intervalEnd = intervalEnd
//            self.repeats = repeats
//            self.warningTime = warningTime
//        }
//    }
//    
//    //1/例：每日の夜10時～朝5時 時間带の定義
//    let night = DeviceActivitySchedule(
//        intervalStart: DateComponents(hour: 22, minute: 0), intervalEnd: DateComponents (hour: 5, minute: 0), repeats: true, warningTime: nil
//    )
//    
//    //对象在定义
//    let allDays = DeviceActivitySchedule (
//        intervalStart: DateComponents (hour: 0, minute: 0),
//        intervalEnd: DateComponents(hour: 23, minute: 59),
//        repeats: true
//    )
//    
//    //    @available(iOS 15.0, *)
//    //    let events: [DeviceActivity.DeviceActivityEvent.Name: DeviceActivityEvent] = [
//    //        DeviceActivity.DeviceActivityEvent.encouraged: DeviceActivityEvent (
//    //            applications:[],
//    //            //奖励15分钟休息
//    //            threshold: DateComponents (minute: 15)
//    //        )]
//    
//    //开始监视
//    //    @available(iOS 15.0, *)
//    //    let center = DeviceActivityCenter()
//    //    try? center.startMonitoring(.gaming, during: allDays, events: events)
//    
//    @available(iOS 15.0, *)
//    class MyMonitorExtension: DeviceActivityMonitor {
//        override func intervalDidStart(for activity: DeviceActivityName) {
//            super.intervalDidStart(for: activity)
//        }
//        override func intervalDidEnd(for activity: DeviceActivityName) {
//            super.intervalDidEnd(for: activity)
//        }
//        override func eventDidReachThreshold(_ event: DeviceActivity.DeviceActivityEvent.Name, activity: DeviceActivityName) {
//            super.eventDidReachThreshold(event, activity: activity)
//            //                        if event == DeviceActivity.DeviceActivityEvent.Name.encouraged {
//            //                            //1/推獎 卜（例：学習系 在30分使 ） 在達成 、 の の利用制限态解除寸石
//            //                            store.shield.applications = nil
//            //                        }
//        }
//    }
//    
//    //    @available(iOS 15.0, *)
//    //    class MyMonitorExtension: DeviceActivityMonitor {
//    //        let store = ManagedSettingsStore()
//    //        override func eventDidReachThreshold(_ event: DeviceActivity.DeviceActivityEvent.Name, activity: DeviceActivityName) {
//    //            super.eventDidReachThreshold(event, activity: activity)
//    ////            if event == DeviceActivity.DeviceActivityEvent.Name.encouraged {
//    ////                //1/推獎 卜（例：学習系 在30分使 ） 在達成 、 の の利用制限态解除寸石
//    ////                store.shield.applications = nil
//    ////            }
//    //        }
//    //    }
//}
