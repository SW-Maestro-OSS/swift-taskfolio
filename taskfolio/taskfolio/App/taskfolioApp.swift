//
//  taskfolioApp.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/24.
//

import SwiftUI

@main
struct taskfolioApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: .init(initialState: .init(), reducer: RootStore()._printChanges()))
        }
    }
}
