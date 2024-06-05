import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = MainPageViewModel()
    @State private var showSignInView: Bool = false

    var body: some View {
        NavigationStack {
            CoupleStatusView(viewModel: viewModel, showSignInView: $showSignInView)
                .fullScreenCover(isPresented: $showSignInView) {
                    NavigationStack {
                        LoginPage(showSignInView: $showSignInView)
                    }
                }
        }
    }
}
