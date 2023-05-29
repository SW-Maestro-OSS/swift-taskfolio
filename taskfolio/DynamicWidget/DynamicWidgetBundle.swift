//
//  DynamicWidgetBundle.swift
//  DynamicWidget
//
//  Created by 송영모 on 2023/05/29.
//

import WidgetKit
import SwiftUI

@main
struct DynamicWidgetBundle: WidgetBundle {
    var body: some Widget {
        DynamicWidget()
        DynamicWidgetLiveActivity()
    }
}
