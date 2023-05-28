//
//  HomeStore.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation

import ComposableArchitecture

enum HomeScene: Hashable {
    case home
    case setting
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        
        var taskListCells: IdentifiedArrayOf<TaskCellStore.State> = [
            .init(id: .init(), task: nil),
            .init(id: .init(), task: nil),
            .init(id: .init(), task: nil)
        ]
        var filteredTaskListCells: IdentifiedArrayOf<TaskCellStore.State> = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case taskListCell(id: TaskCellStore.State.ID, action: TaskCellStore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .taskListCell(id, action):
                return .none
            }
        }
        .forEach(\.taskListCells, action: /Action.taskListCell(id:action:)) {
            TaskCellStore()
        }
    }
}
