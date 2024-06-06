//
//  EventFormView.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import SwiftUI

struct EventFormView: View {
    @EnvironmentObject var eventStore: EventStore
    @StateObject var viewModel: EventFormViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    DatePicker(selection: $viewModel.date) {
                        Text("Date and Time")
                    }
                    TextField("Note", text: $viewModel.note, axis: .vertical)
                        .focused($focus, equals: true)
                    Picker("Event Type", selection: $viewModel.eventType) {
                        ForEach(Event.EventType.allCases) { eventType in
                            Text(eventType.icon + " " + eventType.rawValue.capitalized)
                                .tag(eventType)
                        }
                    }
                    Section(footer:
                                HStack {
                                    Spacer()
                                    Button {
                                        if viewModel.updating {
                                            // update this event
                                            let event = Event(id: viewModel.id!,
                                                              eventType: viewModel.eventType,
                                                              date: viewModel.date,
                                                              note: viewModel.note)
                                            eventStore.update(event)
                                        } else {
                                            // create new event
                                            let newEvent = Event(eventType: viewModel.eventType,
                                                                 date: viewModel.date,
                                                                 note: viewModel.note)
                                            eventStore.add(newEvent)
                                        }
                                        dismiss()
                                    } label: {
                                        Text(viewModel.updating ? "Update Event" : "Add Event")
                                                    .padding(.horizontal, 20)
                                                    .padding(.vertical, 10)
                                                    .background(
                                                        viewModel.incomplete ? Color.gray : Color.purple
                                                    )
                                                    .foregroundColor(viewModel.incomplete ? Color.white : Color.white)
                                                    .cornerRadius(8)
                                    }
//                                    .buttonStyle(.borderedProminent)
                                    .disabled(viewModel.incomplete)
                                    Spacer()
                                }
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(viewModel.updating ? "Update" : "New Event")
            .onAppear {
                focus = true
            }
        }
        .padding([.horizontal, .vertical], isMacOS() ? 40 : 0) // Additional horizontal padding for macOS
    }
    
    func isMacOS() -> Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}


struct EventFormView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView(viewModel: EventFormViewModel())
            .environmentObject(EventStore())
    }
}
