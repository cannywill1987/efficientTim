//
//  Params.swift
//  Runner
//
//  Created by 林智彬 on 2022/6/27.
//

import Foundation

class Params {
    static var deviceId: String = "";
    static var APP_GROUP = "group.com.timespeed.timehello";
    static var START_MONITORING = "START_MONITORING";
    static var END_MONITORING = "END_MONITORING";

    static var ACTION_HANDLE_NOTIFICATION_PERMISSION: String = "ACTION_HANDLE_NOTIFICATION_PERMISSION";
//    static let instance:Params = Params()
//    var deviceId: String = "";
//    static func shareInstance() -> Params {
//        return instance;
//    }
//    
//    func setDeviceId(deviceId: String) -> Params {
//        self.deviceId = deviceId
//        return .instance;
//    }
}

class SharePreferenceKey {
    static var TimelineKey: String = "TimelineKey";
}

