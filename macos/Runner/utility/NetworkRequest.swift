import Foundation

class NetworkRequest {

    // 创建单例
    static let shared = NetworkRequest()
    
    // 将构造方法私有化，防止外部实例化
    private init() {}

    func startRequestWithGet(pairParameters: [String: Any], url: String) async -> [String: Any]? {
        return await startRequest(pairParameters: pairParameters, url: url, method: "GET")
    }
    
    func startRequestWithPost(pairParameters: [String: Any], url: String) async -> [String: Any]? {
        return await startRequest(pairParameters: pairParameters, url: url, method: "POST")
    }
    
    private func startRequest(pairParameters: [String: Any], url: String, method: String) async -> [String: Any]? {
        var resDict: [String: Any]?
        let parameters = NetworkRequest.buildParameters(pairParameters: pairParameters)
        let fullURL = "\(Params.mBaseUrl)\(url)"
        
        if method == "POST" {
            let postParameters = parameters.dropFirst() // Remove the starting "?"
            guard let postData = postParameters.data(using: .utf8) else { return nil }
            
            if Params.isDebug {
                print("url is \n\(fullURL)\n\n params is\n \(postParameters)")
            }
            
            var request = URLRequest(url: URL(string: fullURL)!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 60)
            request.httpMethod = "POST"
            request.httpBody = postData
            request.setValue(String(postData.count), forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                resDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                if Params.isDebug {
                    let responseString = String(data: data, encoding: .utf8)
                    print("RequestResult is \(responseString ?? "")")
                }
            } catch {
                return nil
            }
        } else if method == "GET" {
            let getURL = "\(fullURL)\(parameters)"
            
            if Params.isDebug {
                print("url is \(getURL)")
            }
            
            let request = URLRequest(url: URL(string: getURL)!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 60)
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                resDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                if Params.isDebug {
                    let responseString = String(data: data, encoding: .utf8)
                    print("RequestResult is \(responseString ?? "")")
                }
            } catch {
                return nil
            }
        }
        return resDict
    }
    
    // 修改后的 buildParameters 方法，支持多种类型参数
    static func buildParameters(pairParameters: [String: Any]) -> String {
        var modifiedParameters = pairParameters
        modifiedParameters["MangaVersion"] = DeviceUtil.getVersion()
        modifiedParameters["OperationSystem"] = "IOS"
        
        var parameterString = "?"
        for (key, value) in modifiedParameters {
            let encodedValue: String
            if let stringValue = value as? String {
                encodedValue = stringValue
                    .replacingOccurrences(of: "+", with: "%2B")
                    .replacingOccurrences(of: "=", with: "%3D")
            } else if let intValue = value as? Int {
                encodedValue = "\(intValue)"
            } else if let doubleValue = value as? Double {
                encodedValue = "\(doubleValue)"
            } else if let boolValue = value as? Bool {
                encodedValue = boolValue ? "true" : "false"
            } else {
                encodedValue = "\(value)"
            }
            parameterString += "\(key)=\(encodedValue)&"
        }
        return parameterString
    }
}

class DeviceUtil {
    static func getVersion() -> String {
        return "1.0.0" // Example version, replace with actual implementation
    }
}

extension URLSession {
    static var shared: URLSession {
        return URLSession(configuration: .default)
    }
}
