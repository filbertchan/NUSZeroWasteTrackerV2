//
//  CamreView+VerticalControlBar.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

extension CameraView {
    @ViewBuilder var verticalControlBar: some View {
        if VM.hasPhoto {
            verticalControlBarPostPhoto
        } else {
            verticalControlBarPrePhoto
        }
    }
    
    var verticalControlBarPrePhoto: some View {
        VStack {
            Spacer()
                .frame(width: controlButtonWidth)
            Spacer()
            photoCaptureButton
            Spacer()
            cancelButton
                .frame(height: controlButtonWidth)
        }
    }
    
    var verticalControlBarPostPhoto: some View {
        VStack {
            usePhotoButton
                .frame(height: controlButtonWidth)
            Spacer()
            retakeButton
                .frame(height: controlButtonWidth)
        }
    }
}

#Preview {
    CameraView(imageData: .constant(nil), showCamera: .constant(true))
}
