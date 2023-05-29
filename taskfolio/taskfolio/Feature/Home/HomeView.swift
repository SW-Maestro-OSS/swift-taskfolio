//
//  HomeView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture
import WidgetKit
import ActivityKit

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
                        .padding(.horizontal)
                        
                        HStack {
                            Spacer()
                            
                            Text(TimeManager.shared.toString(second: viewStore.timeSum))
                        }
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    List {
                        ForEachStore(self.store.scope(state: \.filteredTaskListCells, action: HomeStore.Action.taskListCell(id:action:))) {
                            TaskCellView(store: $0)
                        }
                        .onDelete { viewStore.send(.delete($0)) }
                    }
                    .refreshable {
                        viewStore.send(.refresh)
                    }
                    
                    Spacer()
                    
                    HStack {
                        //TODO: User 선택 사항으로 변경
                        /*
                        Button(action: {
                            viewStore.send(.showActivity)
                        }, label: {
                            Image(systemName: "iphone.badge.play")
                                .imageScale(.large)
                                .foregroundColor(Color(.label))
                        })
                        .padding(.horizontal)
                        */
                        
                        Spacer()
                        
                        Button(action: {
                            viewStore.send(.addButtonTapped)
                        }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                                .foregroundColor(Color(.label))
                        }
                        .padding(.horizontal)
                    }
                }
                .task {
                    viewStore.send(.refresh)
                }
                .navigationTitle("Taskfolio")
                .navigationBarItems(
                    trailing: HStack(spacing: 10) {
                        EditButton()
                        
                        Button(action:{
                            viewStore.send(.settingButtonTapped)
                        }) {
                            Image(systemName: "gearshape")
                                .imageScale(.medium)
                        }
                    }
                )
                .navigationDestination(for: HomeScene.self) { scene in
                    switch scene {
                    case .setting:
                        IfLetStore(self.store.scope(state: \.setting, action: { .setting($0) })) {
                            SettingView(store: $0)
                        }
                        
                    default:
                        EmptyView()
                    }
                }
                .sheet(isPresented: viewStore.binding(get: \.isSheetPresented, send: HomeStore.Action.setSheet(isPresented:))) {
                    IfLetStore(self.store.scope(state: \.editTask, action: HomeStore.Action.editTask)) {
                        EditTaskView(store: $0)
                            .presentationDetents([.medium])
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

