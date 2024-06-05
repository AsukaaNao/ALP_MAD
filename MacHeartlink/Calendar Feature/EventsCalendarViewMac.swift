//
//  EventsCalendarViewMac.swift
//  MacHeartlink
//
//  Created by Shelfinna on 30/05/24.
//

import SwiftUI

struct EventsCalendarViewMac: View {
    @EnvironmentObject var eventStore: EventStore
    @State private var dateSelected: DateComponents? = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    @State private var displayEvents = false
    @State private var formType: EventFormType?
    @EnvironmentObject var myEvents: EventStore
    
    var body: some View {
        HStack {
            EventListViewMac()
                .background(Color.white)
                .padding(.top, 10)
            VStack {
                CalendarViewMac(interval: DateInterval(start: .distantPast, end: .distantFuture), eventStore: eventStore, dateSelected: $dateSelected, displayEvents: $displayEvents)
                    .padding(.top, 20)
                EventListViewMacToday(dateSelected: $dateSelected)
                    .background(Color.white)
                    .padding(.top, 10)
            }
        }
        .background(Color.white)
    }
}

#Preview {
    EventsCalendarViewMac().environmentObject(EventStore(preview: true))
}

