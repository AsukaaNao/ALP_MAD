//
//  ContentView.swift
//  NewWatchHeartLink Watch App
//
//  Created by MacBook Pro on 06/06/24.
//

import SwiftUI

struct ContentView: View {
    
    static var currentDateComponents: DateComponents {
            var dateComponents = Calendar.current.dateComponents(
                [.month, .day, .year, .hour, .minute],
                from: Date())
            dateComponents.timeZone = TimeZone.current
            dateComponents.calendar = Calendar(identifier: .gregorian)
            return dateComponents
        }
        
        @State private var dateSelected: DateComponents? = ContentView.currentDateComponents
    
    var body: some View {
        TabView {
            FeedsPage()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Feeds")
                }
            
            CalendarView(dateSelected: $dateSelected)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            LocationView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Location")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EventStore(preview: true)) // Provide the EventStore environment object for preview
    }
}

