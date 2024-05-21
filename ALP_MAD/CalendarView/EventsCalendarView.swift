//
//  EventsCalendarView.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import SwiftUI

struct EventsCalendarView: View {
    @EnvironmentObject var eventStore: EventStore
    @State private var dateSelected: DateComponents?
    @State private var displayEvents = false
    @State private var formType: EventFormType?
    @EnvironmentObject var myEvents: EventStore
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), eventStore: eventStore, dateSelected: $dateSelected, displayEvents: $displayEvents)
                }
                
                ForEach(Array(myEvents.events.sorted { $0.date < $1.date }.enumerated()), id: \.element.id) { index, event in
                    VStack {
                        HStack {
                            ListViewRow(event: event, formType: $formType)
                                .padding(.horizontal)
                            Button(role: .destructive) {
                                myEvents.delete(event)
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                        }
                        
                    }
                    if index < myEvents.events.count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    formType = .new
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                }
            }
        }
        .sheet(item: $formType) { $0 }
        .sheet(isPresented: $displayEvents) {
            DaysEventsListView(dateSelected: $dateSelected)
                .presentationDetents([.medium, .large])
        }
        
    }
    
}


struct EventsCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendarView().environmentObject(EventStore(preview: true))
        EventsListView()
            .environmentObject(EventStore(preview: true))
    }
}
