//
//  ShareLocationModel.swift
//  ALP_MAD
//
//  Created by student on 24/05/24.
//

import Foundation
import MapKit

struct Place: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let systemImageName: String //Add systemImageName for markers
}
