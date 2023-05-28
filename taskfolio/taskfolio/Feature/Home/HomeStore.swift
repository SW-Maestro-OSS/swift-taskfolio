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
        case filterTaskListCellsRquest
        case filterTaskListCellsResponse(IdentifiedArrayOf<TaskCellStore.State>)
        
        case taskListCell(id: TaskCellStore.State.ID, action: TaskCellStore.Action)
    }
    
    @Dependency(\.taskClient) var taskClient
    private enum TaskTimerStopID {}
    
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
                return .send(.filterTaskListCellsRquest)
                
            case .refresh:
                return .send(.fetchResponse(taskClient.fetch()))
                
            case let .fetchResponse(tasks):
                state.taskListCells = []
                tasks.forEach({ task in
                    state.taskListCells.append(.init(id: UUID(), task: task))
                })
                return .send(.filterTaskListCellsRquest)
                
            case .filterTaskListCellsRquest:
                let originCells = state.taskListCells
                let filterDate = state.currentDate
                
                return .send(.filterTaskListCellsResponse(
                    originCells.filter({
                        $0.task.date?.isDate(inSameDayAs: filterDate) == true
                    })))
                
            case let .filterTaskListCellsResponse(filterTaskListCells):
                state.filteredTaskListCells = filterTaskListCells
                return .none
                
            case let .taskListCell(id, action):
                switch action {
                case .toggleTimerButtonTapped:
                    var newFilteredTaskListCell: IdentifiedArrayOf<TaskCellStore.State> = []
                    state.filteredTaskListCells.forEach({ state in
                        let isTimerActive = (id == state.id)
                        newFilteredTaskListCell.append(.init(id: state.id, task: state.task, isTimerActive: isTimerActive))
                    })
                    return .send(.filterTaskListCellsResponse(newFilteredTaskListCell))
                        .cancellable(id: TaskTimerStopID.self, cancelInFlight: true)
                    
                default:
                    return .none
                }
            }
        }
        .forEach(\.filteredTaskListCells, action: /Action.taskListCell(id:action:)) {
            TaskCellStore()
        }
    }
}
