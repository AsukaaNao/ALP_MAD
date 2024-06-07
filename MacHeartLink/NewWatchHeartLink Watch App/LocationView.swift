//
//  LocationView.swift
//  NewWatchHeartLink Watch App
//
//  Created by MacBook Pro on 06/06/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct User: Identifiable {
    let id = UUID()
    let userName: String
    let profileImage: String
    let coordinate: CLLocationCoordinate2D
}

struct LocationView: View {
    @State private var region: MKCoordinateRegion
    
    let users: [User] = [
        User(userName: "Giselle 🐣💕", profileImage: "Giselle", coordinate: CLLocationCoordinate2D(latitude: -7.285601413011465, longitude: 112.63169657281418)),
        User(userName: "Kevin 🤠", profileImage: "Kevin", coordinate: CLLocationCoordinate2D(latitude: -7.295547020930878, longitude: 112.64996203619181))
    ]
    
    init() {
        let user1Coordinate = CLLocationCoordinate2D(latitude: -7.285601413011465, longitude: 112.63169657281418)
        let user2Coordinate = CLLocationCoordinate2D(latitude: -7.295547020930878, longitude: 112.64996203619181)
        
        let midLatitude = (user1Coordinate.latitude + user2Coordinate.latitude) / 2
        let midLongitude = (user1Coordinate.longitude + user2Coordinate.longitude) / 2
        let centerCoordinate = CLLocationCoordinate2D(latitude: midLatitude, longitude: midLongitude)
        
        let latitudeDelta = abs(user1Coordinate.latitude - user2Coordinate.latitude) * 1.5
        let longitudeDelta = abs(user1Coordinate.longitude - user2Coordinate.longitude) * 1.5
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        _region = State(initialValue: MKCoordinateRegion(center: centerCoordinate, span: span))
    }
    
    var distance: String {
        let location1 = CLLocation(latitude: users[0].coordinate.latitude, longitude: users[0].coordinate.longitude)
        let location2 = CLLocation(latitude: users[1].coordinate.latitude, longitude: users[1].coordinate.longitude)
        let distanceInMeters = location1.distance(from: location2)
        let distanceInKilometers = distanceInMeters / 1000
        return String(format: "%.2f km", distanceInKilometers)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: users) { user in
                    MapAnnotation(coordinate: user.coordinate) {
                        VStack {
                            Image(user.profileImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all) // Make the map take full screen space
                .overlay(
                    Text("\(distance) between \nGiselle 🐣💕 and Kevin 🤠")
                        .font(.system(size: 12))
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.bottom, -15), // Adjust bottom padding to move text closer to the bottom
                    alignment: .bottom
                )
            }
            .navigationTitle("Location")
        }
    }
}

#Preview {
    LocationView()
}

