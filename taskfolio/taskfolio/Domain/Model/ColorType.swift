//
//  ColorType.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation
import SwiftUI

enum ColorType: Int, CaseIterable {
    case black
    case blue
    case brown
    case cyan
    case gray
    case green
    case indigo
    case mint
    case orange
    case pink
    case purple
    case red
    case teal
    case white
    case yellow
    
    var color: Color {
        switch self {
        case .black: return .black
        case .blue: return .blue
        case .brown: return .brown
        case .cyan: return .cyan
        case .gray: return .gray
        case .green: return .green
        case .indigo: return .indigo
        case .mint: return .mint
        case .orange: return .orange
        case .pink: return .pink
        case .purple: return .purple
        case .red: return .red
        case .teal: return .teal
        case .white: return .white
        case .yellow: return .yellow
        }
    }
    
    static func toDomain(int16: Int16) -> ColorType {
        return ColorType.allCases[safe: Int(int16)] ?? .mint
    }
}
