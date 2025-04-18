//
//  nusZeroWasteV2App.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

@main
struct nusZeroWasteV2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                placeholder: "Select station...",
                options: DropdownMenuOption.stationList
            )
        }
    }
}


