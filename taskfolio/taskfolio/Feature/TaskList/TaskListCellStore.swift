//
//  TaskListCellStore.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct TaskListCellView: View {
    let store: StoreOf<TaskListCellStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
//                Text(viewStore.plot.title ?? "")
//                    .font(.headline)
//                    .fontWeight(.medium)
//
//                Text(viewStore.plot.content ?? "")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewStore.send(.tapped)
            }
        }
    }
}
