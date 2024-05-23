//
//  MainPage.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 16/05/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct UserAnnotationView: View {
    var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
            Text("User")
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

final class MainPageViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var UID: String? = ""
    
    var locationManager: CLLocationManager?
    private var updateLocationTimer: Timer?
    private var fetchLocationsTimer: Timer?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.28522, longitude: 112.63184),
        span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var userLocations: [IdentifiableCoordinate] = []
    
    private var db = Firestore.firestore()
    
    override init() {
        super.init()
        checkIfLocationServiceIsEnabled()
    }
    
    func getUserUID() {
        do {
            let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
            UID = uid
            print("UID main page \(uid)")
            startUpdatingLocation()
            startFetchingLocations()
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
                fetchUserUIDs()
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
    }
    
    func fetchUserUIDs() {
        db.collection("couples").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            var userUIDs: [String] = []
            
            for document in querySnapshot!.documents {
                let data = document.data()
                if let user1 = data["user_1"] as? String, let user2 = data["user_2"] as? String {
                    userUIDs.append(user1)
                    userUIDs.append(user2)
                }
            }
            
            self.fetchUserLocations(userUIDs: userUIDs)
        }
    }
    
    func fetchUserLocations(userUIDs: [String]) {
        db.collection("users").whereField(FieldPath.documentID(), in: userUIDs).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            var locations: [IdentifiableCoordinate] = []
            
            for document in querySnapshot!.documents {
                let data = document.data()
                if let geoPoint = data["location"] as? GeoPoint {
                    let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                    let identifiableCoordinate = IdentifiableCoordinate(coordinate: coordinate)
                    locations.append(identifiableCoordinate)
                }
            }
            
            self.userLocations = locations
        }
    }
    
    func startUpdatingLocation() {
        updateLocationTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateUserLocation()
        }
    }
    
    func startFetchingLocations() {
        fetchLocationsTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
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
        guard let location = locationManager?.location, let uid = UID else { return }
        
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

struct MainPage: View {
    @StateObject private var viewModel = MainPageViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.userLocations) { location in
                MapMarker(coordinate: location.coordinate, tint: .red)
            }
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear {
                viewModel.checkIfLocationServiceIsEnabled()
                viewModel.getUserUID()
            }
            .onDisappear {
                viewModel.stopUpdatingLocation()
                viewModel.stopFetchingLocations()
            }
            
            VStack {
                Spacer()
                
                VStack {
                    List {
                        Button("Log Out") {
                            Task {
                                do {
                                    try viewModel.signOut()
                                    showSignInView = true
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25)
                    .opacity(0.7)
                }
                .background(RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 10))
                .padding(.bottom, 20)
            }
            .padding()
        }
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Location Permission"),
                message: Text(viewModel.alertMessage),
                primaryButton: .default(Text("Settings")) {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    NavigationStack {
        MainPage(showSignInView: .constant(true))
    }
}
