//
//  DropdownMenuList.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 25/7/24.
//

import SwiftUI

struct DropdownMenuList: View {
    
    let options: [DropdownMenuOption]
    let onSelectedAction: (_ option: DropdownMenuOption) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(options) { option in
                    DropdownMenuListRow(option: option, onSelectedAction: self.onSelectedAction)
                }
            }
        }
        .frame(height: 500)
        .padding(.vertical, 5)
        .background(Color.black)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
        }
    }
}

struct DropdownMenuListPreview: PreviewProvider {
    static var previews: some View {
        DropdownMenuList(options: DropdownMenuOption.stationList, onSelectedAction: { _ in })
    }
}
