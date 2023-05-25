//
//  taskfolioApp.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/24.
//

import SwiftUI

@main
struct taskfolioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
