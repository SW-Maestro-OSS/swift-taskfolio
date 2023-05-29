//
//  EditTaskStore.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/29.
//

import Foundation

import ComposableArchitecture

struct EditTaskStore: ReducerProtocol {
    struct State: Equatable {
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
