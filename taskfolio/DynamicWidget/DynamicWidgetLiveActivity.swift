//
//  DynamicWidgetLiveActivity.swift
//  DynamicWidget
//
//  Created by 송영모 on 2023/05/29.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var title: String?
        var time: Int?
    }
    
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DynamicWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Text(context.state.title ?? "")
                    .font(.title2)
                
                Spacer()
                
                VStack {
                    Image(systemName: "play.circle")
                        .font(.title2)
                    
                    Text(TimeManager.shared.toString(second: context.state.time ?? 0))
                        .font(.caption)
                }
            }
            .padding()
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)
            
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
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                VStack(alignment: .center) {
                    Image(systemName: "timer")
                    //                    Text("ㅇㅇ")
                    //                        .multilineTextAlignment(.center)
                    //                        .monospacedDigit()
                    //                        .font(.caption2)
                }
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct DynamicWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = DynamicWidgetAttributes(name: "Me")
    static let contentState = DynamicWidgetAttributes.ContentState(title: "Task", time: 00)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
