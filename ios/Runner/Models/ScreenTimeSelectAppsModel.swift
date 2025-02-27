//
//  ScreenTimeSelectAppsModel.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/22.
//

import Foundation
import FamilyControls

@available(iOS 15.0, *)
class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()

    init() { }
}
