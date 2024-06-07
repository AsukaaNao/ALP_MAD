//
//  MacHeartLinkApp.swift
//  MacHeartLink
//
//  Created by MacBook Pro on 04/06/24.
//  Copyright © 2024 test. All rights reserved.
//

import SwiftUI
import Firebase

@main
struct MacHeartLinkApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {   
//            FeedsPage()
            ContentView()
                .environmentObject(EventStore(preview: true))
        }
    }
}
