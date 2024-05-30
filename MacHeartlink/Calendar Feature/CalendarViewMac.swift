//
//  CalendarViewMac.swift
//  MacHeartlink
//
//  Created by Shelfinna on 30/05/24.
//

import SwiftUI
import Cocoa
import AppKit


struct CalendarViewMac: NSViewRepresentable {
    let interval: DateInterval
    
    func makeNSView(context: Context) -> NSView {
        let calendarView = NSView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        let datePicker = NSDatePicker(frame: NSRect(x: 20, y: 20, width: 300, height: 200))
        datePicker.datePickerStyle = .clockAndCalendar
        datePicker.datePickerElements = .yearMonthDay
        datePicker.calendar = gregorianCalendar
        datePicker.minDate = interval.start
        datePicker.maxDate = interval.end
        
        // Add the date picker to the calendar view
        calendarView.addSubview(datePicker)
        calendarView.frame = NSRect(x: 0, y: 0, width: 350, height: datePicker.frame.height + 40) // Adjust the padding as needed

        
        return calendarView
        
    }
    
    
    func updateNSView(_ nsView: NSView, context: Context) {
        
    }
    
    private func formattedDate(_ date: Date, with calendar: Calendar) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}




