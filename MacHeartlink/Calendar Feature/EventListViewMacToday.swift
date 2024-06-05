//
//  EventListViewMacToday.swift
//  MacHeartlink
//
//  Created by Shelfinna on 31/05/24.
//

import SwiftUI

struct EventListViewMacToday: View {
    @EnvironmentObject var myEvents: EventStore
    @Binding var dateSelected: DateComponents?
    @State private var formType: EventFormType?
    
    var body: some View {
        NavigationStack {
            List {
                if let dateSelected = dateSelected,
                   let date = Calendar.current.date(from: dateSelected) {
                    Section(header: Text("Events for \(formattedDate(from: dateSelected))")) {
                        ForEach(eventsForSelectedDate(date: date), id: \.id) { event in
                            ListViewRowMac(event: event, formType: $formType)
                        }
                    }
                } else {
                    Text("No date selected")
                }
            }
            .navigationTitle("Calendar Events")
            .sheet(item: $formType) { $0 }
            
        }
    }
    
    private func eventsForSelectedDate(date: Date) -> [Event] {
        myEvents.events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private func formattedDate(from dateComponents: DateComponents) -> String {
        guard let date = Calendar.current.date(from: dateComponents) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct EventListViewMacToday_Previews: PreviewProvider {
    static var previews: some View {
        EventListViewMacToday(dateSelected: .constant(nil))
            .environmentObject(EventStore(preview: true))
    }
}

