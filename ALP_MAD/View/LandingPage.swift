import SwiftUI

struct LandingPage: View {
    
    @StateObject var viewModel = LandingPageVM()
    @State var isPickerShowing = false
    @State private var navigateToConnectPartnerPage = false
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) var dismiss
    
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isConfirmationDialogPresented: Bool = false

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
                            .scaledToFill()
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
                                isConfirmationDialogPresented = true
                            }) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.purple)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .aspectRatio(contentMode: .fit)
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
                        .frame(maxWidth: 290)
                        .background(Color.purple)
                        .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
            .onAppear() {
                if let uid = viewModel.getCurrentUserUID() {
                    viewModel.fetchUserData(uid: uid)
                }
            }
            .confirmationDialog("Choose an option", isPresented: $isConfirmationDialogPresented) {
                Button("Camera") {
                    sourceType = .camera
                    isPickerShowing = true
                }
                Button("Photo Library") {
                    sourceType = .photoLibrary
                    isPickerShowing = true
                }
            }
            .sheet(isPresented: $isPickerShowing) {
                ImagePicker(selectedImage: $viewModel.profilePicture, isPickerShowing: $isPickerShowing, sourceType: sourceType)
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
                        dismiss()
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LandingPage(showSignInView: .constant(true))
}
