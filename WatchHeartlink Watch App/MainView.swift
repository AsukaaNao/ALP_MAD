//
//  MainView.swift
//  WatchHeartlink Watch App
//
//  Created by Shelfinna on 01/06/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var eventStore: EventStore
    @Binding var dateSelected: DateComponents?
    
    var body: some View {
        NavigationStack {
            Group {
                if let dateSelected {
                    let foundEvents = eventStore.events
                        .filter {$0.date.startOfDay == dateSelected.date!.startOfDay}
                    List {
                        ForEach(foundEvents) { event in
                            ListView(event: event)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        eventStore.delete(event)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Today's Event")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: Date())
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    static var previews: some View {
        MainView(dateSelected: .constant(dateComponents))
            .environmentObject(EventStore(preview: true)
            )
    }
}
