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

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
    
}

struct CreateFeedPage: View {
    
    @StateObject private var viewModel = FeedVM()
    
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                // Image
                Button {
                    shouldShowImagePicker.toggle()
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
                Button {
                    createFeed()
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
                
                
                Text(self.loginStatusMessage)
                    .foregroundColor(.red)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
        }
    }
    
    @State var image: UIImage?
    
    private func createFeed() {
        self.persistImageToStorage()
    }
    
    private func persistImageToStorage() {
        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                
                
            }
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


