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
        
        var time: Int
        var isTimerActive: Bool = false
        
        init(id: UUID, task: Task, isTimerActive: Bool = false) {
            self.id = id
            self.task = task
            self.time = Int(task.time)
            self.isTimerActive = isTimerActive
        }
    }
    
    enum Action: Equatable {
//        case onDisappear
        case timerTicked
        case toggleTimerButtonTapped
    }
    
    @Dependency(\.taskClient) var taskClient
    @Dependency(\.continuousClock) var clock
    private enum TimerID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
//        case .onDisappear:
//            return .none
//          return .cancel(id: TimerID.self)
            
        case .timerTicked:
            state.task.time += 1
            state.time += 1
            taskClient.save()
            return .none
            
        case .toggleTimerButtonTapped:
            state.isTimerActive.toggle()
            return .run { [isTimerActive = state.isTimerActive] send in
                guard isTimerActive else { return }
                for await _ in self.clock.timer(interval: .seconds(1)) {
                    await send(.timerTicked)
                }
            }
            .cancellable(id: TimerID.self, cancelInFlight: true)
        }
    }
}
