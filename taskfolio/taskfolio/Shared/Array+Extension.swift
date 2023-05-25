//
//  Array+Extension.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
