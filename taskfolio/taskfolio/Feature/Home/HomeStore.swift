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
        
        var currentWeekDates: [Date] = Date().weekDates()
        var currentDate: Date = Date()
        
        var taskListCells: IdentifiedArrayOf<TaskCellStore.State> = []
        var filteredTaskListCells: IdentifiedArrayOf<TaskCellStore.State> = []
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case addButtonTapped
        case leftButtonTapped
        case rightButtonTapped
        case dateChanged(Date)
        
        case refresh
        case fetchResponse([Task])
        case filterTaskListCells
        
        case taskListCell(id: TaskCellStore.State.ID, action: TaskCellStore.Action)
    }
    
    @Dependency(\.taskClient) var taskClient
    private enum TodoCompletionID {}
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case .addButtonTapped:
                let newTask = taskClient.newTask()
                newTask.title = "untitled"
                newTask.date = state.currentDate
                newTask.colorType = Int16(ColorType.blue.rawValue)
                newTask.time = 0
                newTask.order = Int16(state.filteredTaskListCells.count)
                taskClient.save()
                return .send(.refresh)
                
            case .leftButtonTapped:
                return .send(.dateChanged(state.currentDate.add(byAdding: .day, value: -7)))
                
            case .rightButtonTapped:
                return .send(.dateChanged(state.currentDate.add(byAdding: .day, value: 7)))
                
            case let .dateChanged(date):
                state.currentDate = date
                state.currentWeekDates = date.weekDates()
                return .send(.filterTaskListCells)
                
            case .refresh:
                return .send(.fetchResponse(taskClient.fetch()))
                
            case let .fetchResponse(tasks):
                state.taskListCells = []
                tasks.forEach({ task in
                    state.taskListCells.append(.init(id: .init(), task: task))
                })
                return .send(.filterTaskListCells)
                
            case .filterTaskListCells:
                let originCells = state.taskListCells
                let filterDate = state.currentDate
                
                state.filteredTaskListCells = originCells.filter({
                    $0.task.date?.isDate(inSameDayAs: filterDate) == true
                })
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
