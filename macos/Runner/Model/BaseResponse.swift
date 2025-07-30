//
//  BaseResponse.swift
//  Runner
//
//  Created by 林智彬 on 2024/10/18.
//

import Foundation
//<T?: Codable>
struct BaseResponse: Codable {
    let success: Bool
    let code: String
    let message: String
//    let data: T?
    
    let sysTime: Int64
}
