//
//  CameraView.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

struct CameraView: View {
    
    @Environment(\.verticalSizeClass) var vertiSizeClass
    
    @State internal var VM = CameraViewModel()
    @State var birthMonth: DropdownMenuOption? = nil
    
    @ObservedObject var sharedState = SharedState()
    
    @Binding var imageData: Data?
    @Binding var showCamera: Bool
    
    let controlButtonWidth: CGFloat = 140
    let controlFrameHeight: CGFloat = 100
    
    var isLandscape: Bool { vertiSizeClass == .compact }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                HStack {
                    cameraPreview
                    if isLandscape {
                        verticalControlBar
                            .frame(width: controlFrameHeight)
                    }
                }
                if !isLandscape {
                    horizontalControlBar
                        .frame(height: controlFrameHeight)
                    
                }
            }
        }
    }
    
    private var cameraPreview: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer()
                        .frame(height: 90)
                    CameraPreview(cameraVM: $VM, frame: CGRect(x: 0, y: 0, width: geo.size.width, height: geo.size.height - 90))
                        .onAppear() {
                            VM.requestAccessAndSetup()
                        }
                }
                Rectangle()
                    .fill(Color.clear)
                    .stroke(Color.red, lineWidth: 5) // Color of the rectangle
                    .frame(width: 350, height: 250) // Width and height of the rectangle
                    .position(x: geo.size.width / 2, y: geo.size.height / 2) // Center of the view
                    .opacity(1)
            }
            .edgesIgnoringSafeArea(.bottom) // Optional: Ignore safe area if needed
        }
    }
}

#Preview {
    CameraView(imageData: .constant(nil), showCamera: .constant(true))
}
