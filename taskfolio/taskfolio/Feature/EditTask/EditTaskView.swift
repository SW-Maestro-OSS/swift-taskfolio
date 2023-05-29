//
//  EditTaskView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/29.
//

import SwiftUI

import ComposableArchitecture

struct EditTaskView: View {
    public let store: StoreOf<EditTaskStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Edit Task View")
            }
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(store: .init(initialState: .init(), reducer: EditTaskStore()._printChanges()))
    }
}
