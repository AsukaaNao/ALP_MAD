//
//  ContentView.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 16/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RootView()
                .tabItem {
                    Label("Main Page", systemImage: "location")
                }
                .background(Color(.systemBackground))
            
            FeedsPage()
                .tabItem {
                    Label("Feeds", systemImage: "newspaper")
                }
                .background(Color(.systemBackground))
            
            EventsCalendarView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
                .background(Color(.systemBackground))
        }
        .accentColor(.blue) // Customize tab icon and text color
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all)) // Ensuring full background color
    }
}


#Preview {
    ContentView()
        .environmentObject(EventStore(preview: true))
}
