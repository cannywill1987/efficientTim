////
////  PermissionViewModel.swift
////
////  Created by Yun Dongbeom on 2023/05/12.
////
//
//import Foundation
//import SwiftUI
//
//typealias PermissionButtonStatus = (label: String, img: String, color: Color)
//
//@available(iOS 16.0, *)
//class PermissionViewModel: ObservableObject {
//    
//    @Published
//    var notificationButtonInfo = PermissionButtonInfo(
//        headerText: "选项权限",
//        src: "Notifications",
//        permissionName: "通知",
//        footerText: """
//        可以在睡觉时间到达前5分钟收到通知，
//        并且在约定的15分钟结束前5分钟收到通知
//        """
//    )
//    @Published
//    var screenTimeButtonInfo = PermissionButtonInfo(
//        headerText: "必要权限",
//        src: "ScreenTime",
//        permissionName: "屏幕时间",
//        footerText: """
//        在需要睡觉的时间，可以选择可能会干扰睡眠的应用，
//        并在到达睡觉时间时限制其使用
//        """
//    )
//
//    @Published
//    var notificationButtonStatus: PermissionButtonStatus = (label: "设置", img: "checkmark.circle.fill", color: .systemGray2)
//    
//    @Published
//    var screenTimeButtonStatus: PermissionButtonStatus = (label: "设置", img: "checkmark.circle.fill", color: .systemGray2)
//    
//    @Published
//    var hasNotificationPermission = false
//    
//    @Published
//    var hasScreenTimePermission = false
//}
//
//// MARK: Method
//@available(iOS 16.0, *)
//extension PermissionViewModel {
//    func updatePermissionStatus() {
//        updateNotificationPermissionStatus()
//        updateScreenTimePermissionStatus()
//    }
//    
//    func handlePermissionButton(permissionName: String) {
//        if permissionName == "알림" {
//            requestNotificationPermission()
//        } else {
//            requestScreenTimePermission()
//        }
//    }
//    
//    private func updateNotificationPermissionStatus() {
//        
//        if NotificationManager.shared.hasNotificationPermission == 1 {
//            notificationButtonStatus.label = "설정완료"
//            notificationButtonStatus.img = "checkmark.circle.fill"
//            notificationButtonStatus.color = .systemGreen
//            hasNotificationPermission = true
//        } else if NotificationManager.shared.hasNotificationPermission == 0 {
//            notificationButtonStatus.label = "설정변경"
//            notificationButtonStatus.img = "x.circle.fill"
//            notificationButtonStatus.color = .systemRed
//            hasNotificationPermission = false
//        } else {
//            notificationButtonStatus.label = "설정하기"
//            notificationButtonStatus.img = "checkmark.circle.fill"
//            notificationButtonStatus.color = .systemGray2
//            hasNotificationPermission = false
//        }
//    }
//    
//    private func updateScreenTimePermissionStatus() {
//        if ScreenTimeVM.shared.hasScreenTimePermission {
//            screenTimeButtonStatus.label = "설정완료"
//            screenTimeButtonStatus.img = "checkmark.circle.fill"
//            screenTimeButtonStatus.color = .systemGreen
//            hasScreenTimePermission = true
//        } else {
//            screenTimeButtonStatus.label = "설정하기"
//            screenTimeButtonStatus.img = "checkmark.circle.fill"
//            screenTimeButtonStatus.color = .systemGray2
//            hasScreenTimePermission = false
//        }
//    }
//
//    // MARK: Notification 권한 요청
//    private func requestNotificationPermission() {
//        NotificationManager.shared.requestAuthorization()
//    }
//    
//    // MARK: ScreenTime 권한 요청
//    private func requestScreenTimePermission() {
//        ScreenTimeVM.shared.requestAuthorization()
//    }
//}
