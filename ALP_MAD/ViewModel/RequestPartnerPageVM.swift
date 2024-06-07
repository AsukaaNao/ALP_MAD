import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class RequestPartnerPageVM: ObservableObject {
    @Published var foundUser: User1?
    @Published var isLoading = false
    @Published var requestSent = false
    @Published var profilePicture: UIImage?
    private var cancellables = Set<AnyCancellable>()
    private var db = Firestore.firestore()
    
    func searchUser(by tag: String) {
        isLoading = true
        
        db.collection("users").whereField("tag", isEqualTo: tag).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error searching for user: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            if let documents = querySnapshot?.documents, let document = documents.first {
                do {
                    var user = try document.data(as: User1.self)
                    print(user)
                    self.foundUser = user
                    if let profilePictureUrl = user.profilePicture {
                        self.downloadProfilePicture(from: profilePictureUrl)
                    }
                } catch let error {
                    print("Error decoding user: \(error.localizedDescription)")
                }
            } else {
                self.foundUser = nil
            }
            
            self.isLoading = false
        }
    }
    
    private func downloadProfilePicture(from path: String) {
        let storageRef = Storage.storage().reference(withPath: path)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading profile picture: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profilePicture = image
                }
            }
        }
    }
    
    func sendRequest(to user: User1) {
        guard let userID = user.id else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("users").document(currentUser.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if let currentUserData = try document.data(as: User1?.self) {
                        let requestData: [String: Any] = [
                            "uid": currentUserData.id ?? "",
                            "name": currentUserData.name,
                            "tag": currentUserData.tag,
                            "profilePicture": currentUserData.profilePicture ?? "ndak muncul"
                        ]
                        
                        self.db.collection("users").document(userID).collection("requests").addDocument(data: requestData) { error in
                            if let error = error {
                                print("Error sending request: \(error.localizedDescription)")
                            } else {
                                self.requestSent = true
                            }
                        }
                    }
                } catch {
                    print("Error decoding current user: \(error.localizedDescription)")
                }
            } else {
                print("Current user document does not exist")
            }
        }
    }
}

struct User1: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let tag: String
    let profilePicture: String?
}
