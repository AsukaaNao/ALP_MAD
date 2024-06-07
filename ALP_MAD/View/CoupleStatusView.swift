import SwiftUI

struct CoupleStatusView: View {
    @ObservedObject var viewModel: MainPageViewModel
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            // This empty VStack is used for the navigation logic
        }
        .onAppear {
            checkUserAuthentication()
        }
        .onChange(of: viewModel.hasCoupleId) { newValue in
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
        print("check user authentication !!!!!!!!!!!!!!!")
        if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
            viewModel.fetchCoupleId(for: user.uid)
        } else {
            self.showSignInView = true
        }
    }
}
