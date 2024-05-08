//
//  ScreenTImeVM.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/08.
//
import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import SwiftUI

// MARK: 用于管理与ScreenTime相关的数据的类
@available(iOS 16.0, *)
class ScreenTimeVM: ObservableObject {
    static let shared = ScreenTimeVM()

    private init() {}

    // MARK: 存储要限制的应用信息的变量
    @AppStorage(AppStorageKey.selectionToDiscourage.rawValue, store: UserDefaults(suiteName: Params.APP_GROUP))
    var selectionToDiscourage = FamilyActivitySelection()
    
    // MARK: 存储要限制的应用信息的变量
    @AppStorage("value")
    var value:Int = 1;
    
    // MARK: 存储要限制的应用信息的变量
    @AppStorage("value")
    var value2:Int = 2;
    
    // MARK: 检查用户是否完成了引导的变量
    @AppStorage(AppStorageKey.isUserInit.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isUserInitStatus: Bool = true

    // MARK: 是否设置了屏幕时间
    @AppStorage(AppStorageKey.hasScreenTimePermission.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var hasScreenTimePermission: Bool = false {
        didSet {
            print("Changed: ", hasScreenTimePermission)
            updateHasScreenTimePermission()
        }
    }

    @Published
    var sharedHasScreenTimePermission = false

    func updateHasScreenTimePermission() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.sharedHasScreenTimePermission = self.hasScreenTimePermission
            }
        }
    }

    // MARK: 存储计划开始时间的变量
    @AppStorage(AppStorageKey.sleepStartDateComponent.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var sleepStartDateComponent = DateComponents(hour: 23, minute: 00)
    
    // MARK: 存储计划结束时间的变量
    @AppStorage(AppStorageKey.sleepEndDateComponent.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var sleepEndDateComponent = DateComponents(hour: 07, minute: 00)
    
    // MARK: 用户通知设置是否开启
    @AppStorage(AppStorageKey.isUserNotificationOn.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isUserNotificationOn: Bool = true

    // MARK: 今天的睡眠计划中15分钟的延长次数
    @AppStorage(AppStorageKey.additionalCount.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalCount: Int = 0
    
    // MARK: 判断计划是否结束的变量
    @AppStorage(AppStorageKey.isEndPoint.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isEndPoint: Bool = true
    
    // MARK: 增加多少分钟
    @AppStorage(AppStorageKey.additionalMinute.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalMinute: Int = 1
    
    // MARK: 提前通知时间（分钟）
    @AppStorage(AppStorageKey.warningTime.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var warningTime: Int = 5
    
    let deviceActivityCenter = DeviceActivityCenter()
    let authorizationCenter = AuthorizationCenter.shared

    //MARK: 将DateComponent时间值转换为00:00格式的字符串的计算属性
    var sleepStartString: String {
        let userStartAt = self.sleepStartDateComponent
        let startAt = Calendar.current.date(from: userStartAt)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        let timeString = dateFormatter.string(from: startAt)
        
        return timeString
    }
    var sleepEndString: String {
        let userEndAt = self.sleepEndDateComponent
        let endAt = Calendar.current.date(from: userEndAt)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        let timeString = dateFormatter.string(from: endAt)
        
        return timeString
    }
    
    // MARK: 请求屏幕时间权限
    @available(iOS 16.0, *)
    func requestAuthorization() {
        if authorizationCenter.authorizationStatus == .approved {
            print("ScreenTime Permission approved")
        } else {
            Task {
                do {
                     try await authorizationCenter.requestAuthorization(for: .individual)
                    hasScreenTimePermission = true
                    // 동의함
                 } catch {
                     //동의 X
                     print("Failed to enroll Aniyah with error: \(error)")
                     hasScreenTimePermission = false
                     // 사용자가 허용안함.
                     // Error Domain=FamilyControls.FamilyControlsError Code=5 "(null)
                 }
            }
        }
    }

    // MARK: onReceive 更新权限状态
    func updateAuthorizationStatus(authStatus: AuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            hasScreenTimePermission = false
        case .denied:
            hasScreenTimePermission = false
        case .approved:
            hasScreenTimePermission = true
        @unknown default:
            fatalError("没有处理请求的权限设置类型")
        }
    }

    // MARK: 注册监控计划
    func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .dailySleep
    ) {
        //MARK: 如果是基本的睡眠计划
        if deviceActivityName == .dailySleep {
            handleDailySleepMonitoring(startTime: startTime, endTime: endTime)

        } else { //MARK: 如果是15分钟的额外时间计划
            handleAdditionalTimeMonitoring(startTime: startTime, endTime: endTime)
        }
    }
    
    // MARK: 如果是基本的睡眠计划(.dailySleep)
    func handleDailySleepMonitoring(
        startTime: DateComponents,
        endTime: DateComponents
    ) {
        let schedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: true,
            warningTime: DateComponents(minute: warningTime) // 提前通知时间
        )
        print("Daily Sleep Schedule: \(startTime.hour!):\(startTime.minute!) ~ \(endTime.hour!):\(endTime.minute!)")
        
        do {
            // 停止所有活动的监控，并只开始dailySleep计划的监控
            deviceActivityCenter.stopMonitoring()
            try deviceActivityCenter.startMonitoring(
                .dailySleep,
                during: schedule
            )
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    // MARK: 如果是使用额外时间后的计划(.additionalTime)
    func handleAdditionalTimeMonitoring(
        startTime: DateComponents,
        endTime: DateComponents
    ) {
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let startHour = currentDateComponents.hour ?? 0
        let startMinute  = currentDateComponents.minute ?? 0
        var endHour = startHour
        // MARK: 改变额外时间结束的时间
        var endMinute = startMinute + additionalMinute // 15분
        if endMinute >= 60 {
            endMinute -= 60
            endHour += 1
        }
        if endHour > 23 {
            endHour = 23
            endMinute = 59
        }
        print("Additional time schedule: \(startHour):\(startMinute) ~ \(endHour):\(endMinute)")
        
        // 创建新的计划（额外时间结束时间 ~ 睡眠结束时间）
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: endHour, minute: endMinute),
            intervalEnd: endTime,
            repeats: false,
            warningTime: DateComponents(minute: warningTime) // 计划开始和结束前5分钟通知
        )
        
        do {
            // 只停止additionalTime计划的监控（因为dailySleep需要一直监控）
            deviceActivityCenter.stopMonitoring([.additionalTime])
            try deviceActivityCenter.startMonitoring(
                .additionalTime,
                during: schedule
            )
        } catch {
            print("Unexpected error: \(error).")
        }
    }
}

//MARK: FamilyActivitySelection Parser
@available(iOS 16.0, *)
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension DateComponents: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(DateComponents.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

//MARK: Schedule Name List
@available(iOS 16.0, *)
extension DeviceActivityName {
    static let dailySleep = Self("dailySleep")
    static let additionalTime = Self("additionalTime")
}

//MARK: ManagedSettingStore Name List
@available(iOS 16.0, *)
extension ManagedSettingsStore.Name {
    // dailySleep과 additional 각각의 스케줄에 대해 서로 다른 ManagedSettingsStore를 사용하여 dailySleep의 모니터링이 중단되지 않도록 함
    static let dailySleep = Self("dailySleep")
    static let additional = Self("additional")
}
