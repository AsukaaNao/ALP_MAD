//
//  AuthenticationManager.swift
//  MAD_ALP
//
//  Created by MacBook Pro on 16/05/24.
//

import Foundation
import FirebaseAuth
#if canImport(UIKit)
#endif

struct AuthDataResultModel {
    let uid : String
    let email : String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

//struct FeedDataResultModel {
//    let image: UIImage
//    let caption: String
//    
//    init(feed: Feed) {
//        self.image = feed.image
//        self.caption = feed.caption
//    }
//}

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws -> AuthDataResultModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: result.user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    
    
//    func createFeed(image: UIImage, caption: String) async throws -> FeedDataResultModel {
//        let feedDataResult = try await Auth.auth().createFeed(caption: caption)
//        return FeedDataResultModel(feed: feedDataResult.feed)
//    }
}
    

