//
//  LandingPageVM.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 30/05/24.
//  Copyright © 2024 test. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import FirebaseFirestore

class LandingPageVM: ObservableObject {
    
    @Published var isPickerShowing = false
    @Published private(set) var UID: String? = ""
//    @Published var selectedImage: UIImage?
    
    let db = Firestore.firestore()
    
    func uploadPhoto(_ selectedImage: UIImage) {
        
        // create reference
        let storageRef = Storage.storage().reference()
        
        // turn image into data
        let imageData = selectedImage.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        //file path and name
        let path = "profilePicture/\(UUID().uuidString).jpeg"
        let fileRef = storageRef.child(path)
        
        //upload
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // saveto firestore
//                var uid = "2t05MsX8uRQxbjUmRzUFsUaJrhp1"
                do {
                    let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
                    self.UID = uid
                } catch {
                    print("Error")
                }
                self.db.collection("users").document(self.UID!).updateData(["profilePicture": path])
                
            }
        }
    }
}
