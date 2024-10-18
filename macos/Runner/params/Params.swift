//
//  Params.swift
//  Runner
//
//  Created by 林智彬 on 2022/6/27.
//

import Foundation

class Params {
    static var env = EnvEnum.uat;
    static var isDebug:Bool = env != EnvEnum.prd;
    static let deviceId:String = ""
    static let badgeKey = "badgeKey"

    static let mBaseUrl: String = {
        switch env {
        case .dev:
            return "http://172.20.10.4:9999"
        case .uat, .prd:
            return "https://www.timerbell.com"
        }
    }()
    
    static var ACTION_HANDLE_NOTIFICATION_PERMISSION: String = "ACTION_HANDLE_NOTIFICATION_PERMISSION";
}

struct Apis {
    static let getResourceList = "/api/resource/scene/getList" // 资源位请求
    static let statsModel = "/api/1/classes/StatsModel"
}
