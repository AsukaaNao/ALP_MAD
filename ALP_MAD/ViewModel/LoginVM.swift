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
            print("Error getting authenticated user UID: \(error.localizedDescription)")
            return
        }
        guard !uid.isEmpty else {
            print("UID is empty")
            return
        }
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            let data = document.data()
            self.hasCoupleId = data?["couple_id"] != nil
            print("Has couple ID: \(self.hasCoupleId)")
        }
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or password found")
            completion(false)
            return
        }
        Task {
            do {
                let userdata = try await AuthenticationManager.shared.signInWithEmailPassword(email: email, password: password)
                print("Success Login")
                print(userdata)
                checkCoupleId()
                completion(true)
            } catch {
                if let nsError = error as NSError? {
                    if let failureReason = nsError.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
                        print("Error during sign-in: \(failureReason)")
                    } else {
                        print("Error during sign-in: \(error.localizedDescription)")
                    }
                } else {
                    print("Error during sign-in: \(error.localizedDescription)")
                }
                self.errorMessage = "Error during sign-in: \(error.localizedDescription)"
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
        switch result {
        case .failure(let error):
            errorMessage = "Apple sign-in failed: \(error.localizedDescription)"
            print(errorMessage)
        case .success(let success):
            guard let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Unable to get Apple ID credential."
                print(errorMessage)
                return
            }
            
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
                    print("Apple sign-in succeeded: \(authResult.user.uid)")
                } catch {
                    self.errorMessage = "Error Authenticating with Apple: \(error.localizedDescription)"
                    print("Error Authenticating: \(error.localizedDescription)")
                }
            }
        }
    }
}
