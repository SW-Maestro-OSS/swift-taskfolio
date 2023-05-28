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
                    
                    Text("title1")
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                    })
                }
                
                HStack {
                    Spacer()
                    
                    Text("1:40:57")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .contentShape(Rectangle())
            .onTapGesture {
                viewStore.send(.tapped)
            }
        }
    }
}
