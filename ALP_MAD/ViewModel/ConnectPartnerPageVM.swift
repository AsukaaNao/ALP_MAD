import SwiftUI
import Firebase
import FirebaseStorage
import Combine

struct UserRequest: Identifiable {
    let id: String
    let uid: String
    let name: String
    let tag: String
    var profilePicture: UIImage?
}

class ConnectPartnerPageVM: ObservableObject {
    @Published var userRequests: [UserRequest] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        fetchUserRequests()
//        userRequests.append(UserRequest(id: "", uid: "", name: "Dummy", tag: "LOM4RE", profilePicture: nil))

    }
    
    func fetchUserRequests() {
        guard let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            return
        }
        
        db.collection("users").document(uid).collection("requests").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching user requests: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No user requests found")
                return
            }
            
            self.userRequests = documents.compactMap { doc -> UserRequest? in
                let data = doc.data()
                let id = doc.documentID
                let uid = data["uid"] as? String ?? "" // Assuming 'uid' field exists in request document
                let name = data["name"] as? String ?? "Unknown"
                let tag = data["tag"] as? String ?? ""
                let profilePicturePath = data["profilePicture"] as? String ?? ""
                
                let request = UserRequest(id: id, uid: uid, name: name, tag: tag, profilePicture: nil)
                
                self.fetchProfilePicture(for: request, path: profilePicturePath)
                
                return request
            }
        }
    }
    
    func fetchProfilePicture(for request: UserRequest, path: String) {
        let fileRef = storage.reference(withPath: path)
        fileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading profile picture: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                if let index = self.userRequests.firstIndex(where: { $0.id == request.id }) {
                    self.userRequests[index].profilePicture = image
                }
            }
        }
    }
    
    func acceptRequest(_ request: UserRequest) {
        guard let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            return
        }
        
        // Create couple document
        let coupleData: [String: Any] = [
            "user_1": uid,
            "user_2": request.uid,
            "created_at": Timestamp()
        ]
        
        db.collection("couples").addDocument(data: coupleData) { error in
            if let error = error {
                print("Error creating couple document: \(error)")
                return
            }
            
            // Retrieve the document ID of the new couple document
            self.db.collection("couples")
                .order(by: "created_at", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error getting couples documents: \(error)")
                        return
                    }
                    
                    guard let document = querySnapshot?.documents.first else {
                        print("No couple documents found")
                        return
                    }
                    
                    let coupleID = document.documentID
                    
                    // Update couple_id on both users
                    let userUpdates = [
                        "couple_id": coupleID
                    ]
                    
                    let group = DispatchGroup()
                    
                    print("\(coupleID) id generated (couple)")
                    print("\(uid) : uid")
                    print("\(request.uid) : requester id")
                    
                    group.enter()
                    self.db.collection("users").document(uid).updateData(userUpdates) { error in
                        if let error = error {
                            print("Error updating user couple_id: \(error)")
                        }
                        group.leave()
                    }
                    
                    group.enter()
                    self.db.collection("users").document(request.uid).updateData(userUpdates) { error in
                        if let error = error {
                            print("Error updating partner couple_id: \(error)")
                        }
                        group.leave()
                    }
                    
                    // Delete the request after creating the couple document and updating the users
                    group.notify(queue: .main) {
                        self.db.collection("users").document(uid).collection("requests").document(request.id).delete { error in
                            if let error = error {
                                print("Error deleting request: \(error)")
                                return
                            }
                            self.userRequests.removeAll { $0.id == request.id }
                        }
                    }
                }
        }
    }
    
    func rejectRequest(_ request: UserRequest) {
        guard let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            return
        }
        
        db.collection("users").document(uid).collection("requests").document(request.id).delete { error in
            if let error = error {
                print("Error deleting request: \(error)")
                return
            }
            self.userRequests.removeAll { $0.id == request.id }
        }
    }
    
    func requestPartner() {
        // Implement the request partner logic here
    }
}
