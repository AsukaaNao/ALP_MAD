//
//  MainPage.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 16/05/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

struct Settings: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .navigationTitle("Main Page")
    }
}

#Preview {
    NavigationStack {
        Settings(showSignInView: .constant(true))
    }
}
