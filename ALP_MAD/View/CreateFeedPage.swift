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

struct CircularImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable().scaledToFill()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
    }
}

struct CreateFeedPage: View {
    
    @Binding var isPresented: Bool
    
    @State var viewModel = CreateFeedVM()
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    @State var isConfirmationDialogPresented: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var loginStatusMessage = ""
    @State private var caption: String = ""
    
    enum SourceType {
        case camera
        case photoLibrary
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Create a Feed to update your partner!")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.purple)
                
                Spacer()
                    .frame(height: 40)
                
                // Image Placeholder
                VStack {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple, lineWidth: 2)
                            )
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                            Text("+")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                    }
                }
                .onTapGesture {
                    isConfirmationDialogPresented = true
                }
                .confirmationDialog("Choose an option", isPresented: $isConfirmationDialogPresented) {
                    Button("Camera") {
                        sourceType = .camera
                        shouldShowImagePicker = true
                    }
                    Button("Photo Library") {
                        sourceType = .photoLibrary
                        shouldShowImagePicker = true
                    }
                }
                .sheet(isPresented: $shouldShowImagePicker) {
                    if sourceType == .camera {
                        ImagePicker(selectedImage: $image, isPickerShowing: $shouldShowImagePicker, sourceType: .camera)
                    } else {
                        ImagePicker(selectedImage: $image, isPickerShowing: $shouldShowImagePicker, sourceType: .photoLibrary)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
                
                // Caption Text Field
                TextField("Add a caption", text: $caption)
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
                Button {
                    viewModel.caption = caption
                    viewModel.date = Date()
                    viewModel.createFeed(image!) {
                        self.isPresented = false
                    }
                } label: {
                    Text("Create Feed")
                }
                .padding()
                .foregroundColor(.white)
                .background(caption.isEmpty ? Color.gray : Color.purple)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                .disabled(caption.isEmpty)
                
                Text(self.loginStatusMessage)
                    .foregroundColor(.red)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(selectedImage: $image, isPickerShowing: $shouldShowImagePicker, sourceType: sourceType)
            }
        }
    }
}

struct CreateFeedPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateFeedPage(isPresented: .constant(true))
    }
}
