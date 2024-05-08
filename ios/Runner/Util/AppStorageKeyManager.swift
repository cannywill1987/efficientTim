//
//  AppStorageKeyManager.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/08.
//

import Foundation

public enum AppStorageKey: String {
    case selectionToDiscourage // FamilyActivitySelection
    case sleepStartDateComponent
    case sleepEndDateComponent
    case daysOfWeek
    case isUserNotificationOn
    case additionalCount
    case isEndPoint
    case isUserInit
    case hasNotificationPermission
    case hasScreenTimePermission
    case testCount
    case additionalMinute // Additional use time for mobile phone
    case warningTime // Advance notice time

}

// MARK: 在实际测试中，请在设置App Groups后，将其修改为相同的名称。
let APP_GROUP_NAME = "group.com.timespeed.timehello"
