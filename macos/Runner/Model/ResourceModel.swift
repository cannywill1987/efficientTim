//
//  ResourceModel.swift
//  Runner
//
//  Created by 林智彬 on 2024/10/18.
//

import Foundation

// 顶层结构体
struct ResourceResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: [Location]
    let sysTime: Int64
}


// Location 结构体
struct Location: Codable {
    let id: Int
    let lang: String
    let locationCode: String
    let locationTitle: String
    let locationLinkTxt: String
    let locationLinkUrl: String
    let orderIndex: Int
    let deliveryList: [Delivery]
    
    // 自定义键值对的映射，Swift 变量和 JSON 字段名称不一致时使用
    enum CodingKeys: String, CodingKey {
        case id, lang, locationCode = "location_code", locationTitle = "location_title", locationLinkTxt = "location_link_txt", locationLinkUrl = "location_link_url", orderIndex = "order_index", deliveryList
    }
}

// Delivery 结构体
struct Delivery: Codable {
    let id: Int
    let locationInfoId: Int
    let deliveryName: String
    let orderIndex: Int
    let resourcePictureUrl: String
    let resourceTitle: String
    let resourceContent: String
    let resourceRedirectUrlType: Int
    let resourceRedirectUrl: String
    let resourceIconUrl: String
    let extendParams: String
    
    enum CodingKeys: String, CodingKey {
        case id, locationInfoId = "location_info_id", deliveryName = "delivery_name", orderIndex = "order_index", resourcePictureUrl = "resource_picture_url", resourceTitle = "resource_title", resourceContent = "resource_content", resourceRedirectUrlType = "resource_redirect_url_type", resourceRedirectUrl = "resource_redirect_url", resourceIconUrl = "resource_icon_url", extendParams = "extend_params"
    }
}
