//
//  TaskListCellView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct TaskCellView: View {
    let store: StoreOf<TaskCellStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Divider()
                        .frame(width: 3, height: 15)
                        .overlay(.red)
                    
                    Text(viewStore.task.title ?? "untitled")
                    
                    Spacer()
                    
                    Button(action: {
                        viewStore.send(.toggleTimerButtonTapped)
                    }, label: {
                        Image(systemName: viewStore.isTimerActive ? "pause.circle" : "play.circle")
                            .imageScale(.large)
                            .foregroundColor(Color(.label))
                    })
                }
                
                HStack {
                    Spacer()
                    
                    Text(TimeManager.shared.toString(second: Int(viewStore.task.time)))
                        .font(.caption)
                }
            }
        }
    }
}
