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
