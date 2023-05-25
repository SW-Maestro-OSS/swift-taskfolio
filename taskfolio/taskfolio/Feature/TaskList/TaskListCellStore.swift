//
//  TaskListCellStore.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct TaskListCellView: View {
    let store: StoreOf<PlotListCellStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text(viewStore.plot.title ?? "")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(viewStore.plot.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack(spacing: 3) {
                    let stars = HStack(spacing: 0) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                        .frame(width: 60)
                    
                    stars.overlay(
                        GeometryReader { g in
                            let width = viewStore.state.plot.point / CGFloat(5) * g.size.width
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: width)
                                    .foregroundColor(.yellow)
                            }
                        }
                            .mask(stars)
                    )
                    .foregroundColor(.gray)
                    
                    Text("\(viewStore.state.plot.point, specifier: "%.1f")")
                        .offset(.init(width: 0, height: 0.5))
                        .foregroundColor(.gray)
                        .font(.caption2)
                    
                    Spacer()
                    
                    Text(viewStore.plot.date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                        .fontWeight(.light)
                        .font(.caption2)
                    
                    Text(PlotType.toDomain(int16: viewStore.plot.type).rawValue)
                        .font(.caption2)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewStore.send(.tapped)
            }
        }
    }
}
