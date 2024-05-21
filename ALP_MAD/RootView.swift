//
//  RootView.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 16/05/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
//                Settings(showSignInView: $showSignInView)
                MainPage(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let user = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = user == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                LoginPage()
            }
        }
    }
}

#Preview {
    RootView()
}
