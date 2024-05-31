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
                
                //                            if let selectedUser = viewModel.selectedUser {
                //                                UserInfoView(user: selectedUser)
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
                UserInfoView()
                    .background(Color.white)
                    .cornerRadius(15)
                //                        .padding()
                    .shadow(radius: 10)
                //                            }
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

struct UserInfoView: View {
    //    var user: User
    
    var body: some View {
        VStack (alignment:.leading){
            Text("Giselle")
                .font(.headline)
                .fontWeight(.bold)
            
            
            //            Text(user.name)
            //                .font(.headline)
            //            Text(user.address)
            //                .font(.subheadline)
            Text("Pakuwon Mall")
                .font(.caption)
                .foregroundColor(Color.gray)
            
            //            Text("\(user.timeAgo) ago")
            //                .font(.caption)
            //                .foregroundColor(.gray)
            Text("3 minutes ago")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Spacer()
                .frame(height: 20)
            
            HStack {
                Button(action: {
                    // Nudge action
                }) {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("Nudge")
                    }
                }
                Spacer()
                Button(action: {
                    // View notifications action
                }) {
                    HStack {
                        Image(systemName: "bell")
                        Text("Notification")
                    }
                }
            }
            .padding()
            Spacer()
                .frame(height: 50)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        MainPage(showSignInView: .constant(true))
    }
}
