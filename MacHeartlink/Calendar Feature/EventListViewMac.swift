//
//  EventListViewMac.swift
//  MacHeartlink
//
//  Created by Shelfinna on 30/05/24.
//

import SwiftUI

struct EventListViewMac: View {
    @EnvironmentObject var myEvents: EventStore
    @State private var formType: EventFormType?
    var body: some View {
        NavigationStack {
            List {
                ForEach(myEvents.events.sorted {$0.date < $1.date }) { event in
                    ListViewRow(event: event, formType: $formType)
                    .swipeActions {
                        Button(role: .destructive) {
                            myEvents.delete(event)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Calendar Events")
            .sheet(item: $formType) { $0 }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        formType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                    }
                }
            }
        }
    }
}

struct EventListViewMac_Previews: PreviewProvider {
    static var previews: some View {
        EventListViewMac()
            .environmentObject(EventStore(preview: true))
    }
}
