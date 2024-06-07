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
            NavigationView {
                RootView()
            }
            .tabItem {
                Label("Main Page", systemImage: "location")
            }
            
            NavigationView {
                RootView()
            }
            .tabItem {
                Label("Feeds", systemImage: "newspaper")
            }
            
            NavigationView {
                RootView()
            }
            .tabItem {
                Label("Events", systemImage: "calendar")
            }
        }
        .accentColor(.blue)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all)) // Ensuring full background color
    }
}


#Preview {
    ContentView()
}
