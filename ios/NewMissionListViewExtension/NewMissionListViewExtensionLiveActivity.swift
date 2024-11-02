//
//  NewMissionListViewExtensionLiveActivity.swift
//  NewMissionListViewExtension
//
//  Created by 林智彬 on 2024/11/2.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NewMissionListViewExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NewMissionListViewExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NewMissionListViewExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NewMissionListViewExtensionAttributes {
    fileprivate static var preview: NewMissionListViewExtensionAttributes {
        NewMissionListViewExtensionAttributes(name: "World")
    }
}

extension NewMissionListViewExtensionAttributes.ContentState {
    fileprivate static var smiley: NewMissionListViewExtensionAttributes.ContentState {
        NewMissionListViewExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NewMissionListViewExtensionAttributes.ContentState {
         NewMissionListViewExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NewMissionListViewExtensionAttributes.preview) {
   NewMissionListViewExtensionLiveActivity()
} contentStates: {
    NewMissionListViewExtensionAttributes.ContentState.smiley
    NewMissionListViewExtensionAttributes.ContentState.starEyes
}
