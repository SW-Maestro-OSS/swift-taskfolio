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
        var time: Int
        var isTimerActive: Bool = true
    }
    
    // Fixed non-changing properties about your activity go here!
    var id: UUID
    var title: String
    var colorType: Int16
}

struct DynamicWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Divider()
                    .frame(width: 3, height: 15)
                    .overlay(ColorType.toDomain(int16: context.attributes.colorType).color)
                
                Text(context.attributes.title)
                    .font(.title2)
                
                Spacer()
                
                VStack {
                    Image(systemName: context.state.isTimerActive ? "pause.circle" : "play.circle")
                        .font(.title2)
                    
                    Text(TimeManager.shared.toString(second: context.state.time))
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
                    HStack {
                        Divider()
                            .frame(width: 3, height: 15)
                            .overlay(ColorType.toDomain(int16: context.attributes.colorType).color)
                        
                        Text(context.attributes.title)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(TimeManager.shared.toString(second: context.state.time))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    
                }
            } compactLeading: {
                HStack {
                    Divider()
                        .frame(width: 3, height: 15)
                        .overlay(ColorType.toDomain(int16: context.attributes.colorType).color)
                    
                    Text(context.attributes.title)
                }
            } compactTrailing: {
                Text(TimeManager.shared.toString(second: context.state.time))
                    .font(.caption)
            } minimal: {
                VStack(alignment: .center) {
                    Image(systemName: "timer")
                }
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//struct DynamicWidgetLiveActivity_Previews: PreviewProvider {
//    static let attributes = DynamicWidgetAttributes(name: "Me")
//    static let contentState = DynamicWidgetAttributes.ContentState(title: "Task", time: 00)
//
//    static var previews: some View {
//        attributes
//            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
//            .previewDisplayName("Island Compact")
//        attributes
//            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
//            .previewDisplayName("Island Expanded")
//        attributes
//            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
//            .previewDisplayName("Minimal")
//        attributes
//            .previewContext(contentState, viewKind: .content)
//            .previewDisplayName("Notification")
//    }
//}
