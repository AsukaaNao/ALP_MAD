import SwiftUI

struct LandingPage: View {
    
    @StateObject var viewModel = LandingPageVM()
    @State var isPickerShowing = false
    @State private var navigateToConnectPartnerPage = false
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Welcome to Heartlink")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .foregroundColor(.purple)
                
                ZStack {
                    if let profilePicture = viewModel.profilePicture {
                        Image(uiImage: profilePicture)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 200, height: 200)
                            .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isPickerShowing = true
                            }) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.purple)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                            .offset(x: -10, y: -10)
                        }
                    }
                    .frame(width: 200, height: 200)
                }
                
                VStack(spacing: 4) {
                    Text(viewModel.name)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Text("#\(viewModel.tag)")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    // Continue action
                    if let profilePicture = viewModel.profilePicture {
                        viewModel.uploadPhoto(profilePicture)
                    }
                    navigateToConnectPartnerPage = true
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                ImagePicker(selectedImage: $viewModel.profilePicture, isPickerShowing: $isPickerShowing)
            }
            .background(Color.white)
            .navigationDestination(isPresented: $navigateToConnectPartnerPage) {
                ConnectPartnerPage()
            }
            .navigationBarItems(trailing: Button(action: {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.purple)
            })
        }
        .navigationBarHidden(false)
    }
}

#Preview {
    LandingPage(showSignInView: .constant(false))
}
