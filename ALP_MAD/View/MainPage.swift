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
                        .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                        .shadow(radius: 3)
                        .offset(y: -23)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 46, height: 46)
                        .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                        .shadow(radius: 3)
                        .offset(y: -23)
                }
            }
            Text(userName)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.purple.opacity(0.75))
                .clipShape(Capsule())
                .shadow(radius: 2)
                .offset(y: -20)
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
            .edgesIgnoringSafeArea(.top)
            .accentColor(Color(.systemPink))
            .onAppear {
                viewModel.checkIfLocationServiceIsEnabled()
                viewModel.getUserUID()
            }
            .onDisappear {
                viewModel.stopUpdatingLocation()
                viewModel.stopFetchingLocations()
            }
            VStack(alignment: .trailing) {
                Spacer()
                
                Menu {
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
                } label: {
                    Image(systemName: "gear")
                        .foregroundColor(.purple)
                        .imageScale(.large)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.purple.opacity(0.5) ,radius: 5)
                }
                .padding(.trailing)
                
                UserInfoView(
                    userName: viewModel.partner.name,
                    userLocation: viewModel.partner.location.latitude != 0.0 && viewModel.partner.location.longitude != 0.0 ? "\(viewModel.partner.location.latitude), \(viewModel.partner.location.longitude)" : "Unknown Location"
                )
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.purple.opacity(0.4), radius: 10)
                .padding()
                
            }
            .padding()
        }
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
        .navigationBarBackButtonHidden(true)
    }
}


struct UserInfoView: View {
    var userName: String
    var userLocation: String
    
    @State private var isNudging: Bool = false
    @State private var showComingSoon = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(userName)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 10)
            
            Text(userLocation)
                .font(.caption)
                .foregroundColor(Color.gray)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isNudging = true
                    }
                    withAnimation(Animation.easeInOut(duration: 0.3).delay(0.5)) {
                        self.isNudging = false
                    }
                    // Nudge action
                }) {
                    HStack {
                        Image(systemName: isNudging ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .rotationEffect(.degrees(isNudging ? -45 : 0))
                            .foregroundColor(.purple)
                        Text("Nudge")
                            .foregroundStyle(.purple)
                    }
                    .scaleEffect(isNudging ? 1.5 : 1.0)
                }
                Spacer()
                Button(action: {
                    // View notifications action
                    showComingSoon = true
                }) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.purple)
                        Text("Notification")
                            .foregroundStyle(.purple)
                    }
                }
            }
            .padding()
            //            Spacer()
            //                .frame(height: 10)
        }
        .padding(30)
        .alert(isPresented: $showComingSoon) {
            Alert(
                title: Text("Coming Soon!"),
                message: Text("This feature is not available yet."),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
    
}

#Preview {
    NavigationStack {
        MainPage(showSignInView: .constant(true))
    }
}
