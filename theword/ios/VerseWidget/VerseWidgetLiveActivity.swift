//
//  VerseWidgetLiveActivity.swift
//  VerseWidget
//
//  Created by Joseph on 5/6/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct VerseWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct VerseWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: VerseWidgetAttributes.self) { context in
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

extension VerseWidgetAttributes {
    fileprivate static var preview: VerseWidgetAttributes {
        VerseWidgetAttributes(name: "World")
    }
}

extension VerseWidgetAttributes.ContentState {
    fileprivate static var smiley: VerseWidgetAttributes.ContentState {
        VerseWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: VerseWidgetAttributes.ContentState {
         VerseWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: VerseWidgetAttributes.preview) {
   VerseWidgetLiveActivity()
} contentStates: {
    VerseWidgetAttributes.ContentState.smiley
    VerseWidgetAttributes.ContentState.starEyes
}
