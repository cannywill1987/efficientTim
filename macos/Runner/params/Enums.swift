//
//  Enums.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/29.
//

import Foundation

enum EnvEnum:Int {
    case dev = 0 //开发
      case uat = 1 //灰度
      case prd = 2 //生产
}

enum CounterStatusEnum:Int {
    case focusing=0 //专注中 红色计时中
    case pausingFucusing=1 //专注暂停中
    case relaxing=2 //休息中 蓝色计时中
    case waitingToFocus=3 //等待专注中
    case waitingToStartRelaxing=4 //等待休息启动
    case pausingRelaixing=5 //暂停休息中
    case none=6 //没任何选择
}


enum Size:Int {
    case focusing=0 //专注中 红色计时中
    case pausingFucusing=1 //专注暂停中
    case relaxing=2 //休息中 蓝色计时中
    case waitingToFocus=3 //等待专注中
    case waitingToStartRelaxing=4 //等待休息启动
    case pausingRelaixing=5 //暂停休息中
    case none=6 //没任何选择
}
