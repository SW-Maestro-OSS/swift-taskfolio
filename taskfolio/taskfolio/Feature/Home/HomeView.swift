//
//  HomeView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    public let store: StoreOf<HomeStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                VStack(spacing: .zero) {
                    VStack(spacing: 5) {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                viewStore.send(.leftButtonTapped)
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.label))
                            })
                            
                            Button(action: {
                                viewStore.send(.rightButtonTapped)
                            }, label: {
                                Image(systemName: "chevron.forward")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.label))
                            })
                        }
                        .padding(.horizontal)
                        .padding(.horizontal)
                        
                        HStack {
                            ForEach(viewStore.currentWeekDates, id: \.self) { date in
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Text(date.shortWeekdaySymbol)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("\(date.day)")
                                            .font(.caption)
                                            .fontWeight(viewStore.currentDate.isDate(inSameDayAs: date) ? .bold : .light)
                                        
                                        Spacer()
                                    }
                                }
                                .onTapGesture {
                                    viewStore.send(.dateChanged(date))
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    
                    List {
                        ForEachStore(self.store.scope(state: \.taskListCells, action: HomeStore.Action.taskListCell(id:action:))) {
                            TaskCellView(store: $0)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action:{
                        }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Taskfolio")
                .navigationBarItems(
                    trailing: HStack(spacing: 10) {
                        EditButton()
                        
                        Button(action:{
                        }) {
                            Image(systemName: "gearshape")
                                .imageScale(.medium)
                        }
                    }
                )
                .navigationDestination(for: HomeScene.self) { scene in
                    switch scene {
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: .init(), reducer: HomeStore()._printChanges()))
    }
}

