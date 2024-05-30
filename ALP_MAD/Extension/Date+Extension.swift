//
//  Date+Extension.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import Foundation

extension Date {
    func diff(numDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }
    
    var startOfDay: Date {
            return Calendar.current.startOfDay(for: self)
        }
    
    func changeDay(to day: Int) -> Date {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
            dateComponents.day = day
            return calendar.date(from: dateComponents) ?? self
        }
}
