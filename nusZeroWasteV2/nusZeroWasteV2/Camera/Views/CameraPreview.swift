//
//  CameraPreview.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @Binding var cameraVM: CameraViewModel
    let frame: CGRect
    
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: frame)
        cameraVM.preview = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.preview.frame = frame
        cameraVM.preview.videoGravity = .resizeAspectFill
        let orientation = UIDevice.current.orientation
        cameraVM.preview.connection?.videoRotationAngle = orientation.videoRotationAngle
        view.layer.addSublayer(cameraVM.preview)
        return view
    }
    
    func updateUIView(_ uiview: UIViewType, context: Context) {
        cameraVM.preview.frame = frame
        cameraVM.preview.connection?.videoRotationAngle = UIDevice.current.orientation.videoRotationAngle
    }
}
