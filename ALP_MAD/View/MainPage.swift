import SwiftUI
import MapKit

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var userName: String
    var profileImage: UIImage? = nil
}

struct UserAnnotationView: View {
    var userName: String
    var profileImage: UIImage?
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Pin shape
//                Path { path in
//                    let width: CGFloat = 50
//                    let height: CGFloat = 70
//                    let tailHeight: CGFloat = 20
//                    
//                    path.move(to: CGPoint(x: width / 2, y: 0))
//                    path.addArc(center: CGPoint(x: width / 2, y: width / 2), radius: width / 2, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
//                    path.addLine(to: CGPoint(x: width / 2 - 10, y: height - tailHeight))
//                    path.addQuadCurve(to: CGPoint(x: width / 2 + 10, y: height - tailHeight), control: CGPoint(x: width / 2, y: height))
//                    path.addLine(to: CGPoint(x: width / 2, y: width))
//                }
//                .fill(Color.red)
                
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 46, height: 46)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 3)
                        .offset(y: -23)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 46, height: 46)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 3)
                        .offset(y: -23)
                }
            }
            Text(userName)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.black.opacity(0.75))
                .clipShape(Capsule())
                .shadow(radius: 2)
                .offset(y: -5)
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
                //                MapMarker(coordinate: location.coordinate, tint: .red)
                MapAnnotation(coordinate: location.coordinate) {
                    UserAnnotationView(userName: location.userName, profileImage: location.profileImage)
                }
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
                .frame(width: UIScreen.main.bounds.width * 0.25, height: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                ForEach(viewModel.coupleUsers.keys.sorted(), id: \.self) { userId in
                    if let userName = viewModel.coupleUsers[userId] {
                        UserInfoView(userName: userName, userLocation: "Unknown Location") // Replace with actual location if available
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding()
                    }
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
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarHidden(false)
    }
}


struct UserInfoView: View {
    var userName: String
    var userLocation: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(userName)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(userLocation)
                .font(.caption)
                .foregroundColor(Color.gray)
            
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
