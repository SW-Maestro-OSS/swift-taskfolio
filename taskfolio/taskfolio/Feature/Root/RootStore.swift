//
//  RootStore.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation

import ComposableArchitecture

enum RootScene: Hashable {
    case home
}

struct RootStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [RootScene] = []
        
        var home: HomeStore.State = .init()
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case home(HomeStore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case .home:
                return .none
            }
        }
        
        Scope(state: \.home, action: /Action.home) {
            HomeStore()
        }
    }
}
