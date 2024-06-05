//
//  ALP_MADApp.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 16/05/24.
//

import SwiftUI
import Firebase

@main
struct ALP_MADApp: App {
    @StateObject var myEvents = EventStore(preview: true)
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD
//            ContentView()
//            CreateFeedPage()
            FeedsPage()
=======
            ContentView()
                .environmentObject(EventStore(preview: true))
>>>>>>> main
        }
    }
}
