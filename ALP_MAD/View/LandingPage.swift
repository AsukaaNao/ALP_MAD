import SwiftUI

struct LandingPage: View {
    
    @State var viewModel = LandingPageVM()
    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    @State var name: String = ""
    @State var tags: String = "#612HBJ"
    
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Heartlink")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.purple, lineWidth: 4))
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 200, height: 200)
                    .overlay(Circle().stroke(Color.purple, lineWidth: 4))
            }
            
            Button(action: {
                isPickerShowing = true
            }) {
                Text("Select a Photo")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            
            if let selectedImage = selectedImage {
                Button(action: {
                    viewModel.uploadPhoto(selectedImage)
                }) {
                    Text("Upload Photo")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.headline)
                
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Text("Tags")
                    .font(.headline)
                
                TextField("#612HBJ", text: $tags)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                // Continue action
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, sourceType: sourceType)
//            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
}

#Preview {
    LandingPage()
}
