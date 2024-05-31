import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpVM: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    private let db = Firestore.firestore()
    
    func generateTag() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var tag = ""
        for _ in 0..<6 {
            if let randomChar = characters.randomElement() {
                tag.append(randomChar)
            }
        }
        return tag
    }
    
    func signUp(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else {
            print("No Email or password found")
            completion(false)
            return
        }
        
        Task {
            do {
                let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                let uid = authResult.uid
                
                let userData: [String: Any] = [
                    "username": username,
                    "email": email,
                    "location": GeoPoint(latitude: 0.0, longitude: 0.0), // Dummy location, update as needed
                    "tag": generateTag()
                ]
                
                try await db.collection("users").document(uid).setData(userData)
                
                print("Success Create User and Added to Firestore")
                print(authResult)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
