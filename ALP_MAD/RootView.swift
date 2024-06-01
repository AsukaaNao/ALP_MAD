import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = MainPageViewModel()
    @State private var showSignInView: Bool = false
    @State private var isSignInSuccess: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    if showSignInView {
                        // User is not signed in, show LoginPage
                        LoginPage()
                    } else {
                        // User is signed in, show appropriate page
                        if viewModel.hasCoupleId {
                            MainPage(showSignInView: $showSignInView)
                        } else {
                            LandingPage(showSignInView: $showSignInView)
                        }
                    }
                }
            }
            .onAppear {
                if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
                    viewModel.fetchCoupleId(for: user.uid)
                } else {
                    self.showSignInView = true
                }
            }
            .navigationDestination(isPresented: $isSignInSuccess) {
                if viewModel.hasCoupleId {
                    MainPage(showSignInView: $showSignInView)
                } else {
                    LandingPage(showSignInView: $showSignInView)
                }
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    RootView()
}
