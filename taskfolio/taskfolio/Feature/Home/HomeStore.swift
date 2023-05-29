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
        var isSheetPresented = false
        
        var taskListCells: IdentifiedArrayOf<TaskCellStore.State> = []
        var filteredTaskListCells: IdentifiedArrayOf<TaskCellStore.State> = []
        
        var timerTaskCellID: UUID?
        var isTimerActive: Bool = false
        var timeSum: Int = 0
        
        var editTask: EditTaskStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case addButtonTapped
        case leftButtonTapped
        case rightButtonTapped
        case dateChanged(Date)
        case delete(IndexSet)
        case setSheet(isPresented: Bool)
        
        case timerTicked
        
        case refresh
        case fetchTasksRequest
        case fetchTasksResponse([Task])
        case fetchFilteredTaskListCellsRequest(IdentifiedArrayOf<TaskCellStore.State>, Date)
        case fetchFilteredTaskListCellsResponse(IdentifiedArrayOf<TaskCellStore.State>)
        
        case updateTaskListCells(IdentifiedArrayOf<TaskCellStore.State>)
        case updateFilteredTaskListCells(IdentifiedArrayOf<TaskCellStore.State>)
        
        case taskListCell(id: TaskCellStore.State.ID, action: TaskCellStore.Action)
        case editTask(EditTaskStore.Action)
    }
    
    @Dependency(\.taskClient) var taskClient
    @Dependency(\.continuousClock) var clock
    
    private enum TimerID {}
    
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
                return .send(.fetchFilteredTaskListCellsRequest(state.taskListCells, state.currentDate))
                
            case let .delete(indexSet):
                for index in indexSet {
                    let id = state.taskListCells[index].task.objectID
                    taskClient.delete(id)
                }
                return .send(.refresh)
                
            case .setSheet(isPresented: true):
                state.isSheetPresented = true
                return .none
                
            case .setSheet(isPresented: false):
                state.isSheetPresented = false
                state.editTask = nil
                return .none
                
            case .timerTicked:
                return .send(.updateTaskListCells(.init(uniqueElements: state.taskListCells.map({
                    if $0.id == state.timerTaskCellID {
                        $0.task.time += 1
                        taskClient.save()
                        return .init(id: $0.id, task: $0.task, isTimerActive: $0.isTimerActive)
                    } else {
                        return .init(id: $0.id, task: $0.task, isTimerActive: $0.isTimerActive)
                    }
                }))))
                
            case .refresh:
                return .concatenate([
                    .send(.fetchTasksRequest),
                    .cancel(id: TimerID.self)
                ])
                
            case .fetchTasksRequest:
                return .send(.fetchTasksResponse(taskClient.fetch()))
                
            case let .fetchTasksResponse(tasks):
                return .send(.updateTaskListCells(.init(
                    uniqueElements: tasks.map({
                        return .init(id: .init(), task: $0)
                    })
                )))
                
            case let .fetchFilteredTaskListCellsRequest(taskListCells, date):
                return .send(.fetchFilteredTaskListCellsResponse(taskListCells.filter({ $0.task.date?.isDate(inSameDayAs: date) == true })))
                
            case let .fetchFilteredTaskListCellsResponse(filteredTaskListCells):
                return .send(.updateFilteredTaskListCells(filteredTaskListCells))
                
            case let .updateTaskListCells(taskListCells):
                state.taskListCells = taskListCells
                return .send(.fetchFilteredTaskListCellsRequest(taskListCells, state.currentDate))
                
            case let .updateFilteredTaskListCells(filteredTaskListCells):
                state.timeSum = filteredTaskListCells.map({ Int($0.task.time) }).reduce(0, +)
                state.filteredTaskListCells = filteredTaskListCells
                return .none
                
            case let .taskListCell(id, action):
                switch action {
                case .tapped:
                    state.editTask = .init()
                    return .send(.setSheet(isPresented: true))
                    
                case .toggleTimerButtonTapped:
                    state.timerTaskCellID = nil
                    state.isTimerActive = false
                    return .concatenate([
                        .send(.updateTaskListCells(.init(uniqueElements: state.taskListCells.map({
                            let isTimerActive = $0.isTimerActive ? false : (id == $0.id)
                            state.timerTaskCellID = isTimerActive ? id : state.timerTaskCellID
                            state.isTimerActive = isTimerActive ? true : state.isTimerActive
                            return .init(id: $0.id, task: $0.task, isTimerActive: isTimerActive)
                        })))),
                        .run { [isTimerActive = state.isTimerActive] send in
                            guard isTimerActive else { return }
                            for await _ in self.clock.timer(interval: .seconds(1)) {
                                await send(.timerTicked)
                            }
                        }
                            .cancellable(id: TimerID.self, cancelInFlight: true)
                    ])
                }
            case .editTask:
                return .none
            }
        }
        .forEach(\.filteredTaskListCells, action: /Action.taskListCell(id:action:)) {
            TaskCellStore()
        }
    }
}
