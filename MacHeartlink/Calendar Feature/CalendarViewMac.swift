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
    @ObservedObject var eventStore: EventStore
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    
    func makeNSView(context: Context) -> NSView {
        let calendarView = NSView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        let datePicker = NSDatePicker(frame: .zero)
        datePicker.datePickerStyle = .clockAndCalendar
        datePicker.datePickerElements = .yearMonthDay
        datePicker.calendar = gregorianCalendar
        datePicker.minDate = Date.distantPast
        datePicker.maxDate = interval.end
        
        datePicker.dateValue = Date()
        
        calendarView.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: calendarView.centerYAnchor),
        ])
        
        datePicker.target = context.coordinator
        datePicker.action = #selector(context.coordinator.datePickerChanged(_:))
        
        return calendarView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, eventStore: _eventStore)
    }
    
    class Coordinator: NSObject {
        var parent: CalendarViewMac
        @ObservedObject var eventStore: EventStore

        init(parent: CalendarViewMac, eventStore: ObservedObject<EventStore>) {
            self.parent = parent
            self._eventStore = eventStore
        }
        
        @objc func datePickerChanged(_ sender: NSDatePicker) {
            let selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: sender.dateValue)
            parent.dateSelected = selectedDate
            
            let foundEvents = eventStore.events.filter { event in
                event.date.startOfDay == selectedDate.date?.startOfDay
            }
            
            if !foundEvents.isEmpty {
                parent.displayEvents.toggle()
            }
        }
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
    
    private func formattedDate(_ date: Date, with calendar: Calendar) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

