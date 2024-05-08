////
////  FamilyActivityModel.swift
////  Runner
////
////  Created by 林智彬 on 2023/8/23.
////
//
//import Foundation
//import FamilyControls
//import DeviceActivity
//import ManagedSettings
//
//@available(iOS 15.0, *)
//class FamilyActivityModel: ObservableObject {
//    static let shared = FamilyActivityModel()
//    let store = ManagedSettingsStore()
//    var applicationTokens = Array<ApplicationToken>()
//    var categoriesToken = Array<ActivityCategoryToken>()
////    var activitySelection = FamilyActivitySelection()
//    private init() {}
//
//    @Published var activitySelection = FamilyActivitySelection() {
//        willSet {
//            print ("got here \(newValue)")
//            let applications = newValue.applicationTokens
//            let categories = newValue.categoryTokens
//            let webCategories = newValue.webDomainTokens
//            applicationTokens = Array(applications)
//            categoriesToken = Array(categories)
//            store.shield.applications = applications.isEmpty ? nil : applications
//            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
//            store.shield.webDomains = webCategories
//        }
//    }
//
//    func initiateMonitoring() {
//        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59), repeats: true, warningTime: nil)
//
//        let center = DeviceActivityCenter()
//        do {
//            try center.startMonitoring(.daily, during: schedule)
//        }
//        catch {
//            print ("Could not start monitoring \(error)")
//        }
//
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
//    }
//}
//
////@available(iOS 15.0, *)
////extension DeviceActivityName {
////    static let daily = Self("daily")
////}
