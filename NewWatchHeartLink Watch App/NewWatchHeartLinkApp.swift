//
//  NewWatchHeartLinkApp.swift
//  NewWatchHeartLink Watch App
//
//  Created by MacBook Pro on 06/06/24.
//

import SwiftUI

@main
struct NewWatchHeartLink_Watch_AppApp: App {
    
    @StateObject var myEvents = EventStore(preview: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myEvents)
        }
    }
}
