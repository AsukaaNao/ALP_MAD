import SwiftUI

struct CoupleStatusView: View {
    @ObservedObject var viewModel: MainPageVM
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            // This empty VStack is used for the navigation logic
        }
        .onAppear {
            checkUserAuthentication()
        }
        .navigationDestination(isPresented: $viewModel.hasCoupleId) {
            MainPage(showSignInView: $showSignInView)
        }
        .navigationDestination(isPresented: .constant(!viewModel.hasCoupleId && !showSignInView)) {
            LandingPage(showSignInView: $showSignInView)
        }
    }
    
    private func checkUserAuthentication() {
        if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
            viewModel.fetchCoupleId(for: user.uid)
        } else {
            self.showSignInView = true
        }
    }
}
