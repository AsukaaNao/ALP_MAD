//
//  Event.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import Foundation
import Foundation

struct Event: Identifiable {
    enum EventType: String, Identifiable, CaseIterable {
        case date, appointment, birthday, anniversary, unspecified
        var id: String {
            self.rawValue
        }

        var icon: String {
            switch self {
            case .date:
                return "👩‍❤️‍👨"
            case .appointment:
                return "📆"
            case .birthday:
                return "🎂"
            case .anniversary:
                return "💍"
            case .unspecified:
                return "📌"
            }
        }
    }

    var eventType: EventType
    var date: Date
    var note: String
    var id: String
    
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: date)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }

    init(id: String = UUID().uuidString, eventType: EventType = .unspecified, date: Date, note: String) {
        self.eventType = eventType
        self.date = date
        self.note = note
        self.id = id
    }

    // Data to be used in the preview
    static var sampleEvents: [Event] {
        return [
            Event(eventType: .birthday, date: Date().diff(numDays: 0), note: "Cat's Birthday"),
            Event(eventType: .date, date: Date().diff(numDays: 0), note: "Weekly Video Call"),
            Event(date: Date().diff(numDays: -20), note: "Get gift for Emily"),
            Event(eventType: .anniversary, date: Date().diff(numDays: 7), note: "1 Year Anniversary"),
            Event(eventType: .birthday, date: Date().diff(numDays: 25), note: "Giselle's Birthday"),
            Event(eventType: .appointment, date: Date().diff(numDays: -11), note: "Couple's Therapy"),
            Event(eventType: .date, date: Date().diff(numDays: -6), note: "Movie Night"),
            Event(date: Date().diff(numDays: -4), note: "Plan for winter vacation.")
        ]
    }
    
    func timeString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
}
