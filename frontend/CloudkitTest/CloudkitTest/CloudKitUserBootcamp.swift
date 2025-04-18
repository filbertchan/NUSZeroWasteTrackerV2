//
//  CloudKitUserBootcamp.swift
//  CloudkitTest
//
//  Created by Beng Beng on 1/9/24.
//

import SwiftUI

class CloudKitUserBootcampViewModel: ObservableObject {
    
    init() {
        getiCloudStatus()
    }
    
    private func getiCloudStatus() {
        
        
    }
}

struct CloudKitUserBootcamp: View {
    
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct CloudKitUserBootcamp_Previews: PreviewProvider {
    static var preview: some View {
        CloudKitUserBootcamp()
    }
}
