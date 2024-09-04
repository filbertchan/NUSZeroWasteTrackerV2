//
//  View+.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

extension View {
    func fullScreenCamera(isPresented: Binding<Bool>, imageData: Binding<Data?>) -> some
        View {
        self
            .fullScreenCover(isPresented: isPresented, content: {
                CameraView(imageData: imageData, showCamera: isPresented)
            })
    }
}
