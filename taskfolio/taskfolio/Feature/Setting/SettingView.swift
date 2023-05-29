//
//  SettingView.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import SwiftUI

import ComposableArchitecture

struct SettingView: View {
    public let store: StoreOf<SettingStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: .zero) {
                Form {
                    Text("iCloud를 허용 해주시면. iPad, WatchOS(지원예정), MacOS(지원 예정) 에서 사용가능 합니다.")
                    
                    Section {
                        DisclosureGroup("TMI") {
                            Text("다이나믹 아일랜드를 사용한 타이머가 필요하다고 생각했습니다. 하지만 너무 복잡할 필요는 없어요. 걱정마세요. 이 이상으로 복잡해지지 않습니다.")
                                .font(.subheadline)
                        }
                        
                        DisclosureGroup("Update Note") {
                            Text("다음 업데이트 예정 사항입니다.")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: .init(initialState: .init(), reducer: SettingStore()._printChanges()))
    }
}
