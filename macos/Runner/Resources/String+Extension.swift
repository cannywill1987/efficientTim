//
//  String.swift
//  sunghoyazaza
//
//  Created by jaesik pyeon on 2023/05/11.
//

import Foundation
extension String {
    /// 调用本地化
    func localizable() -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
}
