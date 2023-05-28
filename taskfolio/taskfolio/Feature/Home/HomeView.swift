//
//  HomeView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    public let store: StoreOf<HomeStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                ScrollView {
                    VStack(spacing: 5) {
                        ForEachStore(self.store.scope(state: \.taskListCells, action: HomeStore.Action.taskListCell(id:action:))) {
                            TaskCellView(store: $0)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action:{
                        }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Taskfolio")
                .navigationDestination(for: HomeScene.self) { scene in
                    switch scene {
                        
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: .init(), reducer: HomeStore()._printChanges()))
    }
}
