import SwiftUI

struct ContentView: View {
    @State private var ListText: String = ""
    @State private var titleText: String = ""
    
    
    var body: some View {
        VStack {
            TextField("Add your list name here", text: $titleText)
                .font(.headline)
                .padding()
                .textFieldStyle(.roundedBorder)
            
            Divider()
            
            TextEditor(text: $ListText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.bottom)
    }
}
