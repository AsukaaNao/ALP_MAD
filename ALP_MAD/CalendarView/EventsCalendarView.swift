//
//  EventsCalendarView.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import SwiftUI

struct EventsCalendarView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var eventStore: EventStore
    @State private var dateSelected: DateComponents?
    @State private var displayEvents = false
    @State private var formType: EventFormType?
    @EnvironmentObject var myEvents: EventStore
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), eventStore: eventStore, dateSelected: $dateSelected, displayEvents: $displayEvents)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("All Events")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                        .padding(10)
                        .padding(.horizontal, horizontalSizeClass == .regular ? 40 : 0)
                        .padding(.vertical, horizontalSizeClass == .regular ? 20 : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                        .frame(height:20)
                    
                    ForEach(Array(myEvents.events.sorted { $0.date < $1.date }.enumerated()), id: \.element.id) { index, event in
                        VStack {
                            HStack {
                                ListViewRow(event: event, formType: $formType)
                                    .padding(.horizontal)
                                Button(role: .destructive) {
                                    myEvents.delete(event)
                                } label: {
                                    Image(systemName: "trash")
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                        if index < myEvents.events.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }.padding(.horizontal, horizontalSizeClass == .regular ? 40 : 0)
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("New")
                            .fontWeight(.medium)
                        Button {
                            formType = .new
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.medium)
                        }
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
}


struct EventsCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendarView().environmentObject(EventStore(preview: true))
        EventsListView()
            .environmentObject(EventStore(preview: true))
    }
}
