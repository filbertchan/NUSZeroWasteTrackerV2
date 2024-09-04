import SwiftUI

class SharedState: ObservableObject {
    @Published var location: String = "Not Selected"
    @Published var selectedOption: DropdownMenuOption? = nil
}

struct ContentView: View {
    
    @State private var imageData: Data? = nil
    @State var showCamera: Bool = false
    @State private var detectedWeight: String = "0"
    
    @ObservedObject var sharedState = SharedState()
    
    let placeholder: String
    let options: [DropdownMenuOption]
    
    var body: some View {
        VStack {
            if imageData != nil, let uiImage = UIImage(data: imageData!) {
                VStack {
                    ZStack {
                        VStack {
                            Spacer().frame(height: 130)
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
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

                        VStack {
                            DropdownMenu(
                                visible: true,
                                selectedOption: $sharedState.selectedOption,
                                location: $sharedState.location,
                                placeholder: placeholder,
                                options: options
                            )
                            .zIndex(1)
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    print("POST image to backend")
                    processImage(image: uiImage)
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

    
    func processImage(image: UIImage) {
        guard let imageData = image.pngData() else { return }
        
        detectDigit(imageData: imageData) { result in
            switch result {
            case .success(let ocrResult):
                DispatchQueue.main.async {
                    if let firstResult = ocrResult.first {
                        // Convert the result to a string and assign it
                        self.detectedWeight = "\(firstResult)"
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView(
        placeholder: "Select station...",
        options: DropdownMenuOption.stationList
    )
}
