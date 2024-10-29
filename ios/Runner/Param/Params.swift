//
//  Params.swift
//  Runner
//
//  Created by 林智彬 on 2022/6/27.
//

import Foundation


enum EnvEnum:Int {
    case dev = 0 //开发
    case uat = 1 //灰度
    case prd = 2 //生产
}
enum OSEnum:Int {
    case macOS = 0 //开发
    case iosOS = 1 //灰度
}



class Params {
    static var env = EnvEnum.prd;
    static var curOS = OSEnum.macOS;
    static var isDebug:Bool = env != EnvEnum.prd;
    static var isMACOS:Bool = curOS == OSEnum.macOS;
    
    
    static let deviceId:String = ""
    static let badgeKey = "badgeKey"
    
    static let mBaseUrl: String = {
        switch env {
        case .dev:
            return "http://127.0.0.1:9999"
        case .uat, .prd:
            return "https://www.timerbell.com"
        }
    }()
    
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


struct Apis {
    static let console = "/api/console"
    static let getResourceList = "/api/resource/scene/getList" // 资源位请求
    static let statsModel = "/api/1/classes/StatsModel"
    static let missionModel = "/api/1/classes/MissionModel"
    static let updateMissionModelOfFinished = "/api/timehello/updateMissionModelOfFinished" // 任务完成设置
    static let updateFlomoClickInsMissionModel = "/api/timehello/updateFlomoClickInsMissionModel" // 打卡完成设置
}
