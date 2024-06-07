//
//  ListViewRow.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import SwiftUI

struct ListViewRow: View {
    let event: Event
    @Binding var formType: EventFormType?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.eventType.icon)
                        .font(.system(size: 40))
                    VStack(alignment: .leading){
                        Text(event.note)
                        Text(
                            event.date.formatted(date: .abbreviated,
                                                 time: .shortened)
                        )
                        .font(.caption)
                    }
                }
                
            }
            Spacer()
            Button {
                formType = .update(event)
            } label: {
                Text("Edit")
                    .foregroundColor(.white)
            }
            
            .buttonStyle(PurpleButtonStyle())
        }
    }
}

struct PurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.purple)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

 struct ListViewRow_Previews: PreviewProvider {
     static let event = Event(eventType: .date, date: Date(), note: "Let's party")
    static var previews: some View {
        ListViewRow(event: event, formType: .constant(.new))
    }
 }
