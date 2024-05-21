import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpVM: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    private let db = Firestore.firestore()
    
    func signUp(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or password found")
            completion(false)
            return
        }
        
        Task {
            do {
                let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                let uid = authResult.uid
                
                let userData: [String: Any] = [
                    "email": email,
                    "location": GeoPoint(latitude: 0.0, longitude: 0.0) // Dummy location, update as needed
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
