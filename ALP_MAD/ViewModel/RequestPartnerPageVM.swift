import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class RequestPartnerPageVM: ObservableObject {
    @Published var foundUser: User1?
    @Published var isLoading = false
    @Published var requestSent = false
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
//            print(querySnapshot?.documents ?? "Busi")
            if let documents = querySnapshot?.documents, let document = documents.first {
                do {
                    self.foundUser = try document.data(as: User1.self)
                } catch let error {
                    print("Error decoding user: \(error.localizedDescription)")
                }
            } else {
                self.foundUser = nil
            }
            
            self.isLoading = false
        }
    }
    
    func sendRequest(to user: User1) {
        print("user : \(user)")
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
                            "profilePictureUrl": currentUserData.profilePictureUrl ?? ""
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
    let profilePictureUrl: String?
}
