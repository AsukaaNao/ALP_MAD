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

class LandingPageVM: ObservableObject {
    
    @Published private(set) var UID: String? = ""
    @Published var isPickerShowing = false
    @Published var profilePicture: UIImage?
    @Published var name: String = ""
    @Published var tag: String = ""
    
    private var db = Firestore.firestore()
    
    init() {
        // Fetch user data when the view model is initialized
        if let uid = getCurrentUserUID() {
            fetchUserData(uid: uid)
        }
    }
    
   func getCurrentUserUID() -> String? {
        do {
            return try AuthenticationManager.shared.getAuthenticatedUser().uid
        } catch {
            print("Error getting current user UID: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchUserData(uid: String) {
        // Fetch user data from Firestore
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                print("Getting user data")
                if let profilePictureURL = document.data()?["profilePicture"] as? String {
                    self.downloadProfilePicture(from: profilePictureURL)
                }
                self.name = document.data()?["name"] as? String ?? ""
                self.tag = document.data()?["tag"] as? String ?? ""
            } else {
                print("User document does not exist")
            }
        }
    }
    
    private func downloadProfilePicture(from path: String) {
        let storageRef = Storage.storage().reference(withPath: path)
        
        // Create a temporary file URL to store the downloaded data
        let temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        
        // Download the file in chunks and write to the temporary file
        let downloadTask = storageRef.write(toFile: temporaryFileURL) { url, error in
            if let error = error {
                print("Error downloading profile picture: \(error.localizedDescription)")
            } else {
                if let url = url {
                    do {
                        // Read the data from the temporary file
                        let data = try Data(contentsOf: url)
                        self.profilePicture = UIImage(data: data)
                    } catch {
                        print("Error creating UIImage from downloaded data: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        // Observe the download progress if needed
        downloadTask.observe(.progress) { snapshot in
            // Update UI with download progress
        }
        
        // Observe the download completion if needed
        downloadTask.observe(.success) { snapshot in
            // Handle download completion
        }
    }
    
    
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
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        self.UID = ""
        
        print("User logged out, UID is now: \(String(describing: self.UID))")
    }
}
