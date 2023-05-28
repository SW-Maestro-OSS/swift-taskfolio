//
//  TaskListCellStore.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct TaskCellStore: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: UUID
        let task: Task?
    }
    
    enum Action: Equatable {
        case tapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .tapped:
            return .none
        }
    }
}
