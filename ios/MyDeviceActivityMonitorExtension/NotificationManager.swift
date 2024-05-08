//
//  NotificationManager.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/08.
//

import Foundation
import SwiftUI
import UserNotifications

@available(iOS 14.0, *)
class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    // MARK: Check user notification settings
    @AppStorage(AppStorageKey.hasNotificationPermission.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var hasNotificationPermission: Int = -1 {
        didSet {
            updateHasNotificationPermission()
        }
    }
    
    @Published
    var sharedHasNotificationPermission = -1
    
    func updateHasNotificationPermission() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.sharedHasNotificationPermission = self.hasNotificationPermission
            }
        }
    }
    
    // MARK: Request for notification permission
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {(success, error) in
            if let error = error {
                print("ERROR: \(error)")
                self.hasNotificationPermission = 0
            } else {
                print(success)
                if success {
                    self.hasNotificationPermission = 1
                } else {
                    self.hasNotificationPermission = 0
                }
            }
        }
    }

    // MARK: Check notification permissions
    func updateAuthStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.hasNotificationPermission = -1
            case .denied:
                self.hasNotificationPermission = 0
            case .authorized:
                self.hasNotificationPermission = 1
            case .provisional:
                print("provisional")
            case .ephemeral:
                print("ephemeral")
            @unknown default:
                print("No set permission status")
            }
        }
    }
    
    // TODO: 需要讨论通知请求方式，目前是基于时间编写的
    // MARK: 创建并请求通知
    func requestNotificationCreate(
        title: String = "Sample Notification Title",
        subtitle: String = "Sample Notification SubTitle",
        timeInterval: Double = 5.0
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        // TODO: Modify to make the badge function properly
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}
