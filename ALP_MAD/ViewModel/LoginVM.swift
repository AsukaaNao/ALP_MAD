//
//  LoginVM.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 16/05/24.
//

import Foundation
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import FirebaseFirestore

fileprivate var currentNonce: String?

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
        fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
    }
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
    }
    
    return String(nonce)
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

class LoginVM: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var hasCoupleId = false
    
    var db = Firestore.firestore()
    
    func checkCoupleId() {
        var uid = ""
        do {
            let fetchUID = try AuthenticationManager.shared.getAuthenticatedUser().uid
            uid = fetchUID
        } catch {
            print("Error getting authenticated user UID")
        }
        guard uid != "" else {
            return
        }
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                print(data!)
                self.hasCoupleId = data?["couple_id"] != nil
                print(self.hasCoupleId)
            } else {
                print("User document does not exist")
            }
        }
    }
    
//    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) {
//        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
//
//        } else {
//            let changeRequest = user.createProfileChangeRequest()
//            changeRequest.displayName = appleIDCredential.displayName()
//
//        }
//    }
    
    func signIn(completion: @escaping (Bool) -> Void){
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or password found")
            return
        }
        Task {
            do{
                let userdata = try await AuthenticationManager.shared.signInWithEmailPassword(email: email, password: password)
                print("Success Login")
                print(userdata)
                checkCoupleId()
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize identity token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                Task {
                    do {
                        let authResult = try await Auth.auth().signIn(with: credential)
    //                    self.user = authResult.user
    //                    self.authenticationState = .authenticated
                    } catch {
                        self.errorMessage = error.localizedDescription
                        print("Error Authenticating: \(error.localizedDescription)")
    //                    self.authenticationState = .unauthenticated
                    }
                }
            }
        }
    }
}
