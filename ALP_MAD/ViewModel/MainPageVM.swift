import Foundation
import MapKit
import FirebaseFirestore
import FirebaseStorage

final class MainPageViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var UID: String? = ""  // Private setter to control modification
    @Published var hasCoupleId: Bool = false
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.28522, longitude: 112.63184),
        span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var userLocations: [IdentifiableCoordinate] = []
    @Published var coupleUsers: [String: String] = [:] // Dictionary to store user IDs and their names
    
    var locationManager: CLLocationManager?
    private var updateLocationTimer: Timer?
    private var fetchLocationsTimer: Timer?
    private var couple_id = ""
    
    private var db = Firestore.firestore()
    
    override init() {
        super.init()
        checkIfLocationServiceIsEnabled()
    }
    
    func initializeLocationUpdates() {
        startUpdatingLocation()
        startFetchingLocations(couple_id: self.couple_id)
    }
    
    func getUserUID() {
        do {
            let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
            self.UID = uid
            print("UID main page: \(uid)")
            fetchCoupleId(for: uid)  // Fetch couple_id when user is authenticated
            initializeLocationUpdates()
        } catch {
            print("Error getting authenticated user UID: \(error)")
        }
    }
    
    func checkIfLocationServiceIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show alert location is off")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertMessage = "Your location is restricted likely due to parental control."
            showAlert = true
        case .denied:
            alertMessage = "Location permission has been turned off. Please enable it in Settings."
            showAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.location {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                do {
                    let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
                    self.UID = uid
                } catch {
                    print("Error getting authenticated user UID")
                }
                fetchCoupleId(for: self.UID!)
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        self.UID = ""
        self.hasCoupleId = false
        self.couple_id = ""
        print("User logged out, UID is now: \(String(describing: self.UID))")
    }
    
    func fetchCoupleId(for userId: String) {
        guard !userId.isEmpty else {
            print("userId is empty")
            return
        }
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let document = document, document.exists {
                if let coupleId = document.data()?["couple_id"] as? String {
                    self.hasCoupleId = true
                    self.couple_id = coupleId
                    self.fetchUserUIDs()
                } else {
                    self.hasCoupleId = false
                }
            } else {
                print("User document does not exist")
            }
        }
    }
    
    func fetchUserUIDs() {
        guard self.UID != "" else {
            print("user not logged in")
            return
        }
        db.collection("users").document(self.UID!).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let document = document, document.exists {
                if let coupleId = document.data()?["couple_id"] as? String {
                    self.couple_id = coupleId
                    self.hasCoupleId = true
                } else {
                    self.hasCoupleId = false
                }
            } else {
                print("User document does not exist")
            }
        }
        print("coupleID : \(self.couple_id)")
        
        guard couple_id != "" else {
            return
        }
        
        db.collection("couples").document(self.couple_id).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            var userUIDs: [String] = []
            if let document = document, document.exists {
                let data = document.data()
                if let user1 = data?["user_1"] as? String, let user2 = data?["user_2"] as? String {
                    userUIDs.append(user1)
                    userUIDs.append(user2)
                }
            } else {
                print("Document does not exist")
            }
            
            print("User UID \(userUIDs)")
            
            self.fetchUserDetails(userUIDs: userUIDs)
        }
    }
    
    func downloadProfilePicture(from path: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: path)
        
        // Create a temporary file URL to store the downloaded data
        let temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        
        // Download the file in chunks and write to the temporary file
        let downloadTask = storageRef.write(toFile: temporaryFileURL) { url, error in
            if let error = error {
                print("Error downloading profile picture: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let url = url {
                    do {
                        // Read the data from the temporary file
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        completion(image)
                    } catch {
                        print("Error creating UIImage from downloaded data: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            }
        }
    }

    func fetchUserDetails(userUIDs: [String]) {
        db.collection("users").whereField(FieldPath.documentID(), in: userUIDs).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            var locations: [IdentifiableCoordinate] = []
            var userDict: [String: String] = [:]
            
            for document in querySnapshot!.documents {
                let data = document.data()
                if let geoPoint = data["location"] as? GeoPoint,
                   let userName = data["name"] as? String, // Ensure you have the user's name
                   let profilePicturePath = data["profilePicture"] as? String { // Ensure you have the profile picture path
                    let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                    var identifiableCoordinate = IdentifiableCoordinate(coordinate: coordinate, userName: userName)
                    
                    self.downloadProfilePicture(from: profilePicturePath) { image in
                        DispatchQueue.main.async {
                            identifiableCoordinate.profileImage = image
                            userDict[document.documentID] = userName
                            self.userLocations.append(identifiableCoordinate)
                        }
                    }
                }
            }
            
            self.coupleUsers = userDict
            self.userLocations = locations
        }
    }
    
    func startUpdatingLocation() {
        print("Starting to update location with UID: \(String(describing: self.UID))")
        
        updateLocationTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.updateUserLocation()
        }
    }
    
    func startFetchingLocations(couple_id: String) {
        fetchLocationsTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.fetchUserUIDs()
        }
    }
    
    func stopUpdatingLocation() {
        updateLocationTimer?.invalidate()
        updateLocationTimer = nil
    }
    
    func stopFetchingLocations() {
        fetchLocationsTimer?.invalidate()
        fetchLocationsTimer = nil
    }
    
    func updateUserLocation() {
        do {
            let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
            self.UID = uid
        } catch {
            print("Error getting authenticated user UID")
        }
        print("Attempting to update location with UID: \(String(describing: self.UID))")
        
        guard let uid = self.UID, !uid.isEmpty else {
            print("No valid UID, skipping location update")
            return
        }
        
        guard let location = locationManager?.location else {
            print("Location manager or location not available")
            return
        }
        
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        db.collection("users").document(uid).updateData([
            "location": geoPoint
        ]) { error in
            if let error = error {
                print("Error updating location: \(error)")
            } else {
                print("User location updated successfully")
            }
        }
    }
    
    deinit {
        stopUpdatingLocation()
        stopFetchingLocations()
    }
}
