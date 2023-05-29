//
//  RootView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct RootView: View {
    public let store: StoreOf<RootStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HomeView(store: self.store.scope(state: \.home, action: RootStore.Action.home))
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: .init(initialState: .init(), reducer: RootStore()._printChanges()))
    }
}
