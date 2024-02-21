import SwiftUI

struct ContentView: View {
    var body: some View {
            NavigationStack {
                HomeView()
            }
        .navigationTitle("Home")
    }
}

struct HomeView: View {
    @State private var numberOfCarts = 2
    @State private var cartNames: [String] = ["Shopping Cart 1", "Shopping Cart 2"]
    
    var body: some View {
        List {
            ForEach(cartNames.indices, id: \.self) { index in
                NavigationLink(destination: ShoppingCartView(title: self.$cartNames[index])) {
                    HStack {
                        TextField("Enter Cart Name", text: self.$cartNames[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Spacer()
                        
                        Text(self.cartNames[index])
                            .padding()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Shopping Carts")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button(action: {
                    self.numberOfCarts += 1
                    self.cartNames.append("Shopping Cart \(self.numberOfCarts)")
                }) {
                    Label("Add Shopping Cart", systemImage: "cart.badge.plus")
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
