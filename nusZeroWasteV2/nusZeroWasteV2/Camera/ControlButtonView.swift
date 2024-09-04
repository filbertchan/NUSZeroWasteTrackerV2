//
//  ControlButtonView.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

struct ControlButtonView: View {
    
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .tint(.white)
                .font(.title)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    ControlButtonView(label: "Cancel", action: {})
}
