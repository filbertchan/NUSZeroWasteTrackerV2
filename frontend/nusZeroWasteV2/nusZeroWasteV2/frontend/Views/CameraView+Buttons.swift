//
//  CameraView+Buttons.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

extension CameraView{
    var usePhotoButton: some View {
        ControlButtonView(label: "Use Photo") {
            // use photo
            imageData = VM.photoData
            showCamera = false
        }
    }
    
    var retakeButton: some View {
        ControlButtonView(label: "Retake") {
            // retake photo
            VM.retakePhoto()
        }
    }
    
    var cancelButton: some View {
        ControlButtonView(label: "Cancel") {
            showCamera = false
        }
    }
    
    var photoCaptureButton: some View {
        Button {
            // take photo
            VM.takePhoto()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 65)
                Circle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 75)
                
            }
        }
    }
}

#Preview {
    CameraView(imageData: .constant(nil), showCamera: .constant(true))
}
