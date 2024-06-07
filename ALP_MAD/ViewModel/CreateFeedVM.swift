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

struct UserForCreateFeed: Codable {
    var user_name: String
    var user_picture: String
    var couple_id: String
}

class CreateFeedVM: ObservableObject {
    
    @Published var image = ""
    @Published var caption = ""
    @Published var date = Date()
    @Published var user_name = ""
    @Published var user_picture = ""
    
    @Published var user = UserForCreateFeed(user_name: "null", user_picture: "null", couple_id: "null")
    @Published var isPickerShowing = false
    @Published private(set) var UID: String? = ""
    
    let db = Firestore.firestore()
    
    func createFeed(_ selectedImage: UIImage, completion: @escaping () -> Void) {
        guard !caption.isEmpty else {
            print("Caption is empty")
            return
        }
        
        Task {
            do {
                // Get the authenticated user's UID
                let uid = "dummy_user_Giselle"
                guard let uid = Auth.auth().currentUser?.uid else {
                               print("No authenticated user found")
                               return
                           }
                
                // Fetch user data
                if let user = try await fetchUser(uid: uid) {
                    self.user = user
                    print("User fetched: \(user)")
                } else {
                    print("User not found")
                }
                
                // Create reference
                let storageRef = Storage.storage().reference()
                
                // File path and name
                let path = "feedPicture/\(UUID().uuidString).jpeg"
                let fileRef = storageRef.child(path)
                
                // Turn image into data
                guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                    print("Error converting image to data")
                    return
                }
                
                // Upload image
                fileRef.putData(imageData, metadata: nil) { metadata, error in
                    if error == nil && metadata != nil {
                        // Prepare feed data
                        let feedData: [String: Any] = [
                            "image": path,
                            "caption": self.caption,
                            "date": self.date,
                            "user_name": self.user.user_name,
                            "user_picture": self.user.user_picture
                        ]
                        
                        // Specify the couple ID (this should ideally be dynamic or passed as a parameter)
                        let couple_id = self.user.couple_id
                        self.db.collection("couples").document(couple_id).collection("feeds").addDocument(data: feedData) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                self.saveLatestFeed(feed: feedData)
                                print("Successfully created feed in couples")
                                completion()
                            }
                        }
                    } else {
                        print("Error uploading image: \(String(describing: error))")
                    }
                }
            } catch {
                print("Error creating feed: \(error)")
            }
        }
    }
    
    func fetchUser(uid: String) async throws -> UserForCreateFeed? {
        let document = try await db.collection("users").document(uid).getDocument()
        
        guard let data = document.data() else {
            print("User not found")
            return nil
        }
        
        let user_name = data["name"] as? String ?? ""
        let user_picture = data["profilePicture"] as? String ?? ""
        let couple_id = data["couple_id"] as? String ?? ""
        
        return UserForCreateFeed(user_name: user_name, user_picture: user_picture, couple_id: couple_id)
    }
    
    private func saveLatestFeed(feed: [String: Any]) {
            if let userDefaults = UserDefaults(suiteName: "group.com.WidgetHeartLink") {
                userDefaults.set(feed["caption"] as? String ?? "", forKey: "caption")
                
                if let imageUrl = feed["image"] as? String {
                    userDefaults.set(imageUrl, forKey: "imageURL")
                }
            }
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
