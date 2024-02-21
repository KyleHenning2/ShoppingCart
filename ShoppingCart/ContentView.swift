import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarTitle("Home")
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: ShoppingCartView()) {
                Text("Shopping Cart 1")
            }
            .padding()
            
            NavigationLink(destination: ShoppingCartView()) {
                Text("Shopping Cart 2")
            }
            .padding()
            
            // figure out a way to make it dynamic
        }
    }
}

struct ShoppingCartView: View {
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
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationBarTitle(titleText)
        .navigationBarItems(leading: Button(action: {}, label: {
            Text("Back")
        }))
    }
}

#Preview {
    ContentView()
}
