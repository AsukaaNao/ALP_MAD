//
//  WidgetHeartLinkBundle.swift
//  WidgetHeartLink
//
//  Created by MacBook Pro on 04/06/24.
//  Copyright © 2024 test. All rights reserved.
//

import WidgetKit
import SwiftUI
import Firebase

@main
struct WidgetHeartLinkBundle: WidgetBundle {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Widget {
        WidgetHeartLink()
    }
}
