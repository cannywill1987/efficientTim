//
//  IslandBundle.swift
//  Island
//
//  Created by 林智彬 on 2023/4/12.
//

import WidgetKit
import SwiftUI

@main
struct IslandBundle: WidgetBundle {
    var body: some Widget {
//        Island()
        if #available(iOS 16.1, *) {
            IslandLiveActivity()
        }
    }
}
