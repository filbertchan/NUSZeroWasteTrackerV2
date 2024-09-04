import SwiftUI

struct DropdownMenuListRow: View {
    
    let option: DropdownMenuOption
    let onSelectedAction: (_ option: DropdownMenuOption) -> Void
    
    var body: some View {
        Button(action: {
            self.onSelectedAction(option)
        }) {
            Text(option.option)
                .font(.largeTitle)
                .foregroundColor(.blue) // Set text color to blue
                .overlay( // Add overlay for outline effect
                    Text(option.option)
                        .font(.largeTitle)
                        .foregroundColor(.clear) // Make the overlay text clear
                        .background(Color.clear)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.blue, lineWidth: 1) // Apply blue outline
        )
    }
}

struct DropdownMenuListRowPreview: PreviewProvider {
    static var previews: some View {
        DropdownMenuListRow(option: DropdownMenuOption.stationTest, onSelectedAction: { _ in })
    }
}
