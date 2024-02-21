import SwiftUI

struct ContentView: View {
    var body: some View {
            NavigationStack {
                HomeView()
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Home")
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: ShoppingCartView(title: "Shopping Cart 1")) {
                Text("Shopping Cart 1")
            }
            .padding()
            
            NavigationLink(destination: ShoppingCartView(title: "Shopping Cart 2")) {
                Text("Shopping Cart 2")
            }
            .padding()
            
            // figure out a way to make it dynamic
        }
    }
}

struct ShoppingCartView: View {
    @State private var ListText: String = ""
    var title: String
    
    
    var body: some View {
        VStack {
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
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationTitle(title)
    }
}

#Preview {
    ContentView()
}
