import SwiftUI

struct ConnectPartnerPage: View {
    @StateObject private var viewModel = ConnectPartnerPageVM()
    @State private var showTagPopup = false
    @State private var tag = ""
    @State private var navigateToRequestPartner = false
    @State private var navigateToMainPage = false // State variable for navigating to MainPage
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Find Your Partner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.purple) // Explicit color
                Text("Connect with your partner through their Tag!")
                
                if (viewModel.userRequests.isEmpty) {
                    Text("there are currently no requests...")
                        .foregroundStyle(Color.gray)
                }
                
                List(viewModel.userRequests) { request in
                    HStack {
                        if let profilePicture = request.profilePicture {
                            Image(uiImage: profilePicture)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                                .padding(.trailing, 8)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 50, height: 50)
                                .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                                .padding(.trailing, 8)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(request.name)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(Color.black) // Explicit color
                            Text("#\(request.tag)")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.acceptRequest(request)
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green) // Explicit color
                                .font(.title2)
                        }
                        
                        Button(action: {
                            viewModel.rejectRequest(request)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.red) // Explicit color
                                .font(.title2)
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                }
                .listStyle(PlainListStyle())
                .background(Color.white) // Explicit color
                
                Spacer()
                
                Button(action: {
                    showTagPopup = true
                }) {
                    Text("Request Partner")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white) // Explicit color
                        .padding()
                        .frame(maxWidth: 290)
                        .background(Color.purple) // Explicit color
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                
                Button(action: {
                    navigateToMainPage = true // Trigger navigation to MainPage
                }) {
                    Text("Go to Main Page")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: 290)
                        .background(Color.gray)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .background(Color.white) // Explicit color
            .alert("Enter Tag", isPresented: $showTagPopup) {
                TextField("Tag", text: $tag)
                    .background(Color.white)
                Button("Search") {
                    navigateToRequestPartner = true
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enter the tag to search for a partner.")
            }
            .preferredColorScheme(.light) // Force light mode
            .navigationDestination(isPresented: $navigateToRequestPartner) {
                RequestPartnerPage(tag: tag)
            }
            .navigationDestination(isPresented: $navigateToMainPage) { // Navigation to MainPage
                RootView()
//                MainPage(showSignInView: .constant(false))
            }
            .navigationBarHidden(false)
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    ConnectPartnerPage()
}
