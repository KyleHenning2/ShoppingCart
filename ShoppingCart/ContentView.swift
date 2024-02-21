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
    @State private var numberOfCarts = 2;
    @State private var cartNames: [String] = ["Shopping Cart 1", "Shopping Cart 2"]
    
    var body: some View {
        List {
            ForEach(0..<numberOfCarts, id: \.self) { index in
                NavigationLink(destination: ShoppingCartView(title: self.$cartNames[index])) {
                    HStack {
                        TextField("Enter  Cart Name", text: self.$cartNames[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Shopping Cart \(index + 1)")
                    }
                    .padding()
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Shopping Carts")
        .toolbar {
            Spacer()
            ToolbarItem(placement: .principal) {
                Button(action: {
                    self.numberOfCarts += 1
                    self.cartNames.append("Shopping Cart \(self.numberOfCarts)")
                }) {
                    Text("Add Shopping Cart")
                }
            }
        }
    }
}

struct ShoppingCartView: View {
    @State private var ListText: String = ""
    @Binding var title: String
    
    
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
