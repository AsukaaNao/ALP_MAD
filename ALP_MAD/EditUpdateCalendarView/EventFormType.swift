//
//  EventFormType.swift
//  ALP_MAD
//
//  Created by Shelfinna on 21/05/24.
//

import SwiftUI

enum EventFormType: Identifiable, View {
    case new
    case update(Event)
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }

    var body: some View {
        switch self {
        case .new:
            return EventFormView(viewModel: EventFormViewModel())
        case .update(let event):
            return EventFormView(viewModel: EventFormViewModel(event))
        }
    }
}
