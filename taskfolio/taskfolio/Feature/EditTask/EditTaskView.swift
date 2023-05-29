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
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            ForEach(ColorType.allCases, id: \.rawValue) { colorType in
                                Button {
                                    viewStore.send(.colorChanged(colorType), animation: .default)
                                } label: {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .foregroundColor(colorType.color)
                                        .frame(
                                            width: viewStore.colorType == colorType ?  25 : 18,
                                            height: viewStore.colorType == colorType ? 25 : 18
                                        )
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
                
                TextField(
                  "Untitled Task",
                  text: viewStore.binding(get: \.title, send: EditTaskStore.Action.titleChanged)
                )
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}
