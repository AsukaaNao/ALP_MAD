import SwiftUI
import Cocoa

struct ImagePicker: View {
    
    @Binding var selectedImage: NSImage?
    @Binding var isPickerShowing: Bool
    
    var body: some View {
        Button("Select Image") {
            let panel = NSOpenPanel()
            panel.allowedFileTypes = ["jpg", "jpeg", "png"]
            panel.canChooseFiles = true
            panel.canChooseDirectories = false
            panel.allowsMultipleSelection = false
            panel.begin { response in
                if response == .OK {
                    guard let url = panel.url else { return }
                    if let image = NSImage(contentsOf: url) {
                        selectedImage = image
                    }
                }
            }
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(selectedImage: .constant(nil), isPickerShowing: .constant(false))
    }
}
