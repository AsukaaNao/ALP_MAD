import SwiftUI

struct RequestPartnerPage: View {
    @StateObject private var viewModel = RequestPartnerPageVM()
    var tag: String
    @Environment(\.dismiss) var dismiss
    @State private var navigateToCustomDestination = false // State variable for custom navigation
    @State private var navigateBack = false // State variable for navigating back
    
    var body: some View {
        VStack {
            Text("Searching partner...")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
                .foregroundColor(.purple)
            
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .scaleEffect(1.5)
            } else if let user = viewModel.foundUser {
                VStack(spacing: 20) {
                    if let profilePicture = viewModel.profilePicture {
                        Image(uiImage: profilePicture)
                            .resizable()
                            .scaledToFill() // Ensures the image fills the frame while maintaining the aspect ratio
                            .frame(width: 200, height: 200)
                            .clipShape(Circle()) // Clips the image into a circle shape
                            .overlay(Circle().stroke(Color.purple, lineWidth: 4)) // Adds a circular border
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 200, height: 200)
                            .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                    }
                    
                    Text(user.name)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Text("#\(user.tag)")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        viewModel.sendRequest(to: user)
                    }) {
                        Text("Send Request")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 290)
                            .background(Color.purple)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .alert(isPresented: $viewModel.requestSent) {
                        Alert(
                            title: Text("Request Sent"),
                            message: Text("Your request has been sent successfully!"),
                            dismissButton: .default(Text("OK")) {
                                navigateBack = true
                            }
                        )
                    }
                }
            } else {
                Text("No partner found.")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.searchUser(by: tag)
        }
        .padding()
        .background(Color.white)
        .navigationBarTitle("Request Partner", displayMode: .inline)
        .navigationBarBackButtonHidden(true) // Hide default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigateToCustomDestination = true
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateToCustomDestination) {
            // Replace `RootView()` with the destination view you want to navigate to
            RootView()
        }
        .navigationDestination(isPresented: $navigateBack) {
            // Replace `RootView()` with the destination view you want to navigate to when navigating back
            RootView()
        }
    }
}

#Preview {
    RequestPartnerPage(tag: "1234")
}
