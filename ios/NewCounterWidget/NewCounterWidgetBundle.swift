//
//  NewCounterWidgetBundle.swift
//  NewCounterWidget
//
//  Created by 林智彬 on 2024/11/2.
//

import WidgetKit
import SwiftUI

@main
struct NewCounterWidgetBundle: WidgetBundle {
    var body: some Widget {
        NewCounterWidget()
        NewCounterWidgetLiveActivity()
    }
}
