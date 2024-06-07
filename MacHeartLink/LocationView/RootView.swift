import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = MainPageViewModel()
    @State private var showSignInView: Bool = false

    var body: some View {
        NavigationView {
            CoupleStatusView(viewModel: viewModel, showSignInView: $showSignInView)
                .sheet(isPresented: $showSignInView) {
                    LoginPage(showSignInView: $showSignInView)
                        .frame(minWidth: 400, minHeight: 300)  // Adjust size as necessary
                }
        }
        .frame(minWidth: 800, minHeight: 600)  // Adjust size as necessary
    }
}
