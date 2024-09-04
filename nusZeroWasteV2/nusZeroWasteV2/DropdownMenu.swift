import SwiftUI

struct DropdownMenu: View {
    
    @State private var isOptionsPresented: Bool = false
    @State var visible: Bool
    
    @Binding var selectedOption: DropdownMenuOption?
    @Binding var location: String
    
    let placeholder: String
    let options: [DropdownMenuOption]
        
    var body: some View {
        if visible {
            Button(action: {
                self.isOptionsPresented.toggle()
            }) {
                HStack {
                    Text(selectedOption == nil ? placeholder : selectedOption!.option)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedOption == nil ? .blue : .blue)
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 2)
            }
            .overlay(alignment: .top) {
                VStack {
                    if self.isOptionsPresented {
                        Spacer(minLength: 60)
                        DropdownMenuList(options: self.options) { option in
                            self.isOptionsPresented = false
                            self.selectedOption = option
                            self.location = option.option // Update location
                            print("Selected option: \(option.option)")
                            print("Updated location: \(self.location)")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
