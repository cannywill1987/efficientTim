//
//  UserSettings.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/23.
//

import Foundation

@available(iOS 15.0, *)
class KeySettings: ObservableObject {
    
    @Published var keys: [String] {
        didSet { //地址默认值
            UserDefaults.standard.set(try? PropertyListEncoder().encode(keys), forKey: "keys")
        }
    }
    
    init() {
        if let data = UserDefaults.standard.value(forKey:"keys") as? Data {
            let tokens = try? PropertyListDecoder().decode(Array<String>.self, from: data)
            self.keys = tokens ?? []
        } else {
            self.keys = []
        }
    }
}
