import SwiftUI

class SharedState: ObservableObject {
    @Published var location: String = "Not Selected"
    @Published var selectedOption: DropdownMenuOption? = nil
}

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    @State private var imageData: Data? = nil
    @State var showCamera: Bool = false
    @State private var detectedWeight: String = "160"
    
    @ObservedObject var sharedState = SharedState()
    
    let placeholder: String
    let options: [DropdownMenuOption]
    
    var body: some View {
        VStack {
            if imageData != nil, let uiImage = UIImage(data: imageData!) {
                VStack {
                    ZStack {
                        // This is where the image and other views go
                        VStack {
                            Spacer().frame(height: 130) // Set the desired width
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit() // This maintains the aspect ratio
                                .zIndex(0)
                            Text("Detected Weight:")
                                .padding()
                                .font(.largeTitle)
                            TextField("", text: $detectedWeight)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .font(.largeTitle)
                            Button("Confirm") {
                                // send data to server
                                imageData = nil
                            }
                            .font(.largeTitle)
                        }

                        // DropdownMenu is placed on top using ZStack
                        VStack {
                            DropdownMenu(
                                visible: true,
                                selectedOption: $sharedState.selectedOption, // Bind to sharedState.selectedOption
                                location: $sharedState.location, // Bind to sharedState.location
                                placeholder: placeholder,
                                options: options
                            )
                            .zIndex(1) // Ensure DropdownMenu is on top
                            Spacer()
                        }
                    }
                }
            } else {
                Image(.zeroWasteLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Button("Take Photo") {
                    showCamera = true
                }
                .font(.largeTitle)
                .padding()
            }
        }
        .padding()
        .fullScreenCamera(isPresented: $showCamera, imageData: $imageData)
    }
}

#Preview {
    ContentView(
        placeholder: "Select station...",
        options: DropdownMenuOption.stationList
    )
}
