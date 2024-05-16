//
//  ShareLocationView.swift
//  ALP_MAD
//
//  Created by student on 24/05/24.
//

import SwiftUI
import MapKit

struct ShareLocationView: View {
    
//    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {

        
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: viewModel.places){ place in
//                MapMarker(coordinate: place.coordinate, tint: .purple)
                MapAnnotation(coordinate: place.coordinate) {
                        // Content of the annotation
                        Image(systemName: place.systemImageName)
                            .font(.system(size: 16))
                            .foregroundColor(.purple)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width:30, height: 30)
                            )
                }
//                Marker("Test", image:"monument", coordinate: place.coordinate)
            }
            .mapControls{
                MapUserLocationButton()
                MapPitchToggle()
            }
            .onAppear{
                CLLocationManager().requestWhenInUseAuthorization()
            }
//            .overlay(
//                //custom map markers
//                ForEach(viewModel.places){place in
//                    MapAnnotation(coordinate: place.coordinate){
//                        Image(systemName: place.systemImageName)
//                            .font(.system(size: 16))
//                            .foregroundColor(.purple)
//                            .background(
//                                Circle()
//                                    .fill(.white)
//                                    .frame(width:30, height: 30)
//                        )
//                        
//                    }
//                }
//            )
            
        }
        
//        VStack{
//            Rectangle()
//                .frame(height: 2)
//                .foregroundColor(.purple)
//                .padding(.horizontal)
//            VStack(alignment: .leading){
//                HStack{
//                    Text("Giselle")
//                        .font(.headline)
//                    Spacer()
//                }
//                Text("Universitas Ciputra Surabaya, CitraLand CBD Boulevard, Made, Kec. Sambikerep, Surabaya, Jawa Timur 60219")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                Text("2 minutes ago")
//                    .font(.caption)
//                    .foregroundColor(.black)
//            }
//            .padding()
//            .background(.white)
//            .cornerRadius(10)
//            .shadow(radius:5)
//            .padding(.horizontal)
//            
//            HStack{
//                Button(action: {
//                    //                Action for Nudge
//                }){
//                    HStack{
//                        Image(systemName: "hand.point.right.fill")
//                            .foregroundColor(.purple)
//                        VStack(alignment: .leading){
//                            Text("Nudge")
//                                .font(.subheadline)
//                                .foregroundColor(.black)
//                            Text("send Giselle notification")
//                                .font(.subheadline)
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color(.white))
//                    .cornerRadius(10)
//                    
//                }
//                Button(action: {
//                    //                Action for Notification
//                }){
//                    HStack{
//                        Image(systemName: "bell.fill")
//                            .foregroundColor(.purple)
//                        VStack(alignment: .leading){
//                            Text("Notification")
//                                .font(.subheadline)
//                                .foregroundColor(.black)
//                            Text("View your shared notifications")
//                                .font(.subheadline)
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                    }
//                    .padding()
//                    .background(.white)
//                    .cornerRadius(10)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//        }
//        .background(Color(UIColor.systemGray6))

    }
}



#Preview {
    ShareLocationView()
}
