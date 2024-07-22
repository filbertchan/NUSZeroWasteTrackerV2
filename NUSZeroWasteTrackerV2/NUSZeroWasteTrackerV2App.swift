//
//  NUSZeroWasteTrackerV2App.swift
//  NUSZeroWasteTrackerV2
//
//  Created by Beng Beng on 22/7/24.
//

import SwiftUI

@main
struct NUSZeroWasteTrackerV2App: App {
    var body: some Scene {
        DocumentGroup(newDocument: NUSZeroWasteTrackerV2Document()) { file in
            ContentView(document: file.$document)
        }
    }
}
