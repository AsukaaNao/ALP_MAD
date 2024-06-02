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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            CreateFeedPage()
            FeedsPage()
        }
    }
}
