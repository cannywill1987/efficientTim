//
//  URLSession.swift
//  Runner
//
//  Created by 林智彬 on 2024/10/18.
//

import Foundation

class URLSessionRequest {
    
    static func updateModel(url: String, params: [String: Any]) async -> BaseResponse? {
//        let url = "https://www.timerbell.com/api/1/classes/StatsModel"
//        let url = Apis.statsModel
        // 模拟的参数，可以根据你的需求填充
        

        if let responseData = await NetworkRequest.shared.startRequestWithPut(pairParameters: params, url: url) {
            do {
                // 将 responseData 转换为 JSON 数据
                let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                
                // 使用 JSONDecoder 将数据解析为 BaseResponse 类型
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // 自动将下划线命名转换为驼峰命名
                let baseResponse = try decoder.decode(BaseResponse.self, from: jsonData)
                
                // 打印解析结果
                if baseResponse.success {
                    print("请求成功，数据为: \(baseResponse)")
                    return baseResponse;
                } else {
                    print("请求失败，错误信息: \(baseResponse.message)")
                    return nil;
                }
            } catch {
                print("JSON 解析失败: \(error)")
                return nil;
            }
        } else {
            print("Failed to get response")
            return nil;
        }
    }
    
    static func insertStatsModel(params: [String: Any]) async -> BaseResponse? {
//        let url = "https://www.timerbell.com/api/1/classes/StatsModel"
        let url = Apis.statsModel
        // 模拟的参数，可以根据你的需求填充
        

        if let responseData = await NetworkRequest.shared.startRequestWithPost(pairParameters: params, url: url) {
            do {
                // 将 responseData 转换为 JSON 数据
                let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                
                // 使用 JSONDecoder 将数据解析为 BaseResponse 类型
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // 自动将下划线命名转换为驼峰命名
                let baseResponse = try decoder.decode(BaseResponse.self, from: jsonData)
                
                // 打印解析结果
                if baseResponse.success {
                    print("请求成功，数据为: \(baseResponse)")
                    return baseResponse;
                } else {
                    print("请求失败，错误信息: \(baseResponse.message)")
                    return nil;
                }
            } catch {
                print("JSON 解析失败: \(error)")
                return nil;
            }
        } else {
            print("Failed to get response")
            return nil;
        }
    }
    
//    static func requestSceneList(scene: String) async -> ResourceResponse? {
//        let url = Apis.getResourceList
//        let parameters: [String: String] = ["scene_code": scene]
//
//        // 使用单例请求数据
//        if let responseData = await NetworkRequest.shared.startRequestWithPost(pairParameters: parameters, url: url) {
//            do {
//                // 将 responseData 转换为 JSON 数据
//                let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
//
//                // 使用 JSONDecoder 将数据解析为 BaseResponse 类型
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase // 自动将下划线命名转换为驼峰命名
//                let baseResponse = try decoder.decode(ResourceResponse.self, from: jsonData)
//
//                // 打印解析结果
//                if baseResponse.success {
//                    print("请求成功，数据为: \(baseResponse)")
//                    return baseResponse;
//                } else {
//                    print("请求失败，错误信息: \(baseResponse.message)")
//                }
//            } catch {
//                print("JSON 解析失败: \(error)")
//            }
//        } else {
//            print("Failed to get response")
//        }
//        return nil;
//    }
}
