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
        var task: Task
        
        var title: String
        var colorType: ColorType
        
        init(task: Task) {
            self.task = task
            self.title = task.title ?? ""
            self.colorType = ColorType.toDomain(int16: task.colorType)
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case colorChanged(ColorType)
        case titleChanged(String)
    }
    
    @Dependency(\.taskClient) var taskClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .colorChanged(colorType):
                state.task.colorType = Int16(colorType.rawValue)
                state.colorType = colorType
                taskClient.save()
                return .none
                
            case let .titleChanged(title):
                state.task.title = title
                state.title = title
                taskClient.save()
                return .none
            }
        }
    }
}
