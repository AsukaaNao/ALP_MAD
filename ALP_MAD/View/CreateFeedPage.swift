//
//  CreateFeedPage.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 30/05/24.
//  Copyright © 2024 test. All rights reserved.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseStorage

struct CreateFeedPage: View {
    
    @State var viewModel = FeedVM()
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    @State var user_name = ""
    @State var user_picture = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                // Image
                Button {
                    shouldShowImagePicker = true
                } label: {
                    
                    VStack {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                        } else {
                            Text("Add Image")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 1)
                    )
                    
                }
                
                Spacer()
                    .frame(height: 40)
                
                // Text Field
                ZStack(alignment: .leading){
                    if viewModel.caption.isEmpty {
                        Text("Add a caption")
                            .foregroundColor(.gray)
                    }
                    TextField("", text: $viewModel.caption)
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                
                Spacer()
                    .frame(height: 40)
                
                
                // Create Button
                if let image = image {
                    
                    Button {
                        fetchCurrentUser()
                        viewModel.user_name = user_name
                        viewModel.user_picture = user_picture
                        viewModel.date = Date()
                        viewModel.createFeed(image)
                    } label: {
                        Text("Create Feed")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 1)
                    )
                    .padding(.horizontal, 40)
                }
                
                Text(self.loginStatusMessage)
                    .foregroundColor(.red)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                                ImagePicker(selectedImage: $image, isPickerShowing: $shouldShowImagePicker)
            }
        }
    }
    
    private func fetchCurrentUser() {
        do {
            let user = try AuthenticationManager.shared.getAuthenticatedUser()
            self.user_name = user.email ?? "No Email"
            self.user_picture = user.photoUrl ?? ""
//            self.user_name = "Haha"
//            self.user_picture = "profilePicture/0D09B0AE-C9A9-4A1F-9549-E16A277C97DF.jpeg"
        } catch {
            self.loginStatusMessage = "Failed to fetch user: \(error)"
        }
    }
    
}

//#Preview {
//    CreateFeedPage()
//}

struct CreateFeedPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateFeedPage()
    }
}


