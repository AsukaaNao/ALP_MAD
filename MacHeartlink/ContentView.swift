//
//  ContentView.swift
//  MacHeartlink
//
//  Created by Shelfinna on 30/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EventsCalendarViewMac()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EventStore(preview: true))
    }
}
