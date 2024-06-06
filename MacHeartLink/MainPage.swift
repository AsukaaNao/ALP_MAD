//
//  MainPage.swift
//  MacHeartlink
//
//  Created by student on 06/06/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    //    var user: User
}

struct UserAnnotationView: View {
    var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
            Text("User")
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

struct MainPage: View {
    @StateObject private var viewModel = MainPageViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) var dismiss
    
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
                    VStack(spacing: 10) {  // Adjust spacing as needed
                        Button("Log Out") {
                            Task {
                                do {
                                    try viewModel.signOut()
                                    showSignInView = true
                                    dismiss()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        .frame(width: 100, height: 33) // Adjust width to fit Mac
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        UserInfoView()
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding()
                            .shadow(radius: 10)
                    }
                }
                .padding()
            }
            .ignoresSafeArea()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Location Permission"),
                    message: Text(viewModel.alertMessage),
                    primaryButton: .default(Text("Settings")) {
                        if let settingsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices") {
                            NSWorkspace.shared.open(settingsURL)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
}

struct UserInfoView: View {
    var body: some View {
        VStack (alignment:.leading){
            Text("Giselle")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Pakuwon Mall")
                .font(.caption)
                .foregroundColor(Color.gray)
            
            Text("3 minutes ago")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Spacer().frame(height: 10)
            
            HStack {
                Button(action: {
                    // Nudge action
                }) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                            .foregroundColor(.blue)
                        Text("Nudge")
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                Button(action: {
                    // View notifications action
                }) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.blue)
                        Text("Notification")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            
            Spacer().frame(height: 0)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        MainPage(showSignInView: .constant(true))
    }
}

