//
//  TimeManager.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/28.
//

import Foundation

class TimeManager {
    static let shared = TimeManager()
    
    func toString(second: Int) -> String {
        let h = String(format: "%02d", second / 3600)
        let m = String(format: "%02d", (second % 3600) / 60)
        let s = String(format: "%02d", (second % 3600) % 60)
        
        return "\(h):\(m):\(s)"
    }
}
