//
//  NewMissionListViewExtensionBundle.swift
//  NewMissionListViewExtension
//
//  Created by 林智彬 on 2024/11/2.
//

import WidgetKit
import SwiftUI

@main
struct NewMissionListViewExtensionBundle: WidgetBundle {
    var body: some Widget {
        NewMissionListViewExtension()
        NewMissionListViewExtensionLiveActivity()
    }
}
