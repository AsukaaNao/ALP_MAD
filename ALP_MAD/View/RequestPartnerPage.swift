import SwiftUI

struct RequestPartnerPage: View {
    @StateObject private var viewModel = RequestPartnerPageVM()
    var tag: String
    
    @State private var navigateBack = false
    
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
                    if let profilePictureUrl = user.profilePictureUrl, let url = URL(string: profilePictureUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 200, height: 200)
                                .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                        }
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
                        Alert(title: Text("Request Sent"), message: Text("Your request has been sent successfully!"), dismissButton: .default(Text("OK")) {
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigateBack = true
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .frame(width: 8)
                        Text("Back")
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateBack) {
            ConnectPartnerPage()
        }
        
    }
}

#Preview {
    RequestPartnerPage(tag: "1234")
}
