//
//  CreateFeedVM.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 30/05/24.
//  Copyright © 2024 test. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import Photos
import UIKit

import FirebaseStorage

class CreateFeedVM: ObservableObject {
    
    @Published var image = ""
    @Published var caption = ""
    @Published var date = Date()
    @Published var user_name = ""
    @Published var user_picture = ""
    
    @Published var isPickerShowing = false
    @Published private(set) var UID: String? = ""
    
    let db = Firestore.firestore()
    
    func createFeed(_ selectedImage: UIImage, completion: @escaping () -> Void) {
        guard !caption.isEmpty else {
            print("No Email or password found")
            return
        }
        
        Task {
            do {
                
                let feedData: [String: Any] = [
                    "image": "",
                    "caption": caption,
                    "date": date,
                    "user_name": user_name,
                    "user_picture": user_picture
                ]
                
                // perlu diganti uid ke Auth
                let uid = "fer63Q4T9aCtdpXwkxe5"
                try await db.collection("couples").document(uid).collection("feeds").addDocument(data: feedData)
                
                // create reference
                let storageRef = Storage.storage().reference()
                
                // turn image into data
                let imageData = selectedImage.jpegData(compressionQuality: 0.8)
                
                guard imageData != nil else {
                    return
                }
                
                //file path and name
                let path = "feedPicture/\(UUID().uuidString).jpeg"
                let fileRef = storageRef.child(path)
                
                //upload
                _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                    if error != nil && metadata != nil {
                        // saveto firestore
                        var uid = "2t05MsX8uRQxbjUmRzUFsUaJrhp1"
                        do {
                            uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
                        } catch {
                            print("Error")
                        }
                        self.db.collection("users").document(uid).setData(["image": path])
                    }
                }
                
                print("Success Create Feeds in Couples")
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        completion()
        
    }
    
}

//Task {
//    do {
//        let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
//        let uid = authResult.uid
//
//        let userData: [String: Any] = [
//            "username": username,
//            "email": email,
//            "location": GeoPoint(latitude: 0.0, longitude: 0.0), // Dummy location, update as needed
//            "tag": generateTag()
//        ]
//
//        try await db.collection("users").document(uid).setData(userData)
//
//        print("Success Create User and Added to Firestore")
//        print(authResult)
//        completion(true)
//    } catch {
//        print(error.localizedDescription)
//        completion(false)
//    }
//}
