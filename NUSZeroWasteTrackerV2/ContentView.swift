//
//  ContentView.swift
//  NUSZeroWasteTrackerV2
//
//  Created by Beng Beng on 22/7/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: NUSZeroWasteTrackerV2Document

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(NUSZeroWasteTrackerV2Document()))
}
