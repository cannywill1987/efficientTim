//
//  NewCounterWidgetLiveActivity.swift
//  NewCounterWidget
//
//  Created by 林智彬 on 2024/11/2.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NewCounterWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NewCounterWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NewCounterWidgetAttributes.self) { context in
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

extension NewCounterWidgetAttributes {
    fileprivate static var preview: NewCounterWidgetAttributes {
        NewCounterWidgetAttributes(name: "World")
    }
}

extension NewCounterWidgetAttributes.ContentState {
    fileprivate static var smiley: NewCounterWidgetAttributes.ContentState {
        NewCounterWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NewCounterWidgetAttributes.ContentState {
         NewCounterWidgetAttributes.ContentState(emoji: "🤩")
     }
}
//
//#Preview("Notification", as: .content, using: NewCounterWidgetAttributes.preview) {
//   NewCounterWidgetLiveActivity()
//} contentStates: {
//    NewCounterWidgetAttributes.ContentState.smiley
//    NewCounterWidgetAttributes.ContentState.starEyes
//}
