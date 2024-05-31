//
//  ListViewRowMac.swift
//  MacHeartlink
//
//  Created by Shelfinna on 31/05/24.
//

import SwiftUI

struct ListViewRowMac: View {
    let event: Event
    @Binding var formType: EventFormType?
    @EnvironmentObject var myEvents: EventStore
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.eventType.icon)
                        .font(.system(size: 30))
                    VStack(alignment: .leading){
                        Text(event.note)
                        Text(
                            event.date.formatted(date: .abbreviated,
                                                 time: .shortened)
                        )
                        .padding(.top, 2)
                        .font(.subheadline)
                    }
                }
            }
            Spacer()
            HStack{
                Button {
                    formType = .update(event)
                } label: {
                    Text("Edit")
                }
                .buttonStyle(.accessoryBarAction)
                Button {
                    myEvents.delete(event) // Delete the event
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.accessoryBar)
                .foregroundColor(.red)
            }
        }
        .padding()
    }
}


struct ListViewRowMac_Previews: PreviewProvider {
    static let event = Event(eventType: .date, date: Date(), note: "Let's party")
    static var previews: some View {
        ListViewRowMac(event: event, formType: .constant(.new))
    }
}
