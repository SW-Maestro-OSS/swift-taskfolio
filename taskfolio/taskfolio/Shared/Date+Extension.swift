//
//  Date+Extension.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation

extension Date {
    public static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    public static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    public var shortWeekdaySymbol: String {
        return Calendar.current.shortWeekdaySymbols[self.weekday - 1]
    }
    
    public func day(to date: Date) -> Int {
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
        let endDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        
        return numberOfDays.day! + 1
    }
    
    public func isDate(inSameDayAs date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    public func isDate(start date1: Date, end date2: Date) -> Bool {
        return Date.dates(from: min(date1, date2), to: max(date1, date2)).contains(where: { $0.isDate(inSameDayAs: self) })
    }
    
    public func toString(format: String = "yyyy.MM.dd (E)") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    public func weekDates() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1 // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: self)
        var week: [Date] = []
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        return week
    }
    
    public func monthDates() -> [Date] {
        let calendar = Calendar.current
        
        let startOfMonthDate = self.startOfMonth()
        let endOfMonthDate = self.endOfMonth()
        
        let currentMonthDates = self.getDaysOfMonth()
        var prevMonthDates: [Date] = []
        var nextMonthDates: [Date] = []
        var calendarDates: [Date] = []
        
        for i in 1...7 {
            let date = calendar.date(byAdding: .day, value: -i, to: startOfMonthDate)!
            let weekDay = calendar.component(.weekday, from: date)
            
            prevMonthDates.append(date)
            
            if weekDay == 1 {
                break
            }
        }
        
        for i in 1...7 {
            let date = calendar.date(byAdding: .day, value: i, to: endOfMonthDate)!
            let weekDay = calendar.component(.weekday, from: date)
            
            nextMonthDates.append(date)
            
            if weekDay == 7 {
                break
            }
        }
        
        calendarDates.append(contentsOf: prevMonthDates.reversed())
        calendarDates.append(contentsOf: currentMonthDates)
        calendarDates.append(contentsOf: nextMonthDates)
        
        return calendarDates
    }
    
    public func addMonth(value: Int) -> Date {
        let cal = Calendar.current
        let date = cal.date(byAdding: .month, value: value, to: self)!
        
        return date
    }
    
    public func addDay(value: Int) -> Date {
        let cal = Calendar.current
        let date = cal.date(byAdding: .day, value: value, to: self)!
        
        return date
    }
    
    public func add(byAdding component: Calendar.Component, value: Int) -> Date {
        let cal = Calendar.current
        let date = cal.date(byAdding: component, value: value, to: self)!
        
        return date
    }
    
    public static func toString(format: String = "yyyy.MM.dd (E)", date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    func startOfMonth() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        return cal.date(from: comps)!
    }
    
    func endOfMonth() -> Date {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: self)
        let date = cal.date(from: comps)!
        let lastDayOfMonth = cal.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
        return lastDayOfMonth
    }
    
    func getDaysOfMonth() -> [Date] {
        let cal = Calendar.current
        let monthRange = cal.range(of: .day, in: .month, for: self)!
        let comps = cal.dateComponents([.year, .month], from: self)
        var date = cal.date(from: comps)!
        var dates: [Date] = []
        for _ in monthRange {
            dates.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
}
