//
//  EventsCalendarViewMac.swift
//  MacHeartlink
//
//  Created by Shelfinna on 30/05/24.
//

import SwiftUI


struct EventsCalendarViewMac: View {
    var body: some View {
        CalendarViewMac(interval: DateInterval(start: Date(), end: Calendar.current.date(byAdding: .year, value: 1, to: Date())!))
                   .frame(width: 350)
        }
}

#Preview {
    EventsCalendarViewMac()
}
