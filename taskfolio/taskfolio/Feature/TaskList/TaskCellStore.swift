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
        let task: Task
        
        var title: String = ""
        var isTimerActive: Bool = false
        
        init(id: UUID, task: Task, isTimerActive: Bool = false) {
            self.id = id
            self.task = task
            self.title = task.title ?? ""
            self.isTimerActive = isTimerActive
        }
    }
    
    enum Action: Equatable {
        case textFieldChanged(String)
        case toggleTimerButtonTapped
    }
    
    @Dependency(\.taskClient) var taskClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .textFieldChanged(title):
//            state.task.title = title
//            state.title = title
//            taskClient.save()
            return .none
            
        case .toggleTimerButtonTapped:
            state.isTimerActive.toggle()
            return .none
        }
    }
}
