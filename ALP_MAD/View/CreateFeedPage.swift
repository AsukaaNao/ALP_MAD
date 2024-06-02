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
    
    @Binding var isPresented: Bool
    
    @State var viewModel = CreateFeedVM()
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    @State var user_name = ""
    @State var user_picture = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("Create a Feed to update your partner!")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.purple)
                
                Spacer()
                    .frame(height: 40)
                
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
                TextField("Add a caption", text: $viewModel.caption)
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
                        viewModel.createFeed(image) {
                            self.isPresented = false
                        }
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
//        do {
//            let user = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.user_name = user.email ?? "No Email"
//            self.user_picture = user.photoUrl ?? ""
//        } catch {
//            self.loginStatusMessage = "Failed to fetch user: \(error)"
//        }
    }
}

struct CreateFeedPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateFeedPage(isPresented: .constant(true))
    }
}
