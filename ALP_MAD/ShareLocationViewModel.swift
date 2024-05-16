//
//  ShareLocationViewModel.swift
//  ALP_MAD
//
//  Created by student on 24/05/24.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject{
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.260, longitude: 112.747373),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    let places = [
        Place(name: "Pakuwon Mall", coordinate: CLLocationCoordinate2D(latitude: -7.260843, longitude: 112.7847373), systemImageName: "building.2.fill")
    ]
}
