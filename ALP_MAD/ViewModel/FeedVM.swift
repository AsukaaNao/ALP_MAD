//
//  FeedVM.swift
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

class FeedVM: ObservableObject {
    
    @Published var image = ""
    @Published var caption = ""
    @Published var date = Date()
    @Published var user_name = ""
    @Published var user_picture = ""
    
    func uploadPhoto(_ selectedImage: UIImage) {
            
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
//                    var uid = "2t05MsX8uRQxbjUmRzUFsUaJrhp1"
//                    do {
//                        uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
//                    } catch {
//                        print("Error")
//                    }
//                    self.db.collection("users").document(uid).setData(["profilePicture": path])
                }
            }
        }
    
}

